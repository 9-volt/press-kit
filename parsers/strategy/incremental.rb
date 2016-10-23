module Parsers
  module Strategy
    module Incremental
      def available_ids
        storage.available_ids
      end

      def build_url(id)
        url.build(id)
      end

      def load_doc(id)
        storage.load_doc(id)
      end

      def save(hash)
        ParsedPage.new(hash).save
      end

      def latest_stored_id
        storage.latest_page_id
      end

      def latest_parsed_id
        @latest_parsed_id ||= fetch_latest_parsed_id
      end

      def fetch_latest_parsed_id
        ParsedPage.where(source: source).desc(:article_id).limit(1).first.article_id
      rescue
        0
      end

      def define_range(available_ids, latest_parsed_id)
        if latest_parsed_id == 0
          available_ids[0..available_ids.last]
        else
          available_ids[available_ids.index(latest_parsed_id)..available_ids.last]
        end
      end

      def progress(id)
        "#{id}/#{latest_stored_id}"
      end

      def run
        define_range(available_ids, latest_parsed_id).each do |id|
          begin
            puts "\n#{self.class.name}: #{progress(id)}"
            html = load_doc(id)
            hash = parse(html, id)

            if hash
              save(hash)
            else
              puts "NO DATA"
            end
          rescue Errno::ENOENT
            puts "NOT SAVED TO DISK"
          end
        end
      end
    end
  end
end
