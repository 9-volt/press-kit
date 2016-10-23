class LocalStorage
  attr_reader :dir

  def initialize(dir)
    @dir = dir
    create_directory_if_missing
  end

  def available_ids
    all_ids || 0
  end

  def latest_page_id
    @latest_page_id ||= get_latest_page_id
  end

  def save(page, id)
    Zlib::GzipWriter.open(dir + id.to_s + ".html.gz") do |gz|
      gz.write page
    end
  end

  def load_doc(id)
    Zlib::GzipReader.open("#{dir}#{id}.html.gz") { |gz| gz.read }
  end

  private

  def get_latest_page_id
    all_ids.last || 0
  end

  def all_ids
    Dir["#{dir}*"].map { |f| f.split('.').first.gsub(dir, "") }.map(&:to_i).sort
  end

  def create_directory_if_missing
    FileUtils.mkdir_p dir
  end
end

# I start to think that it's getting bloated but at the same time it
# kinda makes sense(ish). Good Lord it's not some sort of abstract factory
class LocalStorageFactory
  class << self
    def agora
      LocalStorage.new(Settings.storage_dir.agora)
    end

    def pro_tv
      LocalStorage.new(Settings.storage_dir.pro_tv)
    end

    def publika
      LocalStorage.new(Settings.storage_dir.publika)
    end

    def timpul
      LocalStorage.new(Settings.storage_dir.timpul)
    end

    def unimedia
      LocalStorage.new(Settings.storage_dir.unimedia)
    end
  end
end
