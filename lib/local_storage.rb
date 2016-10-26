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
    path = "#{dir}#{id}.html.gz"
    save_zip(page, path)
  end

  def load_doc(id)
    path = "#{dir}#{id}.html.gz"
    load_zip(path)
  end

  def get_latest_page_id
    all_ids.last || 0
  end

  def all_ids
    Dir["#{dir}*"].map { |f| f.split('.').first.gsub(dir, "") }.map(&:to_i).sort
  end

  private

  def create_directory_if_missing
    FileUtils.mkdir_p dir
  end

  def load_zip(path)
    Zlib::GzipReader.open(path) { |gz| gz.read }
  end

  def save_zip(page, path)
    Zlib::GzipWriter.open(path) { |gz| gz.write(page) }
  end
end

class PrimeLocalStorage < LocalStorage
  PageAndCategory = Struct.new(:page, :category)

  def save(page, id, category)
    path = "#{dir}#{id}.#{category}.html.gz"
    save_zip(page, path)
  end

  def load_doc(id)
    path = Dir["#{dir}#{id}.*.html.gz"].first
    page = load_zip(path)
    PageAndCategory.new(page, extract_category(path))
  end
  
  def extract_category(path)
    path.match(/\d+\.([A-z]+)\./).captures.first
  end
end

# I start to think that it's getting bloated but at the same time it
# kinda makes sense(ish). Good Lord it's not some sort of abstract factory
class LocalStorageFactory
  class << self
    def in_profunzime
      LocalStorage.new(Settings.storage_dir.in_profunzime)
    end
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

    def prime
      PrimeLocalStorage.new(Settings.storage_dir.prime)
    end
  end
end
