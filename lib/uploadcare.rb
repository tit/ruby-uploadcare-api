require "faraday"
require "json"
require "ostruct"

require "uploadcare/api"
require "uploadcare/uploader"
require "uploadcare/version"
require "uploadcare/helpers"

##
# Uploadcare module
#
# @see https://github.com/uploadcare/ruby-uploadcare-api
module Uploadcare
  ##
  # Get default setting
  #
  # @return [Hash]
  #
  # @example
  #   result = Uploadcare.default_setting
  #   #=> {
  #          :api_url_base => "https://api.uploadcare.com",
  #          :static_url_base => "https://ucarecdn.com",
  #          :api_version => "0.2",
  #          :public_key => "demopublickey",
  #          :widget_version => "0.1.17",
  #          :private_key => "demoprivatekey",
  #          :upload_url_base => "https://upload.uploadcare.com"
  #       }
  def self.default_settings
    default_settings = {
        :public_key => "demopublickey",
        :private_key => "demoprivatekey",
        :upload_url_base => "https://upload.uploadcare.com",
        :api_url_base => "https://api.uploadcare.com",
        :static_url_base => "https://ucarecdn.com",
        :api_version => "0.2",
        :widget_version => "0.1.17"
    }
  end

  ##
  # Get User-Agent for Uploadcare wrapper
  #
  # @return [String]
  #
  # @example
  #   result = Uploadcare.user_agent
  #   #=> "uploadcare-api-ruby/0.0.2"
  def self.user_agent
    user_agent = "uploadcare-api-ruby/#{Uploadcare::VERSION}"
  end
end
