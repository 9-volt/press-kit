module Fetchers
  class Agora
    include Strategy::Incremental
    attr_reader :url, :storage

    FEED_URL  = "http://agora.md/rss/news"

    def initialize(storage: LocalStorageFactory.agora, url: URL::Agora.new)
      @storage = storage
      @url = url
    end

  private

    def fetch_most_recent_id
      RestClient.get(FEED_URL)
        .match(/http:\/\/agora.md\/stiri\/(\d*)\//)
        .captures
        .first
        .to_i
    end

    def fetch_single(id)
      SmartFetcher.fetch(build_url(id))
    end

    def valid?(page)
      return false if page.nil?
      doc = Nokogiri::HTML(page, nil, "UTF-8")
      doc.title != "Agora - 404"
    end
  end
end
