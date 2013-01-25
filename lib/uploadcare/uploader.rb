require "mime/types"

##
# Uploadcare module
module Uploadcare
  ##
  # Uploader class
  # Uploader can upload files from a URL or from hard drive
  class Uploader
    ##
    # Constructor
    #
    # @param [Hash] options
    # @option options [String] :public_key Public key
    # @option options [String] :private_key Private key
    # @option options [String] :upload_url_base Upload base url
    # @option options [String] :api_url_base API base url
    # @option options [String] :static_url_base Static base url
    # @option options [String] :api_version API version
    # @option options [String] :widget_version Widget version
    #
    # @return [Uploadcare::Uploader]
    #
    # @example
    #   uploader = Uploadcare::Uploader.new :public_key => "demopublickey",
    #                                       :private_key => "demoprivatekey",
    #                                       :upload_url_base => "https://upload.uploadcare.com",
    #                                       :api_url_base => "https://api.uploadcare.com",
    #                                       :static_url_base => "https://ucarecdn.com",
    #                                       :api_version => "0.2",
    #                                       :widget_version => "0.1.17"
    #   #=> <Uploadcare::Uploader:0x00000001f72cd0 @options={:public_key=>"demopublickey", :private_key=>"demoprivatekey", :upload_url_base=>"https://upload.uploadcare.com", :api_url_base=>"https://api.uploadcare.com", :static_url_base=>"https://ucarecdn.com", :api_version=>"0.2", :widget_version=>"0.1.17"}>
    def initialize options = {}
      @options = Uploadcare::default_settings.merge options
    end

    ##
    # Upload file from URL
    #
    # @param [String] url File URL
    #
    # @return [String] File ID
    #
    # @example
    #   uploader = Uploadcare::Uploader.new :public_key => "demopublickey",
    #                                       :private_key => "demoprivatekey",
    #                                       :upload_url_base => "https://upload.uploadcare.com",
    #                                       :api_url_base => "https://api.uploadcare.com",
    #                                       :static_url_base => "https://ucarecdn.com",
    #                                       :api_version => "0.2",
    #                                       :widget_version => "0.1.17"
    #   file_id = uploader.upload_url "http://example.com/file.zip"
    #   #=> "ab123c4d-123a-1abc-a123-123a4bc5d678"
    def upload_url url
      # download file and get token
      token = response :post,
                       "/from_url/",
                       :source_url => url,
                       :pub_key => @options[:public_key]

      # wait valid response status
      status = "unknown"
      while "unknown" == status
        result = response :post,
                          "/from_url/status/",
                          token
        status = result[:status]
        sleep 0.5
      end

      # raise if response status is invalid
      raise ArgumentError.new result["error"] if "error" == result["status"]

      # return file ID
      result["file_id"]
    end

    ##
    # Upload file from hard drive
    #
    # @param [String] path Filename
    #
    # @return [String] File ID
    #
    # @example
    #   uploader = Uploadcare::Uploader.new :public_key => "demopublickey",
    #                                       :private_key => "demoprivatekey",
    #                                       :upload_url_base => "https://upload.uploadcare.com",
    #                                       :api_url_base => "https://api.uploadcare.com",
    #                                       :static_url_base => "https://ucarecdn.com",
    #                                       :api_version => "0.2",
    #                                       :widget_version => "0.1.17"
    #   file_id = uploader.upload_file "/tmp/file.zip"
    #   #=> "ab123c4d-123a-1abc-a123-123a4bc5d678"
    def upload_file path
      # get type of file
      type = MIME::Types.of path

      # @todo add description
      uploadio = Faraday::UploadIO.new path,
                                       type

      # upload file
      result = response :post,
                        "/base/",
                        :UPLOADCARE_PUB_KEY => @options[:public_key],
                        :file => uploadio

      # return file ID
      result["file"]
    end

    protected

    ##
    # @todo add description
    #
    # @param [Symbol] method HTTP method
    # @param [String] path @todo add description
    # @param [Hash] params @todo add description
    #
    # @return [Hash]
    #
    # @example
    #   path = "/tmp/file.zip"
    #   type = MIME::Types.of path
    #   uploadio = Faraday::UploadIO.new path, type
    #   result = response :post,
    #                     "/base/",
    #                     :UPLOADCARE_PUB_KEY => "demopublickey",
    #                     :file => uploadio
    #   #=> @todo add result
    def response method, path, params = {}
      # For Ubuntu
      ca_path = nil
      ca_path = "/etc/ssl/certs" if File.exists? "/etc/ssl/certs"

      ssl = {
          :ca_path => ca_path
      }

      connection = Faraday.new :ssl => ssl,
                               :url => @options[:upload_url_base] do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers["User-Agent"] = Uploadcare::user_agent
      end

      result = connection.send method,
                               path,
                               params
      body = result.body
      status = result.status
      raise ArgumentError.new body if 200 != status
      JSON.parse body
    end
  end
end
