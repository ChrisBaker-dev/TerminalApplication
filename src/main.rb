require_relative './profile.rb'
require_relative './exceptions.rb'
require_relative './stock.rb'
require 'json'
require 'tty-prompt'
require 'tty-table'


# Welcoming message to the application
# Returns string login or sign-up depending on users choice
def welcome_message(prompt)
    options = ["Login", "Sign-up", "Quit"]

    puts "-------------------------------------------------"
    puts "Thank you for using CB Finance Tools!"
    prompt.select("Would you like to Login or Sign-up?", options)

    # while true
    #     answer = gets.chomp!.downcase
    #     if answer == "login" or answer == "sign-up" or answer == "quit"
    #         return answer
    #     else 
    #         puts "Please enter valid option"
    #         puts options
    #     end
    # end
end

# Creates object Profile for new account
def create_profile(profiles)
    puts "-------------------------------------------------"
    puts "You have selected to create a new profile"
    username = get_username()
    hash = load_profiles(profiles)
    until is_valid_username?(username, hash) == true do
        username = get_username()
    end
    puts "Please enter a starting amount of funds (ex. 50000):"
    funds = gets.chomp!
    funds = add_funds(funds)
    profile = Profile.new(username)
    profile.add_starting_funds(funds)
    return profile
end

# Returns an integer if the input is a number
def add_funds(funds)
    until funds.to_i.is_a?(Integer) and funds.to_i > 0 do
        puts "Please enter a number:"
        funds = gets.chomp!
    end
    return funds.to_i
end

# gets a username from user
def get_username()
    puts "Please enter a username:"
    return gets.chomp!
end

# Checks if the username entered is available
def is_valid_username?(username, profiles)
    if profiles.include?(username)
        puts "#{username} is already taken"
        return false
    end
    return true
end


# Saves a profile object to JSON file
def save_profile(profile, file)
    result = load_profiles(file)
    data = profile.profile_data
    result[profile.username] = data
    wFile = File.open("profiles.json", 'w')
    wFile.write(JSON.pretty_generate(result))
    wFile.close
end

# Turns JSON file of profiles into a hash
def load_profiles(file)
    read = File.open(file)
    string = read.read
    read.close
    hash = JSON.parse(string)
    return hash
end

# Load a singular profile to perform trades on
def load_profile(username, file)
    hash = load_profiles(file)
    if !hash.key?(username)
        raise ProfileDoesntExist.new("This profile does not exist")
    end
    profile = Profile.new(username)
    profile.add_starting_funds(hash[username]['starting_funds'])
    return profile
end




# Request user for IEX API key for querying stocks
def enter_key()
    puts "Please enter your IEX API key"
    return gets
end

def profile_menu(prompt)
    choices = ["Account Summary", "Investment Summary", "Trade", "Export Data", "Quit"]
    prompt.select("What would you like to do?", choices)
end

def profile_controller(prompt, profile)
    response = profile_menu(prompt)
    case response
    when "Account Summary"
        table = profile.profile_summary
        puts table.render(:ascii, alignments: [:left, :center])
    when "Trade"
        ticker_info(profile, prompt)
    end
end

# Checks if given ticker name is a tradeable stock
# True if stock is tradable, else false
def is_stock?(stock, key)
    begin
        result = Stock.new(stock, key)
    rescue Exception
        return false
    end
    return true
end

def ticker_info(profile, prompt)
    puts "What stock would you like to look at?"
    stock = gets.chomp.upcase
    until is_stock?(stock, profile.key) == true
        puts "We can not find this stock in the database, please enter another"
        stock = gets.chomp.upcase
    end
    ticker = Stock.new(stock, profile.key)
    choices = ["Stock Information", "Make Trade", "Get News", "Back"]
    response = prompt.select("What would you like to do with #{ticker.ticker}?", choices)
    case response
    when "Stock Information"
        get_stock_info(ticker, profile, prompt)
    when "Make Trade"
        trade_controller(ticker, profile, prompt)
    when "Get News"
        puts "TODOOOO"
    when "Back"
        profile_menu(prompt)
    end

end

def get_stock_info(stock, profile, prompt)
    table =  stock.stock_info()
    puts table.render(:ascii, alignments: [:left, :center])
    choices = ["Make Trade", "News", "Back"]
    input = prompt.select("What would you like to do?", choices)
    case input
    when "Back"
        profile_controller(prompt, profile)
    end
end

def trade_controller(ticker, profile, prompt)
    num_shares, price = num_shares(ticker, profile, prompt)
    profile.add_investments(ticker.ticker, num_shares, price)
    puts "Successfully purchased #{num_shares} shares of #{ticker.ticker} for $#{(num_shares * price).round(2)}"
    save_profile(profile, 'profiles.json')
    profile_controller(prompt, profile)
end

def num_shares(ticker, profile, prompt)
    options = ["Yes", "No"]
    puts "Acquiring up to date information..."
    ticker.update_quote()
    message = "#{ticker.ticker} is currently trading at $#{ticker.get_price}"
    puts message
    response = prompt.select("Would you like to purchase #{ticker.ticker}?", options)
    case response
    when "Yes"
        puts "How many shares would you like to purchase?"
        num_shares = gets.chomp!
        until num_shares.to_i.is_a?(Integer) and num_shares.to_i > 0
            puts "Please enter a whole number."
            ticker.update_quote()
            puts message
            num_shares = gets.chomp!
        end
        return [num_shares.to_i, ticker.get_price()]
    when "No"
        profile_controller(prompt, profile)
    end
end

def menu_director(input)
end



# controller for terminal app
def main()
    prompt = TTY::Prompt.new
    option = welcome_message(prompt)
    case option
    when "Sign-up"
        profile = create_profile('profiles.json')
        profile.update_available_funds(profile.starting_funds)
        save_profile(profile, 'profiles.json')
    when "Login"
        username = get_username()
        profile = load_profile(username, 'profiles.json')
        puts "TODO"
    when "Quit"
        puts "Thank you for using CB Finance"
        exit
    end
    puts "Please enter your public IEX key:"
    key = gets.chomp!
    profile.add_key(key)
    profile_controller(prompt, profile)

end
main()