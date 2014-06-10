require_relative "../main"

class TimpulFetcher
  PAGES_DIR  = "data/pages/timpul/"
  TITTER_URL = "https://twitter.com/Timpul"

  def setup
    FileUtils.mkdir_p PAGES_DIR
  end

  def most_recent_id
    return @most_recent_id if @most_recent_id
    doc = Nokogiri::XML(RestClient.get(TITTER_URL))
    @most_recent_id = doc.text
                         .scan(/timpul.md\/u_[\d]+\//)
                         .max_by { |f| f.scan(/\d+/) }
                         .scan(/\d+/)
                         .first
                         .to_i
  end

  def latest_stored_id
    Dir["#{PAGES_DIR}*"].map{ |f| f.split('.').first.gsub(PAGES_DIR, "") }
                        .map(&:to_i)
                        .sort
                        .last || 0
  end

  def link(id)
    "http://www.timpul.md/u_#{id}/"
  end

  def save(page, id)
    Zlib::GzipWriter.open(PAGES_DIR + id.to_s + ".html.gz") do |gz|
      gz.write page
    end
  end

  def fetch_single(id)
    page = SmartFetcher.fetch(link(id), false)
    save(page, id) if valid?(page)
  end
  
  def valid? page
    return unless page
    doc = Nokogiri::HTML(text, nil, 'UTF-8')
    return false if doc.title == "Timpul - Ştiri din Moldova"
    return false unless doc.css('.content').size > 0
    
    true
  end

  def progressbar
    @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
  end

  def run
    setup
    puts "Fetching Timpul. Most recent: #{most_recent_id}. Last fetched: #{latest_stored_id}."

    if latest_stored_id == most_recent_id
      puts "Nothing to fetch for Timpul"
      return
    end

    latest_stored_id.upto(most_recent_id) do |id|
      fetch_single(id)
      progressbar.increment!
    end
  end
end
