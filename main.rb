require 'rest_client'
require 'nokogiri'
require 'progress_bar'
require 'pry'
require 'json'
require 'i18n'
require 'mongoid'
require 'savon'
require_relative 'lib/config/database'

Config::Database.setup

require_relative "lib/person"
require_relative "lib/smart_fetcher"
require_relative "lib/parsed_page"
require_relative "lib/word"
require_relative "lib/batch_racai_fetcher"
require_relative "lib/racai_builder"
require_relative "analyzer"

require_relative "fetchers/timpul"
require_relative "fetchers/unimedia"
require_relative "fetchers/publika"
require_relative "fetchers/protv"

require_relative "parsers/timpul"
require_relative "parsers/unimedia"
require_relative "parsers/publika"
require_relative "parsers/protv"

require_relative "lib/helpers"