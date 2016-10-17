require_relative "base_parser"

module Parsers
  class ProTV < BaseParser
    # include ::Helpers
    def initialize
      @page_dir = "data/pages/protv/"
      @main_url = "http://protv.md/"
    end

    def has_data?(doc)
      return false if doc.title.match(/ProTV Chisinau - Gandeste liber/)
      doc.xpath("//div[@class='padding010 articleContent']").any?
    end

    def parse(text, id)
      doc = Nokogiri::HTML(text, nil, 'UTF-8')

      return unless has_data?(doc)

      title = doc.xpath("//div[@class='padding010 articleContent']/h1").text

      date_time = doc.xpath("//div[@itemprop='datePublished']").text

      content = doc.xpath("//div[contains(@class, 'articleContent')]//p").text

      content.force_encoding("BINARY").delete! 160.chr+194.chr

      content.force_encoding("UTF-8")

      {
          source: "ProTV",
          title: title,
          original_time: date_time,
          datetime: parse_timestring(date_time),
          views: 0,
          comments: 0,
          content: content,
          article_id: id,
          url: build_url(id)
      }
    rescue => e
      puts "ProTV: #{e}"
      return
    end
  end
end