require 'iex-ruby-client'
require 'tty-table'
class Stock
    attr_reader :ticker

    def initialize(ticker, iex_key)
        @ticker = ticker
        @key = iex_key
        @client = IEX::Api::Client.new(
            publishable_token: iex_key,
            endpoint: 'https://cloud.iexapis.com/v1'
            )
        @quote = @client.quote(@ticker)
    end

    def get_price()
        return @quote.latest_price
    end

    def price_change()
        return @quote.change
    end

    def price_percent_change()
        return @quote.change_percent
    end


end