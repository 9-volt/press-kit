require 'active_record'

def sqlite_db name
  File.join(File.dirname(__FILE__), "./db/#{name}.sqlite3")
end

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => sqlite_db(:data)
)

Dir[File.dirname(__FILE__) + "/models/*.rb"].each {|file| require file }

