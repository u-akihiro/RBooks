module Rbooks
  require "uri"
  require "openssl"
  require "net/http"
  require "json"
  require "forwardable"

  class Book
    extend Forwardable

    DEFAULT_OPT = {format: "json", formatVersion: "2"}.freeze
    REQUIRE_CONCAT = [:title, :author, :publisher, :isbn, :booksGenreId].freeze

    class << self
      def search(opt)
        params = self.concat_each_item_by_space(DEFAULT_OPT)
                     .merge(opt)
                     .merge(applicationId: Rbooks::APPLICATION_ID)

        uri = URI(Rbooks::ENDPOINT_URL)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.start do |h|
          h.use_ssl = true
          h.request Net::HTTP::Get.new(uri)
        end

        Book.new(response.body)
      end

      def concat_each_item_by_space(params)
        params.select { |k, _| REQUIRE_CONCAT.include?(k) }
              .map { |k, v| [k, v.join(" ")] }
              .to_h
      end
    end

    def initialize(response)
      @response = JSON.parse(response)
      @items = @response["Items"]
    end

    def_delegators :@items, :each, :empty?
    def_delegators :@response, :[], :key?
  end
end
