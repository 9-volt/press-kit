require_relative "./main"

sources = ['Timpul', 'Publika', 'Unimedia', 'ProTv', 'Agora', 'Prime']

desc "Run for debug mode"
task :console do
  sh "ruby -e \"require('./main.rb');binding.pry\""
end

sources.each do |source|
  namespace :fetch do
    desc "Fetch resources from #{source} Source"
    task source.downcase.to_sym, [:first, :last] do |_task, options|
      if options.to_hash != {}
        Kernel.const_get("Fetchers::#{source}").new.run(options[:first], options[:last])
      else
        Kernel.const_get("Fetchers::#{source}").new.run
      end
    end
  end

  namespace :parse do
    desc "Parse resources from #{source} and update DB"
    task source.downcase.to_sym do
      Kernel.const_get("Parsers::#{source}").new.run
    end
  end
end
