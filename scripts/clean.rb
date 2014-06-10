require_relative "../main"

class Cleaner
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def pages_dir
    "data/parsed/#{source}/"
  end

  def parsed_dir
    "data/parsed/#{source}/"
  end

  def latest_id
    @last_parsed_id ||= Dir["#{parsed_dir}*"].map{ |f| f.gsub(parsed_dir, "") }
                          .map(&:to_i)
                          .sort
                          .last || 0
  end

  def check!(id)
    text = JSON.parse(File.read("#{parsed_dir}/#{id}"))

    if text.empty?
      FileUtils.rm_rf "#{parsed_dir}/#{id}"
      FileUtils.rm_rf "#{pages_dir}/#{id}"
    end
  end

  def progressbar
    @progressbar ||= ProgressBar.new(latest_id, :bar, :counter, :rate, :eta)
  end

  def run
    puts "Cleaning #{source}"
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

Cleaner.new("unimedia").run
Cleaner.new("timpul").run
