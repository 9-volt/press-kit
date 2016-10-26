module URL
  class ProTv
    attr_reader :base

    def initialize
      @base = "http://protv.md"
    end

    def build(id)
      "#{base}/stiri/actualitate/---#{id}.html"
    end
  end

  class Agora
    attr_reader :base

    def initialize
      @base = "http://agora.md"
    end

    def build(id)
      "#{base}/stiri/#{id}/"
    end
  end

  class Publika
    attr_reader :base

    def initialize
      @base = "http://publika.md"
    end

    def build(id)
      "#{base}/#{id}"
    end
  end

  class Timpul
    attr_reader :base

    def initialize
      @base = "http://www.timpul.md"
    end

    def build(id)
      "#{base}/u_#{id}/"
    end
  end

  class Unimedia
    attr_reader :base

    def initialize
      @base = "http://unimedia.info"
    end

    def build(id)
      "#{base}/stiri/-#{id}.html"
    end
  end

  class Prime
    attr_reader :base, :news_categories

    def initialize
      @base = "http://www.prime.md"
      # The categories are extracted from Prime webpage
      @news_categories = %w{politics social economic 
                            other sport externe
                            crime cultura news}
    end

    def all_possible(id)
      news_categories.map { |category| [build(id, category), category] }
    end

    def build(id, category)
      "#{base}/rom/news/#{category}/item#{id}/"
    end

    def main_news_page
      "#{base}/rom/news/"
    end
  end
end
