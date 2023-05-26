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
require_relative './lib/post_details'
require_relative './lib/photo_series'
require_relative './lib/flickr_create_post'
require_relative './lib/flickr_utils'

# NOTE : keyword_init is required so we can pass arguments as hash to create objects
PostSeriesDetails = Struct.new(:series_key, :series_index, :series_total, keyword_init: true)

PHOTOSETS_ADD_ENTRIES = '72177720307946395'
USER_ID = '57125599@N00'
PUBLIC_PHOTOS = 1
META_DATA = 'description,date_taken,url_m,widths,sizes,views'
UNIQUE_FLICKR_ID_FILE_PATH = '_data/flickr/unique_photo_ids.yml'

class Main
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

    photo_series = PhotoSeries.new(photos, @options).identify_all_series

    post_details_by_id = {}
    photos_by_album_id = Hash.new {|h, k| h[k] = []} 

    photos.each do |photo|
      puts "\n\nprocessing photo : #{photo.id}"
      # TODO : if existing posts are found, then use awk magic to insert / update series related info there
      if @flick_ids.include? photo.id
        puts "Photo with id #{photo.id} already exists. Skipping"

        if photo_series.all_photos_in_series.include? photo
          puts "Photo #{photo.id} part of series, but deleting for now".colorize(:red)
          photo_series.all_photos_in_series.delete photo

          post_series.each do |ps|
            if ps.include? photo
              ps.delete photo
              puts "deleting photo #{photo.id} from series for now".colorize(:red)
              break
            end
          end
        end
        next
      else
        @flick_ids << photo.id
        @new_flick_ids << photo.id

        # get raw tags for these photos 
        photo_details = flickr.photos.getInfo(user_id: USER_ID, photo_id: photo.id)
        photo.tags = FlickrUtils.parse_tags_from_get_info(photo_details)

        if photo.tags.empty?
          # TODO : remove from photo_series.all_photos_in_series and post_series too. 
          # TODO : We should move all photo series related logic to its own class
          puts "skipping entry for photo #{photo.id} because no tags were found".colorize(:red)
          next
        end
      end

      contexts = flickr.photos.getAllContexts(photo_id: photo.id)['set']
      next unless contexts && !contexts.empty?
      # if @options.verbose?
      #   puts "--------------- contexts are ---------------- "
      #   puts contexts.inspect
      # end
      context = contexts.find {|c| c.id != PHOTOSETS_ADD_ENTRIES}
      unless context
        puts "for photo #{photo.id} could not find any other albums so skipping entry".colorize(:red)
        next
      end

      post_details = PostDetails.new(
        featured: photo.tags.include?('feature'), photoset: context, main_photo: photo,
        skip_chatgpt: @options.skip_chatgpt?, description: ""
      )
      post_series_details = photo_series.get_post_series_details(photo, post_details.post_id)
      puts "Series details for #{photo.id} are : #{post_series_details.inspect}"
      post_details.post_series_details = post_series_details
      post_details.description = post_description(post_details, photo)
      post_details_by_id[context.id] = post_details

      # get 5 interesting pictures from that context (photoset) and add it to that post
      photos_by_album_id[context.id] = FlickrUtils.get_interesting_photos_from_context(flickr, photo, context.id)
    end

    { post_details_by_id: post_details_by_id, other_photos_by_album_id: photos_by_album_id }
  end

  def post_description(post_details, photo)
    if (photo['description'] || '').length > 10
      puts "skipping chatgpt call since description found in main photo".colorize(:orange)
      return photo['description']
    end

    # return ""
    prompt = "write a short paragraph for a travel blog with keywords #{photo.tags.join(', ')}"
    if rand() * 10 >= 5
      prompt += " in first person point of view."
    end

    puts "chatgpt prompt is : #{prompt}"
    return ChatGptHelpers.davinci(prompt, @options.skip_chatgpt?)
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
      FlickrCreatePost.new(@options).create_post(post_details, data[:other_photos_by_album_id])
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