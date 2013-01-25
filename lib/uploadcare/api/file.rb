require "time"

##
# Uploadcare module
module Uploadcare
  ##
  # Api::File < OpenStruct class
  class Api::File < OpenStruct
    ##
    # Constructor
    #
    # @param [Uploadcare::Api] api
    # @param [Object] args
    #
    # @return [Pry::Method, nil]
    #
    # @example file = Uploadcare::Api.new @todo add example args
    #   #=> @todo add description
    def initialize api, *args
      @api = api
      super *args
    end

    ##
    # Delete file
    # @todo add param
    # @todo add return
    # @todo add example
    def delete
      @api.delete_file file_id
      reload
    end

    ##
    # Store file
    # @todo add param
    # @todo add return
    # @todo add example
    def store
      @api.store_file file_id
      reload
    end

    ##
    # Get public url
    # @todo add param
    # @todo add return
    # @todo add example
    def public_url *operations
      path = operations.empty? ? file_id : [file_id, operations].join("/-/")
      File.join @api.options[:static_url_base],
                path,
                "/"
    end

    ##
    # Reload
    # @todo add param
    # @todo add return
    # @todo add example
    def reload
      @table.update @api.file(file_id).instance_variable_get("@table")
    end

    ##
    # Last keep claim
    # @todo add param
    # @todo add return
    # @todo add example
    def last_keep_claim
      Time.parse @table[:last_keep_claim] if @table[:last_keep_claim]
    end

    ##
    # Upload date
    # @todo add param
    # @todo add return
    # @todo add example
    def upload_date
      Time.parse @table[:upload_date] if @table[:upload_date]
    end

    ##
    # Removed
    # @todo add param
    # @todo add return
    # @todo add example
    def removed
      Time.parse @table[:removed] if @table[:removed]
    end
  end

  ##
  # Api::FileList class
  class Api::FileList
    attr_accessor :files,
                  :page,
                  :per_page,
                  :total,
                  :pages
    
    ##
    # Constructor
    # @todo add param
    # @todo add return
    # @todo add example
    def initialize api, results
      @api = api
      @files = results['results'].map do |obj|
        Api::File.new(api, obj)
      end
      @page = results['page'].to_i
      @per_page = results['per_page'].to_i
      @total = results['total'].to_i
      @pages = results['pages'].to_i
    end
  end
end