require_relative 'base_fetcher'

module Fetchers
  class ProTV < BaseFetcher

    def initialize
      @page_dir = "data/pages/protv/"
      @main_page = "http://protv.md"
      @news_feed = "http://protv.md/export/featured/json"

      @checker = Proc.new { |page| validate(page) }

      super
    end

    def validate(page)
      return false unless document(page).at_css('//h1[@itemprop="name headline"]')
      return true
    end

    def document(page)
      Nokogiri::HTML(page, nil, 'UTF-8')
    end

    def most_recent_id
      resp = JSON.parse(RestClient.get(news_feed))
      resp[0]["id"].to_i
    end
  end
end

