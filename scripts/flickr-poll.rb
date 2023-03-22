#!/usr/bin/env ruby
require 'flickr'
require "down"
require "fileutils"

# The credentials can be provided as parameters:

# flickr = Flickr.new "YOUR API KEY", "YOUR SHARED SECRET"

# Alternatively, if the API key and Shared Secret are not provided, Flickr will attempt to read them
# from environment variables:
# ENV['FLICKR_API_KEY']
# ENV['FLICKR_SHARED_SECRET']

PostDetails = Struct.new(:featured, :photoset, :main_photo, :post_file_name, keyword_init: true) do 
  def categories
    main_photo.tags
  end

  def image_alt_text
    photoset.title
  end

  def image_dir
    dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
  end

  def image_file_name
    main_photo['title'].gsub(' ', '-') + '.jpg'
  end
end

class Main
  def self.get_flickr_updates

    Flickr.cache = '/tmp/flickr-api.yml'
    flickr = Flickr.new

    # Flickr will raise an error if either parameter is not explicitly provided, or available via environment variables.

    list   = flickr.photos.getRecent

    id     = list[0].id
    secret = list[0].secret
    info   = flickr.photos.getInfo :photo_id => id, :secret => secret

    puts info.title           # => "PICT986"
    puts info.dates.taken     # => "2006-07-06 15:16:18"

    sizes = flickr.photos.getSizes :photo_id => id

    original = sizes.find { |s| s.label == 'Original' }
    # puts original.width       # => "800" -- may fail if they have no original marked image

    info = flickr.photos.getInfo(:photo_id => "3839885270")
    Flickr.url_short(info) # => "https://flic.kr/p/6Rjq7s"

    photos = flickr.people.getPublicPhotos(:user_id => '57125599@N00', :extras => 'description,tags,geo,date_taken,url_m', per_page: 25)

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

    photos.each do |photo|
      # puts photo.id
      unless photo.tags.include?('jekyllsite')
        next
        puts "Skipping photo due to missing tag " + photo.tags + " " + photo.id
      end
      if photo.tags.include? 'main'
        puts "main photo found " + photo.inspect
        post_file_name = get_post_filename(photo)
        puts post_file_name
        puts File.exists? '_posts/' + post_file_name
        # FIXME : using the 1st photoset for now
        context = flickr.photos.getAllContexts(photo_id: photo.id)['set'].last
        # puts "photoset id : " + context.inspect
        if post_details_by_id.include? context.id
          puts "already handled this photoset so skipping " + context.id 
        else
          puts "found new photoset " + context.id
          post_details = PostDetails.new(featured: true, photoset: context, main_photo: photo, post_file_name: post_file_name)
          post_details_by_id[context.id] = post_details
          # hsh['categories'] = photo.tags
          # hsh['image_alt_text'] = context.title
        end
      end
    end

    post_details_by_id.values
  end

  def self.save_main_image(photo)
    dir_path = './assets/images/' +  photo["datetaken"].split(' ').first + '/'
    puts "dir name is #{dir_path}"
      FileUtils.mkdir_p(dir_path)
    file_name = dir_path + photo['title'].gsub(' ', '-') + '.jpg'
    puts "saving to location #{file_name}"
    if File.exists? file_name
      puts "Image already downloaded. Skipping : " + file_name
      return file_name
    end
    url = photo['url_m']
    puts "saving iamge to #{file_name}" 
    tempfile = Down.download(url)
    FileUtils.mv(tempfile.path, "#{file_name}")

    return file_name
  end

  def self.get_post_filename(photo)
    # {"id"=>"52762914260", "owner"=>"57125599@N00", "secret"=>"14aa2ef94b", "server"=>"65535", "farm"=>66, "title"=>"Main",
    # "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "description"=>"Great hike", "datetaken"=>"2023-03-16 12:25:05",
    # "datetakengranularity"=>0, "datetakenunknown"=>"0", "tags"=>"jekyllsite anothertag yet another tag main", 
    # "latitude"=>"47.429444", "longitude"=>"-121.381578", "accuracy"=>"16", "context"=>0, "place_id"=>"", "woeid"=>"5798083", 
    # "geo_is_public"=>1, "geo_is_contact"=>0, "geo_is_friend"=>0, "geo_is_family"=>0, 
    # "url_m"=>"https://live.staticflickr.com/65535/52762914260_14aa2ef94b.jpg", "height_m"=>500, "width_m"=>361}

    file_name = photo["datetaken"].split(' ').first + '-' + photo["title"].gsub(' ', '-')
    file_path = '_posts/' + file_name + '.markdown'
    puts file_path
    puts File.exists? file_path
    return file_path
  end

  # result = "Breed %{b} size %{z}" % {b: breed, z: size}
  POST_TEMPLATE = '---
layout: post
categories: %{categories}
author: amit
image: %{image_path}
image_alt_text: %{image_alt_text}
featured: %{featured}
photoset: %{photoset_id}
---
%{description}
  '

  def self.create_post(post_details)
    puts post_details.inspect
    file_path = post_details[:post_file_name]
    puts "post file path : #{file_path}"
    if File.exists? file_path
      puts file_path + ' already exists. NOT overriding'
      return
    end

    post_str = POST_TEMPLATE % post_details
    puts "writing to file : " + file_path
    File.open(file_path, 'w') do |out_file|
      out_file.puts post_str
    end
    # puts post_str
  end

  def self.run
    all_post_details = get_flickr_updates()
    all_post_details.each do |post_details|
      puts '-------------------'
      puts post_details.inspect
      image_path = save_main_image(post_details.main_photo)
      post_hash = {
        post_file_name: post_details.post_file_name,
        categories: post_details.categories,
        image_path: image_path,
        image_alt_text: post_details.photoset['title'],
        featured: post_details.featured,
        photoset_id: post_details.photoset['id'],
        description: post_details.main_photo['description']
      }
      create_post(post_hash)
    end
  end

end

Main.run

# file_name = Main.get_post_filename({'datetaken' => '2023-03-16 12:25:05', 'title' => 'mt dickerman winter route 2023'})

# post_details = {categories: 'snow capped mt', image_path: 'assets/images/06-05-17/mt-dickerman.jpg',
#   alt_image_text: 'mt dickerman', photoset_id: 72177720306901699, description: 'some desci'
# }
# Main.create_post(file_name, post_details)

# photo = {"id"=>"52762914260", "owner"=>"57125599@N00", "secret"=>"14aa2ef94b", "server"=>"65535", "farm"=>66, "title"=>"Main", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "description"=>"Great hike", "datetaken"=>"2023-03-16 12:25:05", "datetakengranularity"=>0, "datetakenunknown"=>"0", "tags"=>"jekyllsite anothertag yet another tag main", "latitude"=>"47.429444", "longitude"=>"-121.381578", "accuracy"=>"16", "context"=>0, "place_id"=>"", "woeid"=>"5798083", "geo_is_public"=>1, "geo_is_contact"=>0, "geo_is_friend"=>0, "geo_is_family"=>0, "url_m"=>"https://live.staticflickr.com/65535/52762914260_14aa2ef94b.jpg", "height_m"=>500, "width_m"=>361}
# Main.save_main_image(photo)

# get all photos in last 1h
# get unique albums for each photo with a main photo
# for each album see if there is a post already created - store in yml file ? 
# if not found 
  #  get album meta data to make draft post
  #  create new draft post via jekyll draft command line
  #  add tag listing that photo was added to jekyll blog
  #  print out message