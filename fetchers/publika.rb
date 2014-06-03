require_relative "../main"

class PublikaFetcher
  PAGES_DIR = "./data/pages/publika/"
  FEED_URL  = "http://rss.publika.md/stiri.xml"

  def setup
    FileUtils.mkdir_p PAGES_DIR
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
    page.include?("publicat in data de")
  end

  def save(page, id)
    File.write(PAGES_DIR + id.to_s, page) if valid? page
  end

  def fetch_single(id)
    page = RestClient.get(link(id))
    save(page, id)
  rescue RestClient::Forbidden => error
    puts "RestClient::Forbidden caught"
    puts link(id)
    save(RestClient.get("http://www.publika.md"), id)
  rescue RestClient::BadGateway => error
    sleep 2
    puts "RestClient::BadGateway caught"
    retry
  end

  def progressbar
    @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
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
      progressbar.increment!
    end
  end
end
