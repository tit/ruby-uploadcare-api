module Uploadcare
  module Helpers
    def self.widget_url
      "#{Uploadcare.default_setting[:static_url_base]}/uploadcare/uploadcare-#{Uploadcare.default_setting[:widget_version]}.min.js"
    end

    def self.widget_script_tag
      "<script src='#{Uploadcare::Helpers::widget_url}'></script>"
    end
  end
end