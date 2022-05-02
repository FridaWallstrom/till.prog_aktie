class DataError < StandardError; end

def get_price(ticker)
	scrape_url = 'https://finance.yahoo.com/quote'
	ticker_url = "#{scrape_url}/#{ticker}"

	tries = 0

	while(true)
		begin 
			response = Net::HTTP.get(
					URI(ticker_url), 
					{'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36'}
			)

			json = JSON.parse(response.partition('root.App.main = ')[2].partition('}(this)')[0].chomp.chop)
			price = json['context']['dispatcher']['stores']['QuoteSummaryStore']['price']['regularMarketPrice']['raw'].to_f
		rescue => error
			tries += 1
			if(tries >= 3)
				raise DataError, "Error #{error.message}"
			end
		else
			return price
		end
	end
end

class Main < Sinatra::Base
	configure do
		# set :show_exceptions, false
		set :static_cache_control, [:no_store, :max_age => 0]
	end

	before do
		cache_control :no_store, :max_age => 0
	end

    get '/' do
		send_file File.join('views', 'index.html')
    end

	get '/test' do
		slim :main
    end

	post '/data' do
		ticker = params['ticker']
		
		dividends_per_share_next_year = params['dividends_per_share_next_year'].to_f
		current_market_value = params['current_market_value'].to_f
		growth_rate_dividends = params['growth_rate_dividends'].to_f

		market_value_equity = params['market_value_equity'].to_f
		market_value_debt = params['market_value_debt'].to_f
		cost_debt = params['cost_debt'].to_f
		corporate_tax_rate = params['corporate_tax_rate'].to_f

		profit = params['profit'].to_f
		additional_years = params['additional_years'].to_f
		growth_rate = params['growth_rate'].to_f

		rentbearing_assets = params['rentbearing_assets'].to_f
		rentbearing_debt = params['rentbearing_debt'].to_f

		share_quantity = params['share_quantity'].to_f

		@price = get_price(ticker)


		coe = get_cost_of_equity(dividends_per_share_next_year, @price, growth_rate_dividends)
		wacc = get_wacc(market_value_equity, market_value_debt, cost_debt, corporate_tax_rate, coe)
		dcf = get_dcf(profit, growth_rate, additional_years, wacc)
		net_cash = get_net_cash(rentbearing_assets, rentbearing_debt)

		@result = get_value(share_quantity, net_cash, dcf).to_s
		@percentage = percentage(@result.to_f, @price.to_f).to_s
		slim :result
	end

	not_found do
		status 404
		'Sidan saknas'
	end

	error do
		status 500
		'Något gick fel'
	end
end
