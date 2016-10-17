# Not used yet, just a sketch
class BaseFetcher
  attr_accessor :page_dir, :main_page, :news_feed, :checker, :page

  def initialize(*args, &block)
    yield self if block_given?
    setup
  end

  def fetch_single(id)
    page = SmartFetcher.fetch(link(id), false)
    save(page, id) if valid?(page)
  end

  def valid?(page)
    return unless page
    return checker.call(page)
    true
  end

  def save(page, id)
    Zlib::GzipWriter.open(page_dir + id.to_s + ".html.gz") do |gz|
      gz.write page
    end
  end

  def link(id)
    "#{main_page}/stiri/actualitate/---#{id}.html"
  end

  def setup
    FileUtils.mkdir_p page_dir
  end
end
