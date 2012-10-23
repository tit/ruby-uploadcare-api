require 'faraday'
require 'json'

require 'uploadcare/uploader'
require 'uploadcare/version'


module Uploadcare
  class File
    def self.generate_file_id
      'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.gsub /[xy]/ do |c|
        r = (rand * 16).to_i
        (c == 'x' ? r : r & 0x3 | 0x8).to_s(16)
      end
    end
  end

  class Account
    attr_accessor :public_key, :email, :username

    def initialize(public_key, email, username)
      @public_key = public_key
      @email = email
      @username = username
    end
  end

  class Api
    # options:
    # * :public_key
    # * :private_key
    # * :timeout (optional, 5 by default)
    # * :api_url_base (optional, 'https://api.uploadcare.com/' by default)
    def initialize(options = {})
      default = {
        timeout: 5,
        api_url_base: 'https://api.uploadcare.com/'
      }
      @options = default.merge(options)
      
      raise ArgumentError.new(':public_key are required') unless @options.has_key?(:public_key)
      raise ArgumentError.new(':private_key are required') unless @options.has_key?(:private_key)
    end

    # Get account info
    def account
      resp = response(:get, '/account/')
      Account.new resp['pub_key'], resp['email'], resp['username']
    end

    # Get files list
    def files(page = 1)
      response :get, '/files/'
    end

  protected
    def response method, path, params = {}
      connection = Faraday.new url: @options[:api_url_base] do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Authorization'] = "UploadCare.Simple #{@options[:public_key]}:#{@options[:private_key]}"
      end
      r = connection.send(method, path, params)
      raise ArgumentError.new(JSON.parse(r.body)["detail"]) if r.status != 200
      JSON.parse(r.body)
    end
  end
end


