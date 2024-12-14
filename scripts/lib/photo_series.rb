require "colorize"
require 'securerandom'

class Series
  attr_accessor :series_data, :series_id
end

class PhotoSeries

  attr_reader :photos, :post_series, :all_photos_in_series

  def initialize(photos, options)
    @photos = photos
    @options = options
  end

  def get_post_series_details(photo, series_key)
    if all_photos_in_series.include? photo.id
      related_series = post_series.find {|ps| ps.series_data.include? photo.id }
      if related_series 
        series_index = related_series.series_data.find_index photo.id
        series_total = related_series.series_data.size
        return PostSeriesDetails.new(series_key: related_series.series_id, series_index: series_index, series_total: series_total)
      else
        puts "Internal error : photo #{photo.id} couldn not be placed in any series.".colorize(:red)
      end
    else
      puts "photo #{photo.id} is not in any series" if @options.verbose?
      nil
    end
  end

  def identify_all_series
    post_series = [] # array of Series objects
    all_photos_in_series = Set.new
    in_series = false

    index = 1
    curr_p = photos[0]
    new_series = Series.new 
    while (photos.size > 0 && index < photos.size)
      next_p = photos[index]
      day_diff = (next_p.datetaken - curr_p.datetaken).round
      if day_diff <= 1     
        unless in_series
          new_series = Series.new
          new_series.series_id = SecureRandom.uuid.to_s
          new_series.series_data = Set.new
          post_series << new_series
        end
        
        in_series = true
        # is part of series
        # photo_set = post_series[series_id] ||= Set.new
        # photo_set << curr_p.id
        # photo_set << next_p.id
        new_series.series_data << curr_p.id
        new_series.series_data << next_p.id
        all_photos_in_series << curr_p.id
        all_photos_in_series << next_p.id
      else
        in_series = false
      end

      curr_p = next_p
      index += 1
    end

    puts "Total photos to be processed : #{photos.size}".colorize(:light_black)
    puts "No series found ".colorize(:orange) if post_series.size == 0
    post_series.each_with_index do |ps, idx|
      puts "Series : #{idx + 1}".colorize(:light_black)
      puts ps.series_data.inspect.colorize(:light_black)
    end

    @post_series = post_series
    @all_photos_in_series = all_photos_in_series

    # {
    #   post_series: post_series.each { |aa| aa.to_a },
    #   all_photos_in_series: all_photos_in_series,
    # }

    self
  end



end