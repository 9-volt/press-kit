require_relative "../main"

module Fetchers
  class Agora
    include Fetchers::IncrementalStrategy

    FEED_URL  = "http://agora.md/rss/news"

    def initialize(storage=LocalStorageFactory.agora)
      @storage = storage
    end

  private

    def fetch_most_recent_id
      RestClient.get(FEED_URL)
        .match(/http:\/\/agora.md\/stiri\/(\d*)\//)
        .captures
        .first
        .to_i
    end

    def link(id)
      "http://agora.md/stiri/#{id}/"
    end

    def fetch_single(id)
      SmartFetcher.fetch(link(id))
    end

    def valid?(page)
      return false if page.nil?
      doc = Nokogiri::HTML(page, nil, "UTF-8")
      doc.title != "Agora - 404"
    end
  end
end
