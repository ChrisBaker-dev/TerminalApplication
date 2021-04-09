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
            @investments[investment][1] += (shares * cost_per).round(2)
        else
            @investments[investment] = [shares, (cost_per * shares).round(2)]
        end
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
            t << ["Growth", @growth]
        end
        return table

    end
end