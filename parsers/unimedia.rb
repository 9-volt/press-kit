module Parsers
  class Unimedia
    include Strategy::Incremental
    attr_reader :url, :storage, :source

    def initialize(storage: LocalStorageFactory.unimedia, url: URL::Unimedia.new)
      @storage = storage
      @url = url
      @source = "unimedia"
    end

    def parse(html, id)
      doc = Nokogiri::HTML(html, nil, "UTF-8")
      return if cannot_be_parsed?(doc)

      title = doc.css("h1.bigtitlex2").first.text rescue doc.title
      timestring, views, comments = doc.css(".left-container > .news-details > .white-v-separator").map(&:text)
      content = doc.css(".news-text").text.gsub(/\r|\n/, " ").squeeze(" ")

      {
        source:         source,
        title:          title,
        original_time:  timestring,
        datetime:       parse_timestring(timestring),
        views:          views.to_i,
        comments:       comments.to_i,
        content:        content,
        article_id:     id,
        url:            build_url(id)
      }
    rescue => e
      puts "Unimedia: #{e}"
    end

    def cannot_be_parsed?(doc)
      doc.title.match(/pagină nu există/) || doc.title.match(/UNIMEDIA - Portalul de știri nr. 1 din Moldova/)
    end

    def parse_timestring(timestring)
      # ora: 09:42, 02 mai 2009
      timestring.gsub!("ian", "jan")
      timestring.gsub!("mai", "may")
      timestring.gsub!("iun", "jun")
      timestring.gsub!("iul", "jul")
      timestring.gsub!("noi", "nov")
      return DateTime.strptime(timestring, "ora: %k:%M, %d %b %Y").iso8601
    end
  end
end
