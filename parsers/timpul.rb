module Parsers
  class Timpul
    include Strategy::Incremental
    include Helpers::SanitizeDates
    attr_reader :url, :storage, :source

    def initialize(storage: LocalStorageFactory.timpul, url: URL::Timpul.new)
      @storage = storage
      @url = url
      @source = "timpul"
    end

    def parse(html, id)
      doc = Nokogiri::HTML(html, nil, "UTF-8")

      return if cannot_be_parsed?(doc)

      title = doc.title.split(" | ").first.strip rescue doc.title
      timestring = doc.css(".box.artGallery").css(".data_author").text.split("\n").map(&:strip)[2]
      sanitize_node!(doc)
      sanitized_content = extract_content_from_sanitized_doc(doc)
      return if sanitized_content.size == 0

      {
        source:         source,
        title:          title,
        original_time:  timestring,
        datetime:       parse_timestring(timestring),
        views:          0, # No data
        comments:       0, # Disqus iframe
        content:        sanitized_content,
        article_id:     id.to_i,
        url:            build_url(id)
      }
    end

    def sanitize_node!(doc)
      doc.css(".changeFont").css("script").each do |div|
        new_node = doc.create_element("p")
        div.replace(new_node)
      end
    end


    def cannot_be_parsed?(doc)
      wrong_title?(doc) || empty_content?(doc)
    end

    def extract_content_from_sanitized_doc(doc)
      doc.css(".changeFont").text.gsub("\n", "").gsub("\t", "").strip
    end

    def wrong_title?(doc)
      doc.title == "Timpul - Ştiri din Moldova"
    end

    def empty_content?(doc)
      doc.css(".content").size == 0
    end

    def parse_timestring(timestring)
      sanitized_timestring = months_ro_to_en(timestring)
      DateTime.strptime(sanitized_timestring , "%d %b %Y, ora %k:%M").iso8601
    end
  end
end
