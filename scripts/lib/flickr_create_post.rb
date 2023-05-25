class FlickrCreatePost
  
  def initialize(options)
    @options = options
  end
  
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
      title: post_details.post_title,
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

    if File.exists? file_path
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
%{optional_entries}
---
%{description}

%{flickr_images}
'

end