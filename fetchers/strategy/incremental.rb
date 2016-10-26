module Fetchers
  module Strategy
    module Incremental
      def run(start = nil, finish = nil)
        run_info

        page_ids(start, finish).each do |id|
          page = fetch_single(id)
          save(page, id) if valid?(page)
          progressbar.increment!
        end
      end


    def page_ids(start=latest_stored_id, finish=most_recent_id)
      (start..finish)
    end


      def run_info
        puts "Fetching #{class_name}"

        if all_pages_are_fetched?
          puts "Nothing to fetch for #{class_name}"
          return
        end
      end

      def class_name
        self.class.name
      end

      def build_url(id)
        url.build(id)
      end

      def all_pages_are_fetched?
        latest_stored_id >= most_recent_id
      end

      def latest_stored_id
        storage.latest_page_id
      end

      def save(page, id)
        storage.save(page, id)
      end

      def most_recent_id
        @most_recent_id ||= fetch_most_recent_id
      end

      def progressbar
        @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
      end
    end
  end
end
