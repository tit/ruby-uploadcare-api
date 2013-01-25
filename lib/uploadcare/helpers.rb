##
# Uploadcare module
module Uploadcare
  ##
  # Helpers module
  module Helpers
    ##
    # Get widget url
    #
    # @return [String]
    #
    # @example
    #   result = Uploadcare::Helpers.widget_url
    #   #=> https://ucarecdn.com/uploadcare/uploadcare-0.1.17.min.js
    def self.widget_url
      widget_url = "#{Uploadcare.default_setting[:static_url_base]}/uploadcare/uploadcare-#{Uploadcare.default_setting[:widget_version]}.min.js"
    end

    ##
    # Get widget HTML script tag
    #
    # @return [String]
    #
    # @example
    #   result = Uploadcare::Helpers.widget_script_tag
    #   #=> "<script src='https://ucarecdn.com/uploadcare/uploadcare-0.1.17.min.js'></script>"
    def self.widget_script_tag
      widget_script_tag = "<script src='#{Uploadcare::Helpers::widget_url}'></script>"
    end
  end
end