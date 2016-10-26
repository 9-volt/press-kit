module Fetchers
  class Prime
    include Strategy::Incremental
    attr_reader :url, :storage

    def initialize(storage: LocalStorageFactory.prime, url: URL::Prime.new)
      @storage = storage
      @url = url
    end

    def run(start=latest_stored_id, finish=most_recent_id)
      run_info

      page_ids(start, finish).each do |id|
        result = fetch_single(id)
        unless result[:page].nil?
          storage.save(result[:page], id, result[:category])
        end
        progressbar.increment!
      end
    end

    def fetch_single(id)
      url.all_possible(id).each do |url, category|
        page = SmartFetcher.fetch(url)
        if valid?(page)
          return { page: page, category: category }
        end
      end
      {}
    end

    def valid?(page)
      doc = Nokogiri::HTML(page, nil, 'UTF-8')
      doc.at_css(".left_column .page_content")
    end

    def most_recent_id
      @most_recent_id ||= fetch_most_recent_id
    end

    def fetch_most_recent_id
      doc = Nokogiri::HTML(RestClient.get(url.main_news_page))
      first_news_url = doc.css(".left_column .news_rubric_item:first a:first").attribute("href").value
      first_news_url.match(/\/item(\d+)\//).captures.first.to_i
    end
  end
end
