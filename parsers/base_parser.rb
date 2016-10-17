module Parsers
  class BaseParser
    attr_accessor :page_dir, :parsed_data, :main_url

    def build_url(id)
      "#{main_url}#{id}"
    end

    def load_doc(id)
      Zlib::GzipReader.open("#{@page_dir}#{id}.html.gz") { |gz| gz.read }
    end

    def parse_timestring(timestring)
      DateTime.strptime(timestring, "%d.%m.%Y %k:%M").iso8601
    end

    def save hash
      page = ParsedPage.new(hash)
      page.save
    end

    def latest_stored_id
      @latest_stored_id = Dir["#{@page_dir}*"].map{ |f| f.split('.').first.gsub(@page_dir, "") }
                              .map(&:to_i)
                              .sort
                              .last || 0
    end

    def available_pages
      @latest_stored_id = Dir["#{@page_dir}*"].map{ |f| f.split('.').first.gsub(@page_dir, "") }
                              .map(&:to_i)
                              .sort
    end

    def latest_parsed_id
      ParsedPage.where(source: 'protv').desc(:article_id).limit(1).first.article_id
    rescue
      0
    end

  end
end