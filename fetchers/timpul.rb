module Fetchers
  class Timpul
    include Strategy::Incremental
    attr_reader :url, :storage

    def initialize(storage: LocalStorageFactory.timpul, url: URL::Timpul.new)
      @storage = storage
      @url = url
    end

    private

    def fetch_most_recent_id
      html = RestClient.get(url.base)
      doc = Nokogiri::HTML.parse(html)
      hrefs = doc.css("a").map { |link| link["href"] }.compact
      possible_ids = hrefs.map { |href| href.scan(/-([\d]+)\.html/)[0] }.compact
      possible_ids.map { |id| id.first.to_i }.max
    end

    def fetch_single(id)
      SmartFetcher.fetch(build_url(id))
    end

    def valid?(page)
      return false unless page
      doc = Nokogiri::HTML(page, nil, "UTF-8")
      return false if doc.title == "Timpul - Ştiri din Moldova"
      return false unless doc.css(".content").size > 0

      true
    end
  end
end
