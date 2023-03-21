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

puts ([flickr.methods - '1'.methods]).sort.join("\n")
photos = flickr.people.getPublicPhotos(:user_id => '57125599@N00', :extras => 'description,tags,geo', per_page: 2)

photos.each do |photo|
  puts 
  puts photo.inspect
  puts flickr.photos.getAllContexts(photo_id: photo.id).inspect
end

# get all photos in last 1h
# get unique albums for each photo with a main photo
# for each album see if there is a post already created - store in yml file ? 
# if not found 
  #  get album meta data to make draft post
  #  create new draft post via jekyll draft command line
  #  add tag listing that photo was added to jekyll blog
  #  print out message