#!/usr/bin/env ruby
require 'flickr'
require "down"
require "fileutils"
require "openai"
require "date"
require "set"
require "colorize"
require "slop"

# The credentials can be provided as parameters:

# flickr = Flickr.new "YOUR API KEY", "YOUR SHARED SECRET"

# Alternatively, if the API key and Shared Secret are not provided, Flickr will attempt to read them
# from environment variables:
# ENV['FLICKR_API_KEY']
# ENV['FLICKR_SHARED_SECRET']

module ChatGptHelpers
  def self.compute_turbo_input(content)
    return [
        {
            "role": "system",
            "content": "You return valid words in groups as csv"
        },
        {
            "role": "user",
            "content": content
        }
    ]
  end

  def self.chatgpt_turbo_35(messages)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end

    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        "model" => "gpt-3.5-turbo",
        "messages" => messages,
        "temperature" => 0,
      }
    )

    puts messages.inspect.colorize(:blue)
    puts response.inspect.colorize(:blue)
    if response["choices"]
      return response["choices"].first["message"]["content"]
    else 
      STDERR.puts response.inspect
      return ""
    end

  end

  def self.davinci(prompt)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end

    client = OpenAI::Client.new

    response = client.completions(
      parameters: {
          model: "text-davinci-003",
          prompt: prompt,
          max_tokens: 512
    #     # temperature: 0, # show the low risk text options
    #     # frequency_penalty: 0,
    #     # presence_penalty: 0,
      })

    if response["choices"]
      # puts response["choices"].map { |c| c["text"] }

      puts response.inspect.colorize(:blue)
      return response["choices"].first["text"] 
    else 
      STDERR.puts response.inspect
      return ""
    end

  end


end


PostDetails = Struct.new(:featured, :photoset, :main_photo, :categories, :description, keyword_init: true) do 
  def image_alt_text
    photoset.title
  end

  def date_taken
    @date_taken ||= main_photo["datetaken"].split(' ').first
  end

  def image_dir
    dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
  end

  def post_id
    @post_id ||= if main_photo['title'].strip.empty? 
                    main_photo['title'].gsub(/\s+/, ' ').gsub(' ', '-')
                    content = "pick one name of a place from #{categories}"
                    messages = ChatGptHelpers.compute_turbo_input(content)
                    res = ChatGptHelpers.chatgpt_turbo_35(messages)
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
    file_name = main_photo["datetaken"].split(' ').first + '-' + post_id
    file_path = '_posts/' + file_name + '.markdown'
    return file_path
  end

end

PHOTOSETS_ADD_ENTRIES = '72177720307946395'
USER_ID = '57125599@N00'
PUBLIC_PHOTOS = 1
META_DATA = 'description,tags,date_taken,url_m,widths,sizes,views'

class Main
  def get_flickr_updates

    Flickr.cache = '/tmp/flickr-api.yml'
    flickr = Flickr.new

    # photos = flickr.people.getPublicPhotos(:user_id => '57125599@N00', :extras => 'description,tags,geo,date_taken,url_m,widths,sizes', per_page: 25)
    photos = flickr.photosets.getPhotos(user_id: USER_ID, photoset_id: PHOTOSETS_ADD_ENTRIES, extras: META_DATA, privacy_filter: PUBLIC_PHOTOS)['photo'] || []
    puts photos.inspect

=begin
---
layout: post
categories: hiking pnw amit baloo winter
author: amit
image: assets/images/06-05-17/mt-dickerman.jpg
image_alt_text: snow capped Mt Dickerman
featured: false
photoset: 72157650991053255
---

> [Mt Dickerman](https://www.wta.org/go-hiking/hikes/mount-dickerman){:target="\_blank"} is one of the premier hikes in the Pacific North West. It is a beast of a climb but the rewards are amazing.

Not too shabby along the way too
{% flickr 16432337040 "Blue bird day" style="float: right;" %}
{% flickr 16618229831 "My buddy Eric hiking up" style="float: right;" %}

=end

    post_details_by_id = {}
    photos_by_album_id = Hash.new {|h, k| h[k] = []} 

    photos.each do |photo|
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
      categories = ChatGptHelpers.chatgpt_turbo_35(messages)
      post_details = PostDetails.new(featured: photo.tags.include?('feature'), photoset: context, main_photo: photo, categories: categories, description: "")
      post_details.description = post_description(post_details, photo)
      post_details_by_id[context.id] = post_details

      # get 5 interesting pictures from that context (photoset) and add it to that post
      photos_by_album_id[context.id] = get_interesting_photos_from_context(flickr, photo, context.id)
    end

    { post_details_by_id: post_details_by_id, other_photos_by_album_id: photos_by_album_id }
  end

  def get_interesting_photos_from_context(flickr, photo, context_id)
    date_taken = DateTime.parse(photo.datetaken).strftime('%Y-%m-%d')
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
    return ChatGptHelpers.davinci(prompt)
  end

  FLICKR_IMAGE_TEMPLATE = '
  flickr %{photo_id} "%{photo_title}" style="float: right;"
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
        # File.delete(file_path)
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
    end
  end

  def run
    @options = Slop.parse do |o|
      o.bool '-o', '--overwrite', 'overwrite existing blog entries', default: false
      o.bool '-d', '--dry-run', 'dont create any posts'
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
  end

end

program = Main.new
program.run