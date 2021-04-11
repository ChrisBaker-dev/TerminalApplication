require 'tty-table'
class Profile

    attr_reader :username, :description, :available_funds, :investments, :starting_funds, :key

    def initialize(username) # may want to remove starting funds from here
        @username = username
        @description = ''
        @available_funds = starting_funds
        @starting_funds = starting_funds
        @investments = {} #{'market synbol' => [shares, value]}
        @key = ''
        @growth = 0
    end

    def change_username(username)
        @username = username
    end

    def update_description(description)
        @description = description
    end

    def load_investments(investments)
        @investments = investments
    end

    # Total Percentage growth of profiles investments/funds
    def update_growth()
        @growth = ((((get_holdings_total_value + @available_funds)/
                    @starting_funds).round(2)) * 100) - 100
        return @growth
    end

    # Amount of money an account starts with
    def add_starting_funds(starting_funds)
        @starting_funds = starting_funds
    end

    # updates amount of funds that can be spent
    def update_available_funds(amount)
        @available_funds = amount
    end

    def add_investments(investment, shares, cost_per)
        if @investments.key?(investment)
            @investments[investment][0] += shares
            @investments[investment][1] = (cost_per).round(2)
        else
            @investments[investment] = [shares, (cost_per).round(2)]
        end
    end

    def remove_investments(ticker, shares)
        @investments[ticker][0] -= shares 
    end

    # Adds key to use api
     def add_key(key)
         @key = key
    end

    def profile_data()
        return {
            'description': @description,
            'investments': @investments,
            'available_funds': @available_funds,
            'starting_funds': @starting_funds
        }
    end

    def profile_summary()
        table = TTY::Table.new do |t|
            t << ["Username:", @username]
            t << ["Available Funds", @available_funds]
            t << ["Growth", "%" + @growth.to_s]
        end
        return table
    end


    ## NEED TO FIX THE PRICE
    def display_holdings()
        table = TTY::Table.new
        table << ["Stock", "Shares", "Price", "Total"]
        if @investments.size == 0
            return
        end
        @investments.each do |key, value|
            table << [key, value[0], value[1], value[0] * value[1]]
        end
        return table
    end

    def get_stock_shares(ticker, num_shares_sell)
        if @investments.key?(ticker) == false
            return false
        elsif @investments[ticker][0] < num_shares_sell
            return false
        end
        return true
    end
    # Returns the total value of all stocks being held
    def get_holdings_total_value()
        result = 0
        @investments.each do |key, value|
            result = result + (value[0] * value[1])
            result.round(2)
        end
        return result
    end

end