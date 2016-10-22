module Helpers
  module IncrementalStrategy
    def run
      class_name = self.class.name
      puts "Fetching #{class_name}"

      if all_pages_are_fetched?
        puts "Nothing to fetch for #{class_name}"
        return
      end

      page_ids.each do |id|
        page = fetch_single(id)
        save(page, id) if valid?(page)
        progressbar.increment!
      end
    end

    def reverse_run(first, last)
      class_name = self.class.name
      puts "Fetching #{class_name}"

      array = []

      (first..last).step(10) do |id|
        array << id
      end

      reverse_array = []

      array.reverse_each do |id|
        reverse_array << id
      end

      # array.reverse_each do |id|
      #   page = fetch_single(id)
      #   save(page, id) if valid?(page)
      # en

      Parallel.each(reverse_array, in_processes: 4, progress: "Executing #{class_name}") do |id|
        page = fetch_single(id)
        save(page, id) if valid?(page)
      end
    end

    def run_parallel
      class_name = self.class.name
      puts "Fetching #{class_name}"

      if all_pages_are_fetched?
        puts "Nothing to fetch for #{class_name}"
        return
      end

      Parallel.each(page_ids, in_processes: 4, progress: "Executing #{class_name}") do |id|
        page = fetch_single(id)
        save(page, id) if valid?(page)
      end
    end

    def all_pages_are_fetched?
      latest_stored_id == most_recent_id
    end

    def latest_stored_id
      @storage.latest_page_id
    end

    def save(page, id)
      @storage.save(page, id)
    end

    def most_recent_id
      @most_recent_id ||= fetch_most_recent_id
    end

    def progressbar
      @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
    end
  end
end
