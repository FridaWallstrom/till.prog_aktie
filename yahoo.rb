require "csv"
require "net/http"
require "uri"

def uri(symbols, format)
  res= "http://download.finance.yahoo.com/d/quotes.csv?"
  res << "s=#{symbols.join("+")}&f=#{format}"
  p res
  URI(res)
end

OPTIONS = eval(DATA.read).invert

def options(*args)
  res = OPTIONS.values_at(*args) 
  res = OPTIONS.values if res.empty?
  res
end


format = options("Average Daily Volume", "Book Value")
res = Net::HTTP.get_response(uri(%w[ge goog], format.join))
p res.body
p CSV.parse(res.body) if res.is_a?(Net::HTTPSuccess)

###############

require 'uri'
require 'net/http'
require 'openssl'

url = URI("https://yfapi.net/v8/finance/spark?symbols=AAPL")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["x-api-key"] = 'YOUR-PERSONAL-API-KEY'

response = http.request(request)
puts response.read_body
