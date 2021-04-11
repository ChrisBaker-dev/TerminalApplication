require 'test/unit'
require 'dotenv/load'
require_relative '../profile.rb'
require_relative '../stock.rb'
require_relative '../main.rb'


class StockTest < Test::Unit::TestCase

    def setup()
        @stock1 = Stock.new('MSFT', ENV['IEXKEY'])
    end

    def test_new_instance()
        assert_not_nil(@stock1)
    end
end
