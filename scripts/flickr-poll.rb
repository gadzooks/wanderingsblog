#!/usr/bin/env ruby

require 'flickr'

# The credentials can be provided as parameters:

# flickr = Flickr.new "YOUR API KEY", "YOUR SHARED SECRET"

# Alternatively, if the API key and Shared Secret are not provided, Flickr will attempt to read them
# from environment variables:
# ENV['FLICKR_API_KEY']
# ENV['FLICKR_SHARED_SECRET']

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

photosets_by_id = {}

photos.each do |photo|
  puts photo.id
  unless photo.tags.include?('jekyllsite')
    next
    puts "Skipping photo due to missing tag " + photo.tags + " " + photo.id
  end
  if photo.tags.include? 'main'
    puts "main photo found " + photo.id
    # FIXME : using the 1st photoset for now
    context = flickr.photos.getAllContexts(photo_id: photo.id)['set'].last
    # puts "photoset id : " + context.inspect
    if photosets_by_id.include? context.id
      puts "already handled this photoset so skipping " + context.id 
    else
      puts "found new photoset " + context.id
      hsh = photosets_by_id[context.id] = {}
      hsh['categories'] = photo.tags
      hsh['image_alt_text'] = context.title
    end
  end
end

puts photosets_by_id.inspect

# get all photos in last 1h
# get unique albums for each photo with a main photo
# for each album see if there is a post already created - store in yml file ? 
# if not found 
  #  get album meta data to make draft post
  #  create new draft post via jekyll draft command line
  #  add tag listing that photo was added to jekyll blog
  #  print out message