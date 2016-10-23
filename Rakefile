require_relative "./main"

task :console do
  sh "ruby -e \"require('./main.rb');binding.pry\"" # khe khe
end

namespace :fetch do
  task :timpul do
    Fetchers::Timpul.new.run
  end

  task :publika do
    Fetchers::Publika.new.run
  end

  task :unimedia do
    Fetchers::Unimedia.new.run
  end

  task :protv do
    Fetchers::ProTv.new.run
  end

  task :reverse_protv, [:first, :last] do |_, args|
    Fetchers::ProTv.new.reverse_run(args[:first], args[:last])
  end

  task :agora do
    Fetchers::Agora.new.run
  end
end

namespace :parse do
  task :protv do
    Parsers::ProTv.new.run
  end

  task :timpul do
    Parsers::Timpul.new.run
  end

  task :publika do
    Parsers::Publika.new.run
  end

  task :unimedia do
    Parsers::Unimedia.new.run
  end
end

namespace :watch do
  ENV["ENV"] = "production"
  task :timpul do
    while true do
      puts "Restarting Fetcher"
      Fetchers::Timpul.new.run
      puts "Restarting parser"
      TimpulParser.new.run
      sleep 10
    end
  end

  task :publika do
    while true do
      puts "Restarting Fetcher"
      Fetchers::Publika.new.run
      puts "Restarting parser"
      PublikaParser.new.run
      sleep 10
    end
  end

  task :unimedia do
    while true do
      puts "Restarting Fetcher"
      Fetchers::Unimedia.new.run
      puts "Restarting parser"
      UnimediaParser.new.run
      sleep 10
    end
  end
end
