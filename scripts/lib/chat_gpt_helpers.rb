module ChatGptHelpers
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

  def self.chatgpt_turbo_35(messages, fake_call = false)
    if fake_call
      puts "dry-run returning fake data".colorize(:orange)
      return "loren ipsum"
    end
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end

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
    if response["choices"]
      answer = (response["choices"].first["message"] || {})["content"] || ''
      answer.gsub('"', '')
    else 
      STDERR.puts response.inspect
      return ""
    end

  end

  def self.davinci(prompt, fake_call = false)
    if fake_call
      puts "dry-run returning fake data".colorize(:orange)
      return "loren ipsum"
    end
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end

    client = OpenAI::Client.new

    response = client.completions(
      parameters: {
          model: "text-davinci-003",
          prompt: prompt,
          max_tokens: 512
    #     # temperature: 0, # show the low risk text options
    #     # frequency_penalty: 0,
    #     # presence_penalty: 0,
      })

    if response["choices"]
      # puts response["choices"].map { |c| c["text"] }

      puts response.inspect.colorize(:blue)
      return response["choices"].first["text"] 
    else 
      STDERR.puts response.inspect
      return ""
    end

  end


end

