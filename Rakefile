require_relative "./main"

namespace :fetch do
  task :timpul do
    TimpulFetcher.new.run
  end

  task :publika do
    PublikaFetcher.new.run
  end

  task :unimedia do
    UnimediaFetcher.new.run
  end

  task :protv do
    Runners::ProTV.new.run
  end
end

namespace :parse do
  task :timpul do
    TimpulParser.new.run
  end

  task :publika do
    PublikaParser.new.run
  end

  task :unimedia do
    UnimediaParser.new.run
  end

  task :protv do
    Parsers::ProTV.new.run
  end
end

namespace :watch do
  ENV["ENV"] = "production"
  task :timpul do
    while true do
      puts "Restarting Fetcher"
      TimpulFetcher.new.run
      puts "Restarting parser"
      TimpulParser.new.run
      sleep 10
    end
  end

  task :publika do
    while true do
      puts "Restarting Fetcher"
      PublikaFetcher.new.run
      puts "Restarting parser"
      PublikaParser.new.run
      sleep 10
    end
  end

  task :unimedia do
    while true do
      puts "Restarting Fetcher"
      UnimediaFetcher.new.run
      puts "Restarting parser"
      UnimediaParser.new.run
      sleep 10
    end
  end
end
