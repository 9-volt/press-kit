# A fetcher that knows how to fetch links properly
class SmartFetcher
  def self.fetch url, retry_on_socket_error=true
    RestClient.get url
  rescue Errno::ETIMEDOUT => e
    sleep 2
    puts "timeout: #{url}"
    retry
  rescue Errno::ECONNREFUSED => e
    sleep 30
    puts "refused: #{url}"
    retry
  rescue RestClient::BadGateway => error
    sleep 2
    puts "bad gateway: #{url}"
    retry
  rescue SocketError => error
    puts "socket error: #{url}"

    if retry_on_socket_error
      sleep 60
      retry
    else
      nil
    end

  rescue RestClient::Forbidden => error
    puts "forbidden: #{url}"
    nil
  rescue URI::InvalidURIError => error
    puts "invalid uri: #{url}"
    nil
  end
end
