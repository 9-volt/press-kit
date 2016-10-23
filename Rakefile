require_relative "./main"

task :console do
  sh "ruby -e \"require('./main.rb');binding.pry\""
end

desc "Fetched only new content by default."
namespace :fetch do
  desc "Fetch resources from Timpul Source"
  task :timpul, [:first, :last] do |_task, options|
    Fetchers::Timpul.new.run(options[:first], options[:last])
  end

  desc "Fetch resources from Publika Source"
  task :publika, [:first, :last] do |_task, options|
    Fetchers::Publika.new.run(options[:first], options[:last])
  end

  desc "Fetch resources from Unimedia Source"
  task :unimedia, [:first, :last] do |_task, options|
    Fetchers::Unimedia.new.run(options[:first], options[:last])
  end

  desc "Fetch resources from ProTV Source"
  task :protv, [:first, :last] do |_task, options|
    Fetchers::ProTv.new.run(options[:first], options[:last])
  end

  desc "Fetch resources from Agora Source"
  task :agora, [:first, :last] do |_task, options|
    Fetchers::Agora.new.run(options[:first], options[:last])
  end
end

namespace :parse do
  desc "Parse ProTV source and update DB"
  task :protv do
    Parsers::ProTv.new.run
  end

  desc "Parse Timpul source and update DB"
  task :timpul do
    Parsers::Timpul.new.run
  end

  desc "Parse Publika source and update DB"
  task :publika do
    Parsers::Publika.new.run
  end

  desc "Parse Unimedia source and update DB"
  task :unimedia do
    Parsers::Unimedia.new.run
  end

  task :agora do
    Parsers::Agora.new.run
  end
end
