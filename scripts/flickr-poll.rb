#!/usr/bin/env ruby
require 'flickr'
require "down"
require "fileutils"
require "openai"
require "date"
require "set"
require "colorize"
require "slop"
require "logger"
require 'date'
require "ostruct"
require_relative './lib/chat_gpt_helpers'

# The credentials can be provided as parameters:

# flickr = Flickr.new "YOUR API KEY", "YOUR SHARED SECRET"

# Alternatively, if the API key and Shared Secret are not provided, Flickr will attempt to read them
# from environment variables:
# ENV['FLICKR_API_KEY']
# ENV['FLICKR_SHARED_SECRET']


PostDetails = Struct.new(:featured, :photoset, :main_photo, :categories, :description, :skip_chatgpt, keyword_init: true) do 
  def image_alt_text
    photoset.title
  end

  def date_taken
    @date_taken ||= Date.parse(main_photo["datetaken"])
  end

  def image_dir
    dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
  end

  def post_id
    @post_id ||= if main_photo['title'].strip.empty? 
                    main_photo['title'].gsub(/\s+/, ' ').gsub(' ', '-')
                    content = "pick one name of a place from #{categories}"
                    messages = ChatGptHelpers.compute_turbo_input(content)
                    res = ChatGptHelpers.chatgpt_turbo_35(messages, skip_chatgpt)
                    res.downcase.gsub(' ', '-')
                  else 
                    main_photo['title'].gsub(/\s+/, ' ').gsub(' ', '-')
                  end
    @post_id
  end

  def image_file_name
     post_id + '.jpg'
  end

  def post_file_name
    file_name = main_photo["datetaken"].strftime('%Y-%m-%d') + '-' + post_id
    file_path = '_posts/' + file_name + '.markdown'
    return file_path
  end

end

PHOTOSETS_ADD_ENTRIES = '72177720307946395'
USER_ID = '57125599@N00'
PUBLIC_PHOTOS = 1
META_DATA = 'description,tags,date_taken,url_m,widths,sizes,views'
UNIQUE_FLICKR_ID_FILE_PATH = '_data/flickr/unique_photo_ids.yml'

