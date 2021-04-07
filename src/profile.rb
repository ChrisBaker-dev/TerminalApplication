class Profile

    attr_reader :username, :description, :available_funds, :investments

    def initialize(username, starting_funds)
        @username = username
        @description = ''
        @available_funds = starting_funds
        @investments = {} #{'market synbol' => [shares, value]}
        # @key = ''

    end

    def change_username(username)
        @username = username
    end

    def update_description(description)
        @description = description
    end

    def add_investments(investment, shares, cost_per)
        if @investments.has_key? investment
            @investments[investment][0] += shares
            @investments[investment][1] += shares * cost_per
        else
            @investments[investment] = [shares, cost_per * shares]
        end
    end

    # Adds key to use api
    # def add_key(key)
    #     @key = key
    # end




end