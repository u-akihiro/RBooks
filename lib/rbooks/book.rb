module Rbooks
  require "URI"

  class Book
    DEFAULT_OPT = {format: "json", formatVersion: "1"}
    REQUIRE_URL_ENCODE = [:title, :author, :publisher, :isbn, :booksGenreId]

    class << self
      def search(opt)
        params = DEFAULT_OPT.merge opt

        params = self.encode_each_params params
      end

      def encode_each_params(params)
        REQUIRE_URL_ENCODE.each do |key|
          params[key] = Rbooks::url_encode params[key].join(' ') if params.key? key
        end

        return params
      end
    end
  end

  class << self
    def url_encode(str)
      URI.encode_www_form_component str
    end
  end
end