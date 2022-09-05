# from http://www.marran.com/tech/integrating-flickr-and-jekyll
require 'flickr'

module Jekyll

  class GeneratePhotosets < Generator

    safe true
    priority :low
    CONFIG_KEY = 'flickr-photoset'.freeze

    def generate(site)
      generate_photosets(site) if (site.config[CONFIG_KEY]['enabled']) 
    end

    # e find any posts that have a photoset parameter in their YAML front matter and process the photoset. 
    def generate_photosets(site)
      site.posts.docs.each do |p|
        p.data['photos'] = load_photos(p.data['photoset'], site) if p.data['photoset']
      end
    end

    # cache photos so we dont call flickr everytime
    def load_photos(photoset, site)
      if cache_dir = site.config[CONFIG_KEY]['cache_dir']
        path = File.join(cache_dir, "#{Digest::MD5.hexdigest(photoset.to_s)}.yml")
        if File.exist?(path)
          photos = YAML::load(File.read(path))
        else
          photos = generate_photo_data(photoset, site)
          File.open(path, 'w') {|f| f.print(YAML::dump(photos)) }
        end
      else
        photos = generate_photo_data(photoset, site)
      end
    
      photos
    end

    # meat of the work is done here
    def generate_photo_data(photoset, site)
      returnSet = Array.new 

      # FlickRaw.api_key = site.config[CONFIG_KEY]['api_key']
      # FlickRaw.shared_secret = site.config[CONFIG_KEY]['shared_secret']
    
      # Alternatively, if the API key and Shared Secret are not provided, FlickRaw will attempt to read them
      # from environment variables:
      # ENV['FLICKR_API_KEY']
      # ENV['FLICKR_SHARED_SECRET']
      flickr = ::Flickr.new
    
      photos = flickr.photosets.getPhotos :photoset_id => photoset
    
      photos.photo.each_index do | i |
    
        title = photos.photo[i].title
        id = photos.photo[i].id
        fullSizeUrl = String.new
        urlThumb = String.new
        urlFull = String.new
        thumbType = String.new
    
        sizes = flickr.photos.getSizes(:photo_id => id).to_a
        sizes.each do | s |
    
          if s.width.to_i < 1200
            urlFull = s.source
          end
    
          if s.label == 'Small' && i < 3
            urlThumb = s.source
            thumbType = 'thumbnail'
          end
    
          if s.label == 'Square' && i >= 3
            urlThumb = s.source
            thumbType = 'square'
          end
    
        end
    
        photo = FlickrPhoto.new(title, urlFull, urlThumb, thumbType)
        returnSet.push photo
      end

      #sleep a little so that you don't get in trouble for bombarding the Flickr servers
      sleep 1

      returnSet

    end
  end

  # It has a to_liquid function to determine what values get passed to the templates.
  class FlickrPhoto

    attr_accessor :title, :urlFullSize, :urlThumbnail, :thumbType
  
    def initialize(title, urlFullSize, urlThumbnail, thumbType)
      @title = title
      @urlFullSize = urlFullSize
      @urlThumbnail = urlThumbnail
      @thumbType = thumbType
    end
  
    def to_liquid
      {
        'title' => title,
        'urlFullSize' => urlFullSize,
        'urlThumbnail' => urlThumbnail,
        'thumbType' => thumbType
      }
  
    end
  
  end

end