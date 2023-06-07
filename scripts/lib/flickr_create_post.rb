require 'date'
require 'colorize'
require_relative './mongo_utils'

class FlickrCreatePost

  def initialize(flickr, options)
    @flickr_client = flickr
    @options = options
  end

  def create_posts(data)
    @mongo_client = MongoUtils.mongo_db_connect
    begin
      data[:post_details_by_id].each do |photoset_id, post_details|
        create_post(post_details, data[:other_photos_by_album_id])
      end
    rescue Mongo::Error::OperationFailure => ex
      puts ex
      exit -1
    ensure
      @mongo_client.close
    end
  end

  def self.categorize(categories)
    if categories.match?('travel')
      'travel'
    elsif categories.match?('hike|hiking|trail|mountain|climb')
      'hiking'
    else
      'all'
    end
  end

  #######
  private
  #######
  
  def photo_found?(photo_id)
    count = MongoUtils.photos_processed_collection(@mongo_client).find(photo_id: photo_id).count()
    count == 1
  end
  
  def add_to_processed_photo_flick_album(post_details)
    db = @mongo_client.database
    collection = MongoUtils.photos_processed_collection(@mongo_client)
    collection.indexes.create_one({ photo_id: 1 }, unique: true)
    # update = compute_post_hash(post_details)
    update = {
      "$set" => compute_post_hash(post_details),
      "$setOnInsert" => { createdAt: Time.now().utc }
    }
    filter = { photo_id: post_details.main_photo.id }
    # https://www.mongodb.com/docs/manual/reference/method/db.collection.updateOne/
    update_options = { upsert: true }
    result = collection.update_one(
      filter,
      update,
      update_options
    )
    puts "added 1 entry to #{MongoUtils::PHOTOS_PROCESSED_DB_NAME}".green
  end

  def compute_post_hash(post_details)
    {
      post_file_name: post_details.post_file_name,
      title: post_details.post_title,
      date: post_details.main_photo['datetaken'],
      categories: self.class.categorize(post_details.description),
      image_path: post_details.main_photo['url_m'],
      image_alt_text: post_details.photoset['title'],
      featured: post_details.featured,
      photo_id: post_details.main_photo.id,
      photoset_id: post_details.photoset['id'],
      description: post_details.description
    }
  end

  def create_post(post_details, other_photos_by_album)
    # if photo_found? post_details.main_photo.id
    #   if @options.overwrite?
    #     puts "Entry already exists for #{post_details.main_photo.id} but Overwrite found".colorize(:orange)
    #   else
    #     puts "Entry already exists for #{post_details.main_photo.id} skipping".colorize(:orange)
    #   end
    #   return
    # end

    post_hash = compute_post_hash(post_details)

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
      return
    end
    file_path = post_details.post_file_name

    if File.exists? file_path
      if @options.overwrite?
        puts 'overwrite flag is set so deleting existing file'.colorize(:orange)
        File.delete(file_path)
      else
        add_to_processed_photo_flick_album(post_details)
        puts file_path + ' already exists. NOT overriding'.colorize(:green)
        return
      end
    end

    flickr_images = ''
    other_photos = other_photos_by_album[post_details.photoset['id']]
    other_photos.each_with_index do |photo, i|
      # puts photo.inspect.colorize(:light_black)
      hsh = {
        photo_id: photo['id'],
        photo_title: (photo['title'] || ''),
      }
      str = FLICKR_IMAGE_TEMPLATE % hsh
      flickr_images += "{% #{str} %}\n"
      break if i == 5
    end

    post_hash[:flickr_images] = flickr_images

    optional_entries = ""
    if post_details.post_series_details
      hsh = {
        series_key: post_details.post_series_details.series_key,
        series_index: (post_details.post_series_details.series_index + 1),
        series_total: post_details.post_series_details.series_total
      }

      optional_entries = SERIES_TEMPLATE % hsh
    end

    puts "Optional entries "
    puts optional_entries.inspect.colorize(:green)
    post_hash[:optional_entries] = optional_entries

    post_str = POST_TEMPLATE % post_hash
    puts "writing to file : " + file_path # if @options.verbose?
    unless @options.dry_run?
      File.open(file_path, 'w') do |out_file|
        out_file.puts post_str
      end
      add_to_processed_photo_flick_album(post_details)
    else
      puts "dry-run : skipping writing to file #{file_path}"
    end
  end

  FLICKR_IMAGE_TEMPLATE = 'flickr %{photo_id} "%{photo_title}" style="float: right;"
'

  SERIES_TEMPLATE = 'series_key: %{series_key}
series_index: %{series_index}
series_total: %{series_total}
'

  POST_TEMPLATE = '---
layout: post
title: "%{title}"
date: %{date}
categories: [%{categories}]
author: amit
image: %{image_path}
image_alt_text: "%{image_alt_text}"
featured: %{featured}
photoset: %{photoset_id}
photo_id: %{photo_id} # this id is the unique id for the post
%{optional_entries}
---
%{description}

%{flickr_images}
'

end