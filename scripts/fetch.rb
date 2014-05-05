require_relative "../main"

adapters = [PublikaFetcher, TimpulFetcher, UnimediaFetcher]

class Status < Struct.new(:targets)
  def update!
    @fetched = nil
  end

  def total
    @total ||= targets.map(&:pages_total).reduce(:+)
  end

  def fetched
    @fetched ||= targets.map(&:pages_fetched).reduce(:+)
  end
end

fetchers = adapters.map(&:new)
threads = fetchers.map do |fetcher|
  Thread.new { fetcher.run }
end

status = Status.new fetchers
threads.each(&:run)

bar = ProgressBar.new(status.total, :bar, :counter, :rate, :eta)
bar.increment! status.fetched

loop do
  last = status.fetched
  status.update!
  current = status.fetched

  bar.increment! current - last
  sleep 1
end

threads.each(&:join)
