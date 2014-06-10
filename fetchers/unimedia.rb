require_relative "../main"

class UnimediaFetcher
  PAGES_DIR = "./data/pages/unimedia/"
  FEED_URL  = "http://unimedia.info/rss/news.xml"

  def setup
    FileUtils.mkdir_p PAGES_DIR
  end

  def most_recent_id
    return @most_recent_id if @most_recent_id
    doc = Nokogiri::XML(RestClient.get(FEED_URL))
    @most_recent_id = doc.css("link")[3].text.scan(/-([\d]+)\.html.+/).first.first.to_i
  end

  def latest_stored_id
    Dir["#{PAGES_DIR}*"].map{ |f| f.gsub(PAGES_DIR, "") }
                        .map(&:to_i)
                        .sort
                        .last || 0
  end

  def link(id)
    "http://unimedia.info/stiri/-#{id}.html"
  end

  def save(page, id)
    File.write(PAGES_DIR + id.to_s, page)
  end

  def fetch_single(id)
    page = RestClient.get(link(id))
    save(page, id)
  rescue RestClient::ResourceNotFound
  end

  def progressbar
    @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
  end

  def run
    setup
    puts "Fetching Unimedia. Most recent: #{most_recent_id}. Last fetched: #{latest_stored_id}."

    if latest_stored_id == most_recent_id
      puts "Nothing to fetch for Unimedia"
      return
    end

    latest_stored_id.upto(most_recent_id) do |id|
      fetch_single(id)
      progressbar.increment!
    end
  end
end
