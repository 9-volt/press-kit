require_relative "fetcher"

class TimpulFetcher < Fetcher
  PAGES_DIR  = "./data/pages/timpul/"
  TITTER_URL = "https://twitter.com/Timpul"

  def setup
    FileUtils.mkdir_p PAGES_DIR
  end

  def most_recent_id
    return @most_recent_id if @most_recent_id
    doc = Nokogiri::XML(RestClient.get(TITTER_URL))
    @most_recent_id = doc.css(".tweet-text")
                         .text
                         .scan(/timpul.md\/u_[\d]+\//)
                         .max_by { |f| f.scan(/\d+/) }
                         .scan(/\d+/)
                         .first
                         .to_i
  end

  def latest_stored_id
    Dir["#{PAGES_DIR}*"].map{ |f| f.gsub(PAGES_DIR, "") }
                        .map(&:to_i)
                        .sort
                        .last || 0
  end

  def link(id)
    "http://www.timpul.md/u_#{id}/"
  end

  def save(page, id)
    File.write(PAGES_DIR + id.to_s, page)
  end

  def fetch_single(id)
    page = RestClient.get(link(id))
    save(page, id)
  rescue URI::InvalidURIError => error
    puts error
    puts link(id)
    # URI::InvalidURIError: bad URI(is not URI?):
    # http://ru.timpul.md/articol/35897-------–----.html
    save(RestClient.get("http://www.timpul.md"), id)
  rescue RestClient::BadGateway => error
    sleep 2
    puts "RestClient::BadGateway caught"
    retry
  end
end
