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
require_relative './lib/mongo_utils'

# NOTE : keyword_init is required so we can pass arguments as hash to create objects
PostSeriesDetails = Struct.new(:series_key, :series_index, :series_total, keyword_init: true)

class Main

  def get_flickr_updates
    # photos = flickr.people.getPublicPhotos(:user_id => '57125599@N00', :extras => 'description,tags,geo,date_taken,url_m,widths,sizes', per_page: 25)
    flickr_photos = @flickr.photosets.getPhotos(user_id: FlickrUtils::USER_ID,
      photoset_id: FlickrUtils::PHOTOSETS_ADD_ENTRIES,
      extras: FlickrUtils::META_DATA,
      privacy_filter: FlickrUtils::PUBLIC_PHOTOS)['photo'] || []
    
    if flickr_photos.size == 0
      return { post_details_by_id: {}, other_photos_by_album_id: [] }
    end

    photos = []
    already_published_images = MongoUtils.find_existing_entries(flickr_photos.map {|p| p.id})
    puts already_published_images.inspect

    flickr_photos.each do |photo|
      new_photo = OpenStruct.new(photo.to_hash)
      new_photo.datetaken = Date.parse(photo.datetaken)
      if already_published_images.include? photo.id
        if @options.overwrite?
          @log.info "Found existing post for #{photo.id} but overwrite flag passed".colorize(:light_black)
          new_photo.mongo_document = already_published_images[photo.id]
        else
          @log.info "Skipping photo #{photo.id} since it was already published".colorize(:light_black)
          next
        end
      end

      @log.info "adding photo #{photo.id} for processing".colorize(:light_black)
      photos << new_photo
    end

    if photos.size == 0
      return { post_details_by_id: {}, other_photos_by_album_id: [] }
    end

    photos.sort! do |a, b|
      a.datetaken <=> b.datetaken
    end

    photo_series = PhotoSeries.new(photos, @options).identify_all_series

    post_details_by_id = {}
    photos_by_album_id = Hash.new {|h, k| h[k] = []} 

    photos.each do |photo|
      @log.info "\n\nprocessing photo : #{photo.id}"
      if photo_series.all_photos_in_series.include? photo
        @log.info "Photo #{photo.id} part of series, but deleting for now".colorize(:red)
        photo_series.all_photos_in_series.delete photo

        post_series.each do |ps|
          if ps.include? photo
            ps.delete photo
            @log.info "deleting photo #{photo.id} from series for now".colorize(:red)
            break
          end
        end
      else

        # get raw tags for these photos 
        photo_details = @flickr.photos.getInfo(user_id: FlickrUtils::USER_ID, photo_id: photo.id)
        photo.tags = FlickrUtils.parse_tags_from_get_info(photo_details)

        if photo.tags.empty?
          # TODO : remove from photo_series.all_photos_in_series and post_series too. 
          # TODO : We should move all photo series related logic to its own class
          @log.info "skipping entry for photo #{photo.id} because no tags were found".colorize(:red)
          next
        end
      end

      context = pick_right_album(photo.id)
      post_details = PostDetails.new(
        featured: photo.tags.include?('feature'), photoset: context, main_photo: photo,
        skip_chatgpt: @options.skip_chatgpt?, description: ""
      )
      post_series_details = photo_series.get_post_series_details(photo, post_details.post_id)
      @log.info "Series details for #{photo.id} are : #{post_series_details.inspect}"
      post_details.post_series_details = post_series_details
      post_details.description = post_description(post_details, photo)
      post_details_by_id[context.id] = post_details

      # get 5 interesting pictures from that context (photoset) and add it to that post
      photos_by_album_id[context.id] = FlickrUtils.get_interesting_photos_from_context(@flickr, photo, context.id)
    end

    { post_details_by_id: post_details_by_id, other_photos_by_album_id: photos_by_album_id }
  end

  ALBUMS_TO_EXCLUDE = Set.new(['72157625959432202', '72157626158864809', '72157632530995971', '72157627450386271', '72157627406881246',
    '72177720308606044',
    '72157631893755538', '72157632619044349', '72157634432152201', '72157636078849264', '72157608913112539', '72157644421565063', '72177720307946395'])
  FLICKR_ALBUM_LINK = 'https://www.flickr.com/photos/amityville/albums/'

  def pick_right_album(photo_id)
    contexts = @flickr.photos.getAllContexts(photo_id: photo_id)['set']
    # if @options.verbose?
    #   puts "--------------- contexts are ---------------- "
    #   puts contexts.inspect
    # end

    candidates = contexts.filter {|c| !ALBUMS_TO_EXCLUDE.include?(c.id) }
    if candidates.empty?
      puts "for photo #{photo.id} could not find any other albums so skipping entry".colorize(:red)
    elsif candidates.size > 1
      puts "for photo #{photo.id}, found multiple albums, not sure which to pick. Skipping".colorize(:red)
      candidates.each do |album_id|
        puts (FLICKR_ALBUM_LINK + album_id.to_s).colorize(:red)
      end
    end

    candidates.first
  end

  def post_description(post_details, photo)
    if (photo['description'] || '').length > 10
      puts "skipping chatgpt call since description found in main photo".colorize(:orange)
      return photo['description']
    end

    category = FlickrCreatePost.categorize(post_details.description)
    prompt = ChatGptHelpers.chat_gpt_blog_prompt(post_details, photo)
    # if category == 'hiking'
    #   prompt = "I live in Washington state. Write 2 paragraphs about a hike I did. Todays date is #{Date.today}. " + 
    #   "The hike was done on #{post_details.date_taken} date. " + 
    #   " The description should be based on these keywords and based on facts related to the hike : "
    # else
    #   prompt = "Write two short paragraphs for a travel blog. Todays date is #{Date.today}. " + 
    #   "The blog entry is for #{post_details.date_taken} date. The blog is based on these keywords : "
    # end
    # prompt += "#{photo.tags.join(', ')} . Do not use superlatives."
    # if rand() * 10 >= 5
    #   prompt += "Write the blog entry in first person."
    # end

    # puts "chatgpt prompt is : #{prompt}"
    return ChatGptHelpers.davinci(prompt, @options.skip_chatgpt?)
  end

  def initialize
    @log = Logger.new(STDOUT)

    # @log.formatter = proc do |severity, datetime, progname, msg|
    #   "#{severity}: [ #{datetime.strftime("%I:%M%p")} ] -- #{msg}\n"
    # end

    # original_formatter = Logger::Formatter.new
    # @log.formatter = proc { |severity, datetime, progname, msg|
    #   original_formatter.call(severity, datetime, progname, msg.dump)
    # }
    @log.info("Running script...")

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

    @options.verbose? ? @log.level = Logger::Severity::DEBUG : @log.level = Logger::Severity::INFO
    @log.info "Skipping chatgpt calls".green if @options.skip_chatgpt?
    @log.warn "dry run" if @options.dry_run?
    @log.warn "overwriting existing posts".red if @options.overwrite?

    Flickr.cache = '/tmp/flickr-api.yml'
    @flickr = Flickr.new

    data = get_flickr_updates

    flickr_post = FlickrCreatePost.new(@flickr, @options)
    flickr_post.create_posts(data)

    # data[:post_details_by_id].each do |photoset_id, post_details|
    #   FlickrCreatePost.new(@flickr, @options).create_post(post_details, data[:other_photos_by_album_id])
    # end

  end

end

Main.new