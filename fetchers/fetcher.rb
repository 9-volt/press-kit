require_relative '../main'

class Fetcher
  def pages_left
    most_recent_id - latest_stored_id
  end

  def pages_total
    most_recent_id
  end

  def pages_fetched
    latest_stored_id
  end

  def fetch_single(id)
    page = RestClient.get(link(id))
    save(page, id)
  end

  def run
    setup
    puts "Fetching #{self.class.name}. Most recent: #{most_recent_id}. Last fetched: #{latest_stored_id}."

    if latest_stored_id == most_recent_id
      puts "Nothing to fetch for #{self.class.name}"
      return
    end

    latest_stored_id.upto(most_recent_id) do |id|
      fetch_single(id)
    end
  end
end
