require_relative "fetcher"

class PublikaFetcher < Fetcher
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
    page.match("publicat in data de")
  end

  def save(page, id)
    File.write(PAGES_DIR + id.to_s, page) if valid? page
  end
end
