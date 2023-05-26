require_relative './chat_gpt_helpers'

# NOTE : keyword_init is required so we can pass arguments as hash to create objects
PostDetails = Struct.new(:featured, :photoset, :main_photo, :description, :skip_chatgpt, :post_series_details, keyword_init: true) do 
  def image_alt_text
    photoset.title
  end

  def date_taken
    @date_taken ||= Date.parse(main_photo["datetaken"])
  end

  def image_dir
    dir_path = './assets/images/' +  main_photo["datetaken"].split(' ').first + '/'
  end

  def chat_gpt_title
    if @chat_gpt_title
      return @chat_gpt_title
    else 
      system_content = "Pick a title 6 words or less from :"
      messages = ChatGptHelpers.compute_turbo_input(system_content, main_photo.tags.join(' ,'))
      @chat_gpt_title = ChatGptHelpers.chatgpt_turbo_35(messages, skip_chatgpt)
    end
  end

  def post_title
    # main_photo['title'].strip.empty? ? chat_gpt_title : main_photo['title']
    chat_gpt_title
  end

  def post_id
    @post_id ||= chat_gpt_title.downcase.gsub(' ', '-').gsub(/[^0-9a-z-]/i, '')
    @post_id
  end

  def image_file_name
     post_id + '.jpg'
  end

  def post_file_name
    file_name = main_photo["datetaken"].strftime('%Y-%m-%d') + '-' + post_id
    file_path = '_posts/' + file_name + '.markdown'
    return file_path
  end

end

