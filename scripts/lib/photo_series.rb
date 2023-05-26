require "colorize"

class PhotoSeries

  # attr_reader: photos

  # def initialize(photos)
  #   @photos = photos
  # end

  def self.get_post_series_details(all_photos_in_series, post_series, photo, series_key)
    puts '-------------------------------------'
    puts photo.inspect
    puts all_photos_in_series.inspect
    puts '-------------------------------------'
    if all_photos_in_series.include? photo.id
      related_series = post_series.find {|ps| ps.include? photo.id }
      if related_series 
        which_series = post_series.find_index {|ps| ps.include? photo.id } 
        # TODO series_index does not seem to work correctly
        series_index = related_series.find_index photo.id
        series_total = related_series.size
        # TODO : generate series_key per series when the series is being found from all photos
        return PostSeriesDetails.new(series_key: "temp-series-key-#{which_series}", series_index: series_index, series_total: series_total)
      else
        puts "Internal error : photo #{photo.id} couldn not be placed in any series.".colorize(:red)
      end
    else
      puts "photo #{photo.id} is not in any series" # if @options.verbose?
      nil
    end
  end

  def self.find_photo_series(photos)
    post_series = [] # array of arrays, one for each series
    all_photos_in_series = Set.new
    series_id = 0
    in_series = false

    index = 1
    curr_p = photos[0]
    while (photos.size > 0 && index < photos.size)
      next_p = photos[index]
      day_diff = (next_p.datetaken - curr_p.datetaken).round
      if day_diff <= 1     
        in_series = true
        # is part of series
        photo_set = post_series[series_id] ||= Set.new
        photo_set << curr_p.id
        photo_set << next_p.id
        all_photos_in_series << curr_p.id
        all_photos_in_series << next_p.id
      else
        if in_series
          in_series = false
          series_id += 1
        end
      end

      curr_p = next_p
      index += 1
    end

    puts "Total photos to be processed : #{photos.size}".colorize(:light_black)
    puts "No series found ".colorize(:orange) if post_series.size == 0
    post_series.each_with_index do |ps, idx|
      puts "Series : #{idx + 1}".colorize(:light_black)
      puts ps.inspect.colorize(:light_black)
      # ps.each do |photo|
      #   puts [photo.id, photo.datetaken].inspect.colorize(:light_black)
      # end
    end

    {
      post_series: post_series.each { |aa| aa.to_a },
      all_photos_in_series: all_photos_in_series,
    }
  end



end