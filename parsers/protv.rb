module Parsers
  class ProTv
    include Strategy::Incremental
    attr_reader :url, :storage, :source

    def initialize(storage: LocalStorageFactory.pro_tv, url: URL::ProTv.new)
      @storage = storage
      @url = url
      @source = "protv"
    end

    def parse(html, id)
      doc = Nokogiri::HTML(html, nil, "UTF-8")

      return unless has_data?(doc)

      title = doc.xpath("//div[@class='padding010 articleContent']/h1").text
      date_time = doc.xpath("//div[@itemprop='datePublished']").text

      content = doc.xpath("//div[contains(@class, 'articleContent')]//p").text
      content.force_encoding("BINARY").delete!(160.chr+194.chr)
      content.force_encoding("UTF-8")

      {
        source: source,
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
    end

    def has_data?(doc)
      return false if doc.title.match(/ProTV Chisinau - Gandeste liber/)
      doc.xpath("//div[@class='padding010 articleContent']").any?
    end

    def parse_timestring(timestring)
      DateTime.strptime(timestring, "%d.%m.%Y %k:%M").iso8601
    end
  end
end
