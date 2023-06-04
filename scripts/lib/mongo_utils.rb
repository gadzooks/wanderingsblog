require 'mongo'
module MongoUtils

  PHOTOS_PROCESSED_DB_NAME = 'photos_processed'

  def self.find_existing_entries(photo_ids)
    mongo_client = MongoUtils.mongo_db_connect
    MongoUtils.photos_processed_collection(mongo_client).find( { "photo_id" => {"$in" => photo_ids} })
  end

  def self.photos_processed_collection(mongo_client)
    collection = mongo_client[PHOTOS_PROCESSED_DB_NAME]
  end

  def self.mongo_db_connect
    mongo_user = ENV['MONGO_USER']
    mongo_pwd = ENV['MONGO_PWD']
    mongo_db = ENV['MONGO_DB']
    uri = "mongodb+srv://#{mongo_user}:#{mongo_pwd}@#{mongo_db}.ixbry4h.mongodb.net/?retryWrites=true&w=majority"

    # Set the server_api field of the options object to Stable API version 1
    options = { 
      server_api: {version: "1"},
      database: mongo_db
    }

    Mongo::Client.new(uri, options)
  end


end