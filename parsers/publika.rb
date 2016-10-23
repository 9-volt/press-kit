module Parsers
  class Publika
    include Strategy::Incremental
    include Helpers::SanitizeDates
    attr_reader :url, :storage, :source

    def initialize(storage: LocalStorageFactory.publika, url: URL::Publika.new)
      @storage = storage
      @url = url
      @source = "publika"
    end

    def parse(html, id)
      doc = Nokogiri::HTML(html, nil, "UTF-8")

      return unless has_data?(doc)

      title = doc.xpath("//div[@id='articleLeftColumn']/h1").text
      article_info = doc.xpath("//div[@class='articleInfo']").text.split(', ')
      date = article_info[2]
      ora = article_info[3][0..9]

      content = doc.xpath("//div[@itemprop='articleBody']").text

      {
        source:         source,
        title:          title,
        original_time: "Date: #{date} Time: #{ora}",
        datetime:       parse_timestring(date.concat(ora)),
        views:          0,
        comments:       0,
        content:        content,
        article_id:     id,
        url:            build_url(id)
      }
    rescue => e
      puts "Publika: #{e}"
    end

    def has_data?(doc)
      doc.xpath("//div[@class='articleTags']").any?
    end

    def parse_timestring(timestring)
      sanitized_timestring = months_ro_to_en(timestring)
      DateTime.strptime(sanitized_timestring , "%d %b %Y ora %k:%M").iso8601
    end
  end
end
