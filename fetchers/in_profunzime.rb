module Fetchers
  class InProfunzime
    include Strategy::Incremental
    attr_reader :url, :storage

    def initialize(storage: LocalStorageFactory.in_profunzime, url: URL::InProfunzime.new)
      @storage = storage
      @url = url
    end

    def fetch_single(id)
      SmartFetcher.fetch(build_url(id))
    end

    def valid?(page)
      doc = Nokogiri::HTML(page, nil, 'UTF-8')
      !doc.css(".boxTime").text.include? "1970"
    end

    def most_recent_id
      @most_recent_id ||= fetch_most_recent_id
    end

    def fetch_most_recent_id
      doc = Nokogiri::HTML(RestClient.get(url.latest_news))
      doc.xpath("//h8/a/@href").first.to_s.gsub(/[^\d]/, '').to_i
    end

    def page_ids(start, finish)
      unless start && finish
        start = latest_stored_id == 0 ? 1 : latest_stored_id
        finish = most_recent_id
      end

      (start..finish).step(10)
    end
  end
end
