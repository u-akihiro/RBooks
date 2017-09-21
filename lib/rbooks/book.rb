module Rbooks
  require "uri"
  require "openssl"
  require "net/http"
  require "json"
  require "forwardable"

  class Book
    extend Forwardable

    DEFAULT_OPT = {format: "json", formatVersion: "2"}
    REQUIRE_CONCAT = [:title, :author, :publisher, :isbn, :booksGenreId]

    class << self
      def search(opt)
        params = DEFAULT_OPT.merge(opt)
        params[:applicationId] = Rbooks::APPLICATION_ID
        params = self.concat_each_item_by_space params

        uri = URI(Rbooks::ENDPOINT_URL)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.start do |h|
          h.use_ssl = true
          h.request Net::HTTP::Get.new uri
        end

        Book.new response.body
      end

      def concat_each_item_by_space(params)
        REQUIRE_CONCAT.each do |key|
            params[key] = params[key].join(" ") if params.key? key
        end

        return params
      end
    end


    def initialize(response)
      @response = JSON.parse response
      @items = @response["Items"]
    end

    def_delegators :@items, :each, :empty?
    def_delegators :@response, :[], :key?
  end
end
