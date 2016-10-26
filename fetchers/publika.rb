module Fetchers
  class Publika
    include Strategy::Incremental
    attr_reader :url, :storage

    FEED_URL = "http://rss.publika.md/stiri.xml"

    def initialize(storage: LocalStorageFactory.publika, url: URL::Publika.new)
      @storage = storage
      @url = url
    end

    private

    def fetch_most_recent_id
      doc = Nokogiri::XML(RestClient.get(FEED_URL))
      doc.css("link")[2]
        .text
        .scan(/_([\d]+)\.html/)
        .first
        .first
        .to_i
    end

    def fetch_single(id)
      SmartFetcher.fetch_with_retry_on_socket_error(build_url(id))
    end

    def valid?(page)
      !page.nil? && page.include?("publicat in data de")
    end

    def page_ids(start, finish)
      start = start == 0 ? 1 : start
      (start..finish).step(10)
    end
  end
end
