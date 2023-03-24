#!/usr/bin/env ruby
require 'flickr'
require "down"
require "fileutils"
require "openai"

# The credentials can be provided as parameters:

# flickr = Flickr.new "YOUR API KEY", "YOUR SHARED SECRET"

# Alternatively, if the API key and Shared Secret are not provided, Flickr will attempt to read them
# from environment variables:
# ENV['FLICKR_API_KEY']
# ENV['FLICKR_SHARED_SECRET']

PostDetails = Struct.new(:featured, :photoset, :main_photo, :description, keyword_init: true) do 
  def image_alt_text
    photoset.title
  end

  def image_dir
    dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
  end

  def post_id
    str = main_photo['title'].strip.empty? ? categories : main_photo['title']
    str.gsub(/\s+/, ' ').gsub(' ', '-')
  end

  def image_file_name
     self.post_id + '.jpg'
  end

  def categories
    main_photo.tags.split(' ').select {|tag| !['jsu', 'js', 'jsd', 'main'].include?(tag)}.uniq.join(' ')
  end

  def post_file_name
    file_name = main_photo["datetaken"].split(' ').first + '-' + self.post_id
    file_path = '_posts/' + file_name + '.markdown'
    return file_path
  end

  def save_main_image
    # dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
    FileUtils.mkdir_p(self.image_dir)
    file_name = self.image_dir + self.image_file_name
    if File.exists? file_name
      puts "Image already downloaded. Skipping : " + file_name
      return file_name
    end
    url = main_photo['url_m']
    tempfile = Down.download(url)
    FileUtils.mv(tempfile.path, "#{file_name}")

    return file_name
  end


end

class Main
  def self.get_flickr_updates

    Flickr.cache = '/tmp/flickr-api.yml'
    flickr = Flickr.new

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
    photos_by_album_id = Hash.new {|h, k| h[k] = []} 

    photos.each do |photo|
      contexts = flickr.photos.getAllContexts(photo_id: photo.id)['set']
      next unless contexts && !contexts.empty?
      # FIXME : using the 1st photoset for now
      context = contexts.first
      if photo.tags.include?('js') && photo.tags.include?('main')
        puts "main photo found " + photo.inspect
        if post_details_by_id.include?(context.id) && !photo.tags.include?('jsu')
          puts "already handled this photoset so skipping " + context.id 
        else
          puts "found new photoset " + context.id
          # puts context.inspect
          post_details = PostDetails.new(featured: photo.tags.include?('feature'), photoset: context, main_photo: photo, description: "")
          post_details.description = post_description(post_details, photo)
          post_details_by_id[context.id] = post_details
        end
      else
        photos_by_album_id[context.id] << photo
      end
    end

    { post_details_by_id: post_details_by_id, other_photos_by_album_id: photos_by_album_id }
  end

  def self.post_description(post_details, photo)
    if (photo['description'] || '').length > 10
      puts "skipping chatgpt call since description found in main photo"
      return photo['description']
    end

    return chatgpt(post_details.categories)
  end

  FLICKR_IMAGE_TEMPLATE = '
  flickr %{photo_id} "%{photo_title}" style="float: right;"
  '

  POST_TEMPLATE = '---
layout: post
title: %{title}
date: %{date}
categories: %{categories}
author: amit
image: %{image_path}
image_alt_text: %{image_alt_text}
featured: %{featured}
photoset: %{photoset_id}
---
%{description}

%{flickr_images}
  '

  def self.create_post(post_details, other_photos_by_album, overwrite = true)
    post_hash = {
      post_file_name: post_details.post_file_name,
      title: post_details.photoset['title'],
      date: post_details.main_photo['datetaken'],
      categories: post_details.categories,
      image_path: post_details.save_main_image,
      image_alt_text: post_details.photoset['title'],
      featured: post_details.featured,
      photoset_id: post_details.photoset['id'],
      description: post_details.description
    }

    file_path = post_details.post_file_name

    if File.exists? file_path
      if overwrite
        puts 'overwrite flag is set so deleting existing file'
        File.delete(file_path)
      else
        puts file_path + ' already exists. NOT overriding'
        return
      end
    end

    # TODO : flickr tag plugin not working so commented out
    flickr_images = ''
    # other_photos = other_photos_by_album[post_details.photoset['id']]
    # other_photos.each_with_index do |photo, i|
    #   puts photo.inspect
    #   hsh = {
    #     photo_id: photo['id'],
    #     photo_title: (photo['title'] || ''),
    #   }
    #   str = FLICKR_IMAGE_TEMPLATE % hsh
    #   flickr_images += "{% #{str} %}"
    #   break if i == 5
    # end

    post_hash[:flickr_images] = flickr_images

    post_str = POST_TEMPLATE % post_hash
    # puts "writing to file : " + file_path
    File.open(file_path, 'w') do |out_file|
      out_file.puts post_str
    end
    # puts post_str
  end

  def self.run
    data = get_flickr_updates()


    data[:post_details_by_id].each do |photoset_id, post_details|
      create_post(post_details, data[:other_photos_by_album_id])
    end
  end

  def self.chatgpt(description)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end

    client = OpenAI::Client.new

    prompt = "Write 2 paragraphs on middle fork trail hiking snow winter river in wa state"
    prompt = "write 2 paragraphs on #{description}"
    prompt = "write description with keywords #{description}"
    puts '-----------------'
    puts prompt

    # response = client.chat(
    #   parameters: {
    #     model: "text-davinci-003",
    #     prompt: prompt,
    #     # temperature: 0, # show the low risk text options
    #     max_tokens: 256,
    #     # frequency_penalty: 0,
    #     # presence_penalty: 0,
    # })
    # puts response["choices"].map { |c| c["text"] }

    response = client.completions(
      parameters: {
          model: "text-davinci-003",
          prompt: prompt,
          max_tokens: 256
      })
  puts response["choices"].map { |c| c["text"] }

  puts response.inspect
  # => [", there lived a great"]

    # response = client.chat(
    #   parameters: {
    #       model: "gpt-3.5-turbo", # Required.
    #       messages: [{ role: "user", content: "Hello!"}], # Required.
    #       temperature: 0.7,
    #   })
    # puts response.dig("choices", 0, "message", "content")

    # => "Hello! How may I assist you today?"

    return response["choices"].first["text"] 

  end

end

Main.run