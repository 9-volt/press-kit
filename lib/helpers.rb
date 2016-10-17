module Helpers
  def doc(page)
    Nokogiri::HTML(page, nil, 'UTF-8')
  end
end