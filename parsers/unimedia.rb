require_relative "../main"

class UnimediaParser
  PAGES_DIR       = "data/pages/unimedia/"
  PARSED_DIR      = "data/parsed/unimedia/"
  FileUtils.mkdir_p "data/parsed/unimedia"

  def latest_stored_id
    @last_stored_id ||= Dir["#{PAGES_DIR}*"].map{ |f| f.gsub(PAGES_DIR, "") }
                          .map(&:to_i)
                          .sort
                          .last || 0
  end

  def latest_parsed_id
    @last_parsed_id ||= Dir["#{PARSED_DIR}*"].map{ |f| f.gsub(PARSED_DIR, "") }
                          .map(&:to_i)
                          .sort
                          .last || 0
  end

  def load_doc(id)
    File.read "#{PAGES_DIR}/#{id}"
  end

  def parse_timestring(timestring)
    # ora: 09:42, 02 mai 2009
    timestring.gsub!("ian", "jan")
    timestring.gsub!("mai", "may")
    timestring.gsub!("iun", "jun")
    timestring.gsub!("iul", "jul")
    timestring.gsub!("noi", "nov")
    return DateTime.strptime(timestring, "ora: %k:%M, %d %b %Y").iso8601
  end

  def build_url(id)
    "http://unimedia.info/stiri/-#{id}.html"
  end

  def parse(text, id)
    doc = Nokogiri::HTML(text)
    if doc.title.match(/pagină nu există/) or doc.title.match(/UNIMEDIA - Portalul de știri nr. 1 din Moldova/)
      return {}
    end

    title = doc.css('h1.bigtitlex2').first.text rescue doc.title
    timestring, views, comments = doc.css('.left-container > .news-details > .white-v-separator').map(&:text)
    content = doc.css('.news-text').text.gsub(/\r|\n/, ' ').squeeze(' ')

    result = {
      source:         "unimedia",
      title:          title,
      original_time:  timestring,
      datetime:       parse_timestring(timestring),
      views:          views.to_i,
      comments:       comments.to_i,
      content:        content,
      id:             id,
      url:            build_url(id)
    }
  rescue => e
    binding.pry
  end

  def save(id, hash)
    data = JSON.pretty_generate(hash)
    File.write(PARSED_DIR + id.to_s, data)
  end

  def progress(id)
    total = latest_stored_id - latest_parsed_id
    current = id - latest_parsed_id
    (current / total.to_f * 100).round(2)
  end

  def run
    (latest_parsed_id..latest_stored_id).to_a.each do |id|
      begin
        hash = parse(load_doc(id), id)
        puts progress(id).to_s + "% done"
        save(id, hash) unless hash.empty?
      rescue Errno::ENOENT => error
        next
      end
    end
  end
end
