require_relative "fetcher"

class PublikaFetcher < Fetcher
  PAGES_DIR = "./data/pages/publika/"
  FEED_URL  = "http://rss.publika.md/stiri.xml"

  def setup
    FileUtils.mkdir_p PAGES_DIR
  end

  def pages_left
    most_recent_id - latest_stored_id
  end

  def most_recent_id
    return @most_recent_id if @most_recent_id
    doc = Nokogiri::XML(RestClient.get(FEED_URL))
    @most_recent_id = doc.css("link")[2]
                         .text
                         .scan(/_([\d]+)\.html/)
                         .first
                         .first
                         .to_i / 10
    # dividing by 10 is pure publika magic
  end

  def latest_stored_id
    Dir["#{PAGES_DIR}*"].map{ |f| f.gsub(PAGES_DIR, "") }
                        .map(&:to_i)
                        .sort
                        .last || 0
  end

  def link(id)
    "http://publika.md/#{id}1"
  end

  def valid?(page)
    page.match("publicat in data de")
  end

  def save(page, id)
    File.write(PAGES_DIR + id.to_s, page) if valid? page
  end

  def fetch_single(id)
    page = RestClient.get(link(id))
    save(page, id)
  end

  def run
    setup
    puts "Fetching Publika. Most recent: #{most_recent_id}. Last fetched: #{latest_stored_id}."

    if latest_stored_id == most_recent_id
      puts "Nothing to fetch for Publika"
      return
    end

    latest_stored_id.upto(most_recent_id) do |id|
      fetch_single(id)
    end
  end
end
