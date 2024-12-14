require 'retries'
require 'faker'
require 'securerandom'

module ChatGptHelpers
  OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
  end

  HANDLER = Proc.new do |exception, attempt_number, total_delay|
    puts "Handler saw a #{exception.class}; retry attempt #{attempt_number}; #{total_delay} seconds have passed."
  end

  def self.chat_gpt_blog_prompt(post_details, photo)
    # category = FlickrCreatePost.categorize(post_details.description)
    prompt = "Write a blog post based on the following keywords : #{photo.tags.join(', ')}.\n"
    tone = "fun"
    blogPostTopic = "#{post_details.post_title}"
    prompt = "Write a blog post on #{blogPostTopic}. Write it in a #{tone} tone. Use transition words. Write less than 100 words. " +
      "The blog post should be written as a personal story.Include the following keywords: #{photo.tags.join(', ')}. "
      # "Tone of article should be positive but don’t use too many superlatives. \n " + 
      # "Write article in first person as someone who lives in Washington state."

    # if rand() * 10 >= 5
    #   prompt += "Write the blog entry in first person."
    # end

    puts "chatgpt prompt is : #{prompt}"
    return prompt
  end

  def self.compute_turbo_input(system_content, user_content)
    return [
        {
            "role": "system",
            "content": system_content
        },
        {
            "role": "user",
            "content": user_content
        }
    ]
  end

  # {"error"=>{"message"=>"That model is currently overloaded with other requests. You can retry your request, or contact us through our help center at help.openai.com if the error persists. (Please include the request ID f43bf668f76c391eca8466ebd0517b50 in your message.)",
  # "type"=>"server_error", "param"=>nil, "code"=>nil}}

  def self.chat(messages)
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        "model" => "gpt-3.5-turbo",
        "messages" => messages,
        "temperature" => 0,
      }
    )

    puts messages.inspect.colorize(:blue)
    puts response.inspect.colorize(:blue)
    if response["error"]
      puts response["error"].inspect.colorize(:red)
      raise response["error"]["message"]
    end

    if response["choices"]
      answer = (response["choices"].first["message"] || {})["content"] || ''
      return answer.gsub('"', '')
    else 
      raise "choices returned blank"
    end
  end

  def self.chatgpt_turbo_35(messages, fake_call = false)
    if fake_call
      puts "dry-run returning fake data".colorize(:orange)
      return Faker::Book.title
    end

    with_retries(max_tries: 5, :base_sleep_seconds => 5, :max_sleep_seconds => 10.0, :handler => HANDLER, :rescue => [RuntimeError, ZeroDivisionError]) do
      chat(messages)
    end
  end

  def self.blog_completions(prompt)
    client = OpenAI::Client.new

    response = client.completions(
      parameters: {
          model: "text-davinci-003",
          prompt: prompt,
          max_tokens: 512,
          temperature: 0, # show the low risk text options
    #     # frequency_penalty: 0,
    #     # presence_penalty: 0,
      })

    puts prompt.inspect.colorize(:red)
    puts response.inspect.colorize(:blue)
    if response["error"]
      puts response["error"].inspect.colorize(:red)
      raise response["error"]["message"]
    end

    if response["choices"]
      # puts response["choices"].map { |c| c["text"] }

      puts response.inspect.colorize(:blue)
      return response["choices"].first["text"] 
    else 
      raise "Blank response received"
    end
  end

  def self.davinci(prompt, fake_call = false)
    if fake_call
      puts "dry-run returning fake data".colorize(:orange)
      return Faker::Lorem.paragraphs(number: 1).first
    end

    with_retries(max_tries: 5, :base_sleep_seconds => 5, :max_sleep_seconds => 10.0, :handler => HANDLER, :rescue => [RuntimeError, ZeroDivisionError]) do
      blog_completions(prompt)
    end
  end


end