class Main
  def diff_in_days(p1, p2)
    diff = (p1.datetaken - p2.datetaken).abs
    return diff / (24 * 60 * 60)
  end

  def find_photo_series(photos)
    post_series = [] # array of arrays, one for each series
    all_photos_in_series = Set.new
    series_id = 0
    in_series = false

    index = 1
    curr_p = photos[0]
    while (photos.size > 0 && index < photos.size)
      next_p = photos[index]
      day_diff = (next_p.datetaken - curr_p.datetaken).round
      if day_diff <= 1     
        in_series = true
        # is part of series
        photo_set = post_series[series_id] ||= Set.new
        photo_set << curr_p
        photo_set << next_p
        all_photos_in_series << curr_p
        all_photos_in_series << next_p
      else
        if in_series
          in_series = false
          series_id += 1
        end
      end

      curr_p = next_p
      index += 1
    end

    post_series.each_with_index do |ps, idx|
      ps.each do |p| puts [idx, p.id, p.datetaken].inspect end
    end

    puts photos.size
    { post_series: post_series, all_photos_in_series: all_photos_in_series }
  end

  def get_flickr_updates

    Flickr.cache = '/tmp/flickr-api.yml'
    flickr = Flickr.new

    # photos = flickr.people.getPublicPhotos(:user_id => '57125599@N00', :extras => 'description,tags,geo,date_taken,url_m,widths,sizes', per_page: 25)
    flickr_photos = flickr.photosets.getPhotos(user_id: USER_ID, photoset_id: PHOTOSETS_ADD_ENTRIES, extras: META_DATA, privacy_filter: PUBLIC_PHOTOS)['photo'] || []
    
    if flickr_photos.size == 0
      return { post_details_by_id: {}, other_photos_by_album_id: [] }
    end
    
    photos = []
    flickr_photos.each do |photo|
      new_photo = OpenStruct.new(photo.to_hash)
      new_photo.datetaken = Date.parse(photo.datetaken)
      photos << new_photo
    end

    photos.sort! do |a, b|
      a.datetaken <=> b.datetaken
    end

    series_info = find_photo_series(photos)
 
    exit 0

    post_details_by_id = {}
    photos_by_album_id = Hash.new {|h, k| h[k] = []} 


    # sort all photos by date taken
    # remove all photos which belong to series. 
    # create hash[series_key] = [photoId1, photoId2]

    #   TODO : if existing posts are found, then use awk magic to insert / update series related info there

    # process remaining photos as usual

    photos.each do |photo|
      if @flick_ids.include? photo.id
        puts "Photo with id #{photo.id} already exists. Skipping"
        next
      else
        @flick_ids << photo.id
        @new_flick_ids << photo.id
      end

      contexts = flickr.photos.getAllContexts(photo_id: photo.id)['set']
      next unless contexts && !contexts.empty?
      if @options.verbose?
        puts "--------------- contexts are ---------------- "
        puts contexts.inspect
      end
      context = contexts.find {|c| c.id != PHOTOSETS_ADD_ENTRIES}
      unless context
        puts "for photo #{photo.id} could not find any other albums so skipping entry".colorize(:red)
        next
      end

      raw_categories = photo.tags.split(' ').select {|tag| !['jsu', 'js', 'jsd', 'main'].include?(tag)}.uniq.join(' ')
      if raw_categories.strip == ""
        puts "skipping entry for photo #{photo.id} because no categories were found".colorize(:red)
        next
      end

      content = "Give me the valid words from #{raw_categories}"
      messages = ChatGptHelpers.compute_turbo_input(content)
      categories = ChatGptHelpers.chatgpt_turbo_35(messages, @options.skip_chatgpt?)
      post_details = PostDetails.new(featured: photo.tags.include?('feature'), photoset: context, main_photo: photo, categories: categories, skip_chatgpt: @options.skip_chatgpt?, description: "")
      post_details.description = post_description(post_details, photo)
      post_details_by_id[context.id] = post_details

      # get 5 interesting pictures from that context (photoset) and add it to that post
      photos_by_album_id[context.id] = get_interesting_photos_from_context(flickr, photo, context.id)
    end

    { post_details_by_id: post_details_by_id, other_photos_by_album_id: photos_by_album_id }
  end

  def get_interesting_photos_from_context(flickr, photo, context_id)
    date_taken = photo.datetaken.strftime('%Y-%m-%d')
    # puts "looking up all photos in album #{context_id}"
    photos = (flickr.photosets.getPhotos(user_id: USER_ID, photoset_id: context_id, extras: META_DATA, privacy_filter: PUBLIC_PHOTOS)['photo'] || [])
    
    photos.sort! do |a, b|
      b.views.to_i <=> a.views.to_i
    end
    
    return photos[0..4]
  end

  def post_description(post_details, photo)
    if (photo['description'] || '').length > 10
      puts "skipping chatgpt call since description found in main photo".colorize(:orange)
      return photo['description']
    end

    # return ""
    prompt = "write a short paragraph for a travel blog with keywords #{post_details.categories}"
    if rand() * 10 >= 5
      prompt += " in first person point of view."
    end

    puts "chatgpt prompt is : #{prompt}"
    return ChatGptHelpers.davinci(prompt, @options.skip_chatgpt?)
  end

  FLICKR_IMAGE_TEMPLATE = '
  flickr %{photo_id} "%{photo_title}" style="float: right;"
  '

  SERIES_TEMPLATE = '
  series_key: %{series_key}
  series_index: %{series_index}
  series_total: %{series_total}
  '

  POST_TEMPLATE = '---
layout: post
title: %{title}
date: %{date}
categories: [%{categories}]
author: amit
image: %{image_path}
image_alt_text: %{image_alt_text}
featured: %{featured}
photoset: %{photoset_id}
%{optional_entries}
---
%{description}

