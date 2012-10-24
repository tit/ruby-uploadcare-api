require 'mime/types'

module Uploadcare
  class Uploader
    # options:
    # * :public_key
    # * :timeout (optional, 5 by default)
    # * :upload_url_base (optional, 'https://upload.uploadcare.com/' by default)
    def initialize(options = {})
      default = {
        timeout: 5,
        upload_url_base: 'https://upload.uploadcare.com/'
      }
      @options = default.merge(options)
      
      raise ArgumentError.new(':public_key are required') unless @options.has_key?(:public_key)
    end

    def upload_url url

    end

    def upload_file(path)
      resp = response :post, '/base/', {
        UPLOADCARE_PUB_KEY: @options[:public_key],
        # UPLOADCARE_FILE_ID: file_id,
        file: Faraday::UploadIO.new(path, MIME::Types.of(path))
      }
      resp['file']
    end
  protected
    def response method, path, params = {}
      connection = Faraday.new url: @options[:upload_url_base] do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
      r = connection.send(method, path, params)
      raise ArgumentError.new(r.body) if r.status != 200
      JSON.parse(r.body)
    end
  end
end
