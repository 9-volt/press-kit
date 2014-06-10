require_relative "../main"

class UnimediaCleaner
  PARSED_DIR = "data/parsed/unimedia/"
  PAGES_DIR  = "data/pages/unimedia/"

  def latest_id
    @last_parsed_id ||= Dir["#{PARSED_DIR}*"].map{ |f| f.gsub(PARSED_DIR, "") }
                          .map(&:to_i)
                          .sort
                          .last || 0
  end

  def check!(id)
    text = JSON.parse(File.read("#{PARSED_DIR}/#{id}"))

    if text.empty?
      FileUtils.rm_rf "#{PARSED_DIR}/#{id}"
      FileUtils.rm_rf "#{PAGES_DIR}/#{id}"
    end
  end

  def progressbar
    @progressbar ||= ProgressBar.new(latest_id, :bar, :counter, :rate, :eta)
  end

  def run
    (0..latest_id).to_a.each do |id|
      progressbar.increment!
      begin
        check!(id)
      rescue Errno::ENOENT => error
        next
      end
    end
  end
end