%{flickr_images}
  '

  def categorize(categories)
    if categories.match?('travel')
      'travel'
    elsif categories.match?('hike|hiking|trail|mountain|climb')
      'hiking'
    else
      'all'
    end
  end

  def create_post(post_details, other_photos_by_album)
    post_hash = {
      post_file_name: post_details.post_file_name,
      title: post_details.photoset['title'],
      date: post_details.main_photo['datetaken'],
      categories: categorize(post_details.description),
      image_path: post_details.main_photo['url_m'],
      image_alt_text: post_details.photoset['title'],
      featured: post_details.featured,
      photoset_id: post_details.photoset['id'],
      description: post_details.description
    }

    required_fields = %w{ post_file_name title date image_path photoset_id }
    required_fields.each do |required_field|
      key = required_field.to_sym
      if post_hash[key] == '' || post_hash[key] == nil
        puts "skipping entry for photo due to missing required field #{required_field}. Photo details : #{post_details.inspect}".colorize(:red)
        return
      end
    end

    if post_details.post_id == ""
      puts "cannot create post_id so skipping for post : #{post_details}".colorize(:red)
    end
    file_path = post_details.post_file_name

    updating_post = false
    if File.exists? file_path
      updating_post = true
      if @options.overwrite?
        puts 'overwrite flag is set so deleting existing file'.colorize(:orange)
        File.delete(file_path)
      else
        puts file_path + ' already exists. NOT overriding'.colorize(:green)
        return
      end
    end

    flickr_images = ''
    other_photos = other_photos_by_album[post_details.photoset['id']]
    other_photos.each_with_index do |photo, i|
      puts photo.inspect.colorize(:light_black)
      hsh = {
        photo_id: photo['id'],
        photo_title: (photo['title'] || ''),
      }
      str = FLICKR_IMAGE_TEMPLATE % hsh
      flickr_images += "{% #{str} %}\n"
      break if i == 5
    end

    post_hash[:flickr_images] = flickr_images

    post_str = POST_TEMPLATE % post_hash
    puts "writing to file : " + file_path if @options.verbose?
    unless @options.dry_run?
      File.open(file_path, 'w') do |out_file|
        out_file.puts post_str
      end
    else
      puts "dry-run : skipping writing to file #{file_path}"
    end
  end

  def initialize
    @log = Logger.new(STDOUT)
    @log.debug("Running script...")

    # dump_unique_flick_ids
    @flick_ids = Set.new load_unique_flickr_ids
    @new_flick_ids = Set.new

    @log.formatter = proc do |severity, datetime, progname, msg|
      "#{severity}: [ #{datetime.strftime("%I:%M%p")} ] -- #{msg}\n"
    end

    # original_formatter = Logger::Formatter.new
    # @log.formatter = proc { |severity, datetime, progname, msg|
    #   original_formatter.call(severity, datetime, progname, msg.dump)
    # }
    @log.debug("Running script...")

    @options = Slop.parse do |o|
      o.bool '-o', '--overwrite', 'overwrite existing blog entries', default: false
      o.bool '-d', '--dry-run', 'dont create any posts'
      o.bool '-s', '--skip-chatgpt', 'skip calling chat gpt', default: false
      o.bool '-v', '--verbose', 'enable verbose mode', default: false
      o.on '-h', 'options' do
        puts "This script pulls from various flickr albums and creates / updates posts in jekyl"
        puts o
        exit
      end
    end

    data = get_flickr_updates

    data[:post_details_by_id].each do |photoset_id, post_details|
      raw_categories = post_details.main_photo.tags.split(' ').select {|tag| !['jsu', 'js', 'jsd', 'main'].include?(tag)}.uniq.join(' ')
      create_post(post_details, data[:other_photos_by_album_id])
    end

    dump_unique_flick_ids
  end

  def load_unique_flickr_ids
    flick_ids = YAML.load(File.read(UNIQUE_FLICKR_ID_FILE_PATH))
    puts flick_ids.inspect

    return flick_ids
  end

  def dump_unique_flick_ids
    puts "existing ids : "
    puts @flick_ids.inspect

    puts "new ids : "
    puts @new_flick_ids.inspect
    File.open(UNIQUE_FLICKR_ID_FILE_PATH, "w+") { |file| file.write(@new_flick_ids.to_a.to_yaml) } unless @options.dry_run?
  end

end

Main.new