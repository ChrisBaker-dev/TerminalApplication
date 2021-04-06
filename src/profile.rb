class Profile

    attr_reader :username, :description, :available_funds, :investments

    def initialize(username)
        @username = username
        @description = nil
        @available_funds = nil
        @investments = {} #{'market synbol' => [shares, value]}

    end

    def change_username(username)
        @username = username
    end

    def update_description(desciption)
        @description = description
    end

    def add_investments(investment, shares, cost_per)
        if @investments.has_key? investment
            @investments[investment][0] += shares
            @investments[investment][1] += shares * cost_per
        end
    end





end