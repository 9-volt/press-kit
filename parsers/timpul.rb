require_relative "../main"

class TimpulParser
  PAGES_DIR       = "data/pages/timpul/"
  PARSED_DIR      = "data/parsed/timpul/"
  FileUtils.mkdir_p "data/parsed/timpul"

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
    # 27 Aprilie 2014, ora 08:22
    timestring.gsub!("Aprilie",    "apr")
    timestring.gsub!("Mai",        "may")
    timestring.gsub!("Iunie",      "jun")
    timestring.gsub!("Iulie",      "jul")
    timestring.gsub!("August",     "aug")
    timestring.gsub!("Septembrie", "sep")
    timestring.gsub!("Octombrie",  "oct")
    timestring.gsub!("Noiembrie",  "nov")
    timestring.gsub!("Decembrie",  "dec")
    timestring.gsub!("Ianuarie",   "jan")
    timestring.gsub!("Februarie",  "feb")
    timestring.gsub!("Martie",     "mar")
    return DateTime.strptime(timestring, "%d %b %Y, ora %k:%M").iso8601
  end

  def sanitize_node!(doc)
    doc.css('.changeFont').css("script").each do |div|
      new_node = doc.create_element "p"
      div.replace new_node
    end
  end

  def build_url(id)
    "http://www.timpul.md/u_#{id}/"
  end

  def parse(text, id)
    doc = Nokogiri::HTML(text)
    return {} if doc.title == "Timpul - Ştiri din Moldova"
    title = doc.title.split(" | ").first.strip rescue doc.title

    timestring = doc.css('.box.artGallery').css('.data_author').text.split("\n").map(&:strip)[2]

    sanitize_node!(doc)

    content = doc.css('.changeFont').text.gsub("\n", '').gsub("\t",'').strip

    result = {
      source:         "timpul",
      title:          title,
      original_time:  timestring,
      datetime:       parse_timestring(timestring),
      views:          0, # No data
      comments:       0, # Disqus iframe
      content:        content,
      id:             id,
      url:            build_url(id)
    }
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
