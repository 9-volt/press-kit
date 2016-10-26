module Fetchers
  class ProTv
    include Strategy::Incremental
    attr_reader :url, :storage

    LATEST_NEWS = "http://protv.md/export/featured/json"

    def initialize(storage: LocalStorageFactory.pro_tv, url: URL::ProTv.new)
      @storage = storage
      @url = url
    end

    private

    def fetch_most_recent_id
      resp = JSON.parse(RestClient.get(LATEST_NEWS))
      resp[0]["id"].to_i
    end

    def fetch_single(id)
      SmartFetcher.fetch(build_url(id))
    end

    def valid?(page)
      return false if page.nil?

      doc = Nokogiri::HTML(page, nil, "UTF-8")
      !doc.at_css('//h1[@itemprop="name headline"]').nil?
    end

    def page_ids(start, finish)
      start = start == 0 ? 1 : start
      (start..finish).step(10)
    end
  end
end
