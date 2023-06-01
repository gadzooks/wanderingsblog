module FlickrUtils
  PHOTOSETS_ADD_ENTRIES = '72177720307946395'
  PHOTOSETS_ENTRIES_ALREADY_PUBLISHED = '72177720308606044'
  USER_ID = '57125599@N00'
  PUBLIC_PHOTOS = 1
  META_DATA = 'description,date_taken,url_m,widths,sizes,views'

  def self.get_interesting_photos_from_context(flickr, photo, context_id)
    date_taken = photo.datetaken.strftime('%Y-%m-%d')
    # puts "looking up all photos in album #{context_id}"
    photos = (flickr.photosets.getPhotos(user_id: USER_ID, photoset_id: context_id, extras: META_DATA, privacy_filter: PUBLIC_PHOTOS)['photo'] || [])
    
    photos.sort! do |a, b|
      b.views.to_i <=> a.views.to_i
    end
    
    return photos[0..4]
  end

  # "tags": {
  #   "tag": [
  #       {
  #           "id": "3509168-52339055782-27647377",
  #           "author": "57125599@N00",
  #           "authorname": "Am-it",
  #           "raw": "grand canyon of yellowstone national park",
  #           "_content": "grandcanyonofyellowstonenationalpark",
  #           "machine_tag": false
  #       },
  def self.parse_tags_from_get_info(photo_details)
    ((photo_details['tags'] || {})['tag'] || []).map do |tag_details|
      tag_details['raw'] || ''
    end.uniq
  end


end