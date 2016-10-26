module Fetchers
  class Unimedia
    include Strategy::Incremental
    attr_reader :url, :storage

    FEED_URL = "http://unimedia.info/rss/news.xml"

    def initialize(storage: LocalStorageFactory.unimedia, url: URL::Unimedia.new)
      @storage = storage
      @url = url
    end

    private

    def fetch_most_recent_id
      doc = Nokogiri::XML(RestClient.get(FEED_URL))
      doc.css("link")[3].text.scan(/-([\d]+)\.html.+/).first.first.to_i
    end

    def fetch_single(id)
      SmartFetcher.fetch_with_retry_on_socket_error(build_url(id))
    end

    def valid?(page)
      return false if page.nil?
      doc = Nokogiri::HTML(page, nil, "UTF-8")
      return false if doc.title.match(/pagină nu există/)
      return false if doc.title.match(/UNIMEDIA - Portalul de știri nr. 1 din Moldova/)
      true
    end
  end
end
