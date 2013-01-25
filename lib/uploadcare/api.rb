require "faraday"
require "json"
require "ostruct"

require "uploadcare/api/account"
require "uploadcare/api/file"

##
# Uploadcare module
module Uploadcare
  ##
  # Class Api
  class Api
    attr_reader :options

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
    # @return [Uploadcare::Api]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   #=> <Uploadcare::Api:0x00000001f72cd0 @options={:public_key=>"demopublickey", :private_key=>"demoprivatekey", :upload_url_base=>"https://upload.uploadcare.com", :api_url_base=>"https://api.uploadcare.com", :static_url_base=>"https://ucarecdn.com", :api_version=>"0.2", :widget_version=>"0.1.17"}>
    def initialize options = {}
      @options = Uploadcare::default_settings.merge options
    end

    ##
    # Get account info
    #
    # @return [Account]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   result = api.account
    #   #=> @todo add result
    def account
      resp = response :get,
                      "/account/"
      Account.new(
          :public_key => resp["pub_key"],
          :email => resp["email"],
          :username => resp["username"]
      )
    end

    ##
    # Get files list
    #
    # @param [Fixnum] page @todo add description
    #
    # @return [Api::FileList]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   result = api.files 42
    #   #=> @todo add result
    def files page = 1
      result = response :get,
                        '/files/',
                        :page => page
      Api::FileList.new self,
                        result
    end

    ##
    # Get @todo add description
    #
    # @param [String] file_id File ID
    #
    # @return [Api::File]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   result = api.file "ab123c4d-123a-1abc-a123-123a4bc5d678"
    #   #=> @todo add result
    def file file_id
      response :get,
               "/files/#{file_id}/"
      Api::File.new self,
                    result
    end

    ##
    # Delete file
    #
    # @param [String] file_id File ID
    #
    # @return [Hash]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   result = api.delete_file "ab123c4d-123a-1abc-a123-123a4bc5d678"
    #   #=> @todo add result
    def delete_file file_id
      response :delete,
               "/files/#{file_id}/"
    end

    ##
    # Store file
    #
    # @param [String] file_id File ID
    #
    # @return [Hash]
    #
    # @example
    #   api = Uploadcare::Api.new :public_key => "demopublickey",
    #                             :private_key => "demoprivatekey",
    #                             :upload_url_base => "https://upload.uploadcare.com",
    #                             :api_url_base => "https://api.uploadcare.com",
    #                             :static_url_base => "https://ucarecdn.com",
    #                             :api_version => "0.2",
    #                             :widget_version => "0.1.17"
    #   result = api.store_file "ab123c4d-123a-1abc-a123-123a4bc5d678"
    #   #=> @todo add result
    def store_file file_id
      response :post,
               "/files/#{file_id}/storage/"
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
                               :url => @options[:api_url_base] do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers["Authorization"] = "UploadCare.Simple #{@options[:public_key]}:#{@options[:private_key]}"
        faraday.headers["Accept"] = "application/vnd.uploadcare-v#{@options[:api_version]}+json"
        faraday.headers["User-Agent"] = Uploadcare::user_agent
      end

      result = connection.send method,
                               path,
                               params
      if 300 > result.status
        unless result.body.nil? or "" == result.body
          JSON.parse result.body
        end
      else
        msg = (result.body.nil? or "" == result.body) ? result.status : JSON.parse(result.body)["detail"]
        raise ArgumentError.new msg
      end
    end
  end
end
