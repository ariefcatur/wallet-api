module LatestStockPrice
  class Client
    include HTTParty
    base_uri 'https://latest-stock-price.p.rapidapi.com'

    def initialize
      @options = {
        headers: {
          'X-RapidAPI-Host' => 'latest-stock-price.p.rapidapi.com',
          'X-RapidAPI-Key' =>  Rails.application.credentials.rapid_api[:key] || ENV['RAPIDAPI_KEY']
        }
      }
    end

    def price(symbol)
      response = self.class.get("/price", @options.merge(query: { Indices: symbol }))
      handle_response(response)
    end

    def prices(symbols)
      puts "API request options: #{@options.inspect}"
      response = self.class.get("/price", @options.merge(query: { Indices: symbols.join(',') }))
      handle_response(response)
    end

    def price_all
      response = self.class.get("/any", @options)
      handle_response(response)
    end

    private

    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise "API request failed: #{response.code} - #{response.message}"
      end
    end
  end
end