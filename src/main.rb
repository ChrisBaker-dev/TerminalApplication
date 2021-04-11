require_relative './profile.rb'
require_relative './exceptions.rb'
require_relative './stock.rb'
require 'json'
require 'tty-prompt'
require 'tty-table'
require 'dotenv/load'


# Welcoming message to the application
# Returns string login or sign-up depending on users choice
def welcome_message(prompt)
    options = ["Login", "Sign-up", "Quit"]

    puts "-------------------------------------------------"
    puts "Thank you for using CB Finance Tools!"
    prompt.select("Would you like to Login or Sign-up?", options)
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
    profile.update_available_funds(funds)
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
        puts ProfileDoesntExist.new("This profile does not exist")
        return login_check()
    end
    profile = Profile.new(username)
    profile.add_starting_funds(hash[username]['starting_funds'])
    profile.load_investments(hash[username]["investments"])
    profile.update_available_funds(hash[username]['available_funds'])
    return profile
end


# Request user for IEX API key for querying stocks
def enter_key()
    puts "Please enter your IEX API key"
    return gets
end

# Displays top level menu and returns choice
def profile_menu(prompt)
    choices = ["Account Summary", "Investment Summary", "Trade", "Quit"]
    prompt.select("What would you like to do?", choices)
end

# Top level menu controller
def profile_controller(prompt, profile)
    response = profile_menu(prompt)
    case response
    when "Account Summary"
        update_stock_values(profile)
        profile.update_growth
        table = profile.profile_summary
        puts table.render(:ascii, alignments: [:left, :center])
        return profile_controller(prompt, profile)
    when "Trade"
        return ticker_info(profile, prompt)
    when "Investment Summary"
        begin
            update_stock_values(profile)
            table = profile.display_holdings()
            puts table.render(:ascii, alignments: [:left, :center])
            profile_controller(prompt, profile)
        rescue Exception
            puts "You have no investments at this time"
            return profile_controller(prompt, profile)
        end
    when "Quit"
        puts "Thank you for using CB Finance"
        exit
    end
end

# Updates the share price on stocks in profile
def update_stock_values(profile)
    stocks = profile.investments
    tickers = []
    stocks.each do |key, value|
        tickers << key
    end
    tickers.each do |ticker|
        value = Stock.new(ticker, profile.key)
        stocks[ticker][1] = value.get_price()
    end
    profile.load_investments(stocks)
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

# Requests user what stock they want and verifies if it exists
def verify_stock(profile)
    puts "What stock would you like to look at?"
    stock = gets.chomp.upcase
    until is_stock?(stock, profile.key) == true
        puts "We can not find this stock in the database, please enter another or 'quit'"
        stock = gets.chomp.upcase
        if stock.downcase == 'quit'
            return profile_controller(TTY::Prompt.new, profile)
        end
    end
    return stock
end

# Checks to make sure the user has enough money for purchase
def verify_funds_available(profile, shares, cost)
    available_funds = profile.available_funds
    total = shares * cost
    if available_funds < total
        return false
    end
    return true
end

# 
def ticker_info(profile, prompt)
    choices = ["Buy Stock", "Sell Stock", "Back"]
    response = prompt.select("What move would you like to make?", choices)
    case response

    when "Buy Stock"
        stock = verify_stock(profile)
        ticker = Stock.new(stock, profile.key)
        return purchase_controller(ticker, profile, prompt)
    when "Sell Stock"
        # Display current holdings
        begin

            table = profile.display_holdings
            puts table.render(:ascii, alignments: [:left, :center])
            stock = verify_stock(profile)
            ticker = Stock.new(stock, profile.key)
            return sell_controller(ticker, profile, prompt)
        rescue Exception
            puts "You do not have any stocks to sell"
            return profile_controller(prompt, profile)
        end
    when "Back"
        return profile_controller(prompt, profile)
    end

end

    # when "Stock Information"
    #     get_stock_info(ticker, profile, prompt)

# Currently not in use - will display news on stocks
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

# Purchases stock and updates profile accordingly
def purchase_controller(ticker, profile, prompt)
    action = "purchase"
    num_shares, price = num_shares(ticker, profile, prompt, action)
    if verify_funds_available(profile, num_shares, price) == false
        puts "Insufficient funds"
        return ticker_info(profile, prompt)
    else 
        profile.add_investments(ticker.ticker, num_shares, price)
        puts "Successfully purchased #{num_shares} shares of #{ticker.ticker} for $#{(num_shares * price).round(2)}"
        profile.update_available_funds(profile.available_funds - (num_shares * price).round(2))
        save_profile(profile, 'profiles.json')
        return profile_controller(prompt, profile)
    end
end

# Sells stock and updates profile accordingly
def sell_controller(ticker, profile, prompt)
    action = "sell"
    num_shares, price = num_shares(ticker, profile, prompt, action)
    if profile.get_stock_shares(ticker.ticker, num_shares) == false
        puts "You can not sell more shares than you own."
        num_shares, price = num_shares(ticker, profile, prompt, action)
    end
    puts "Successfully sold #{num_shares} shares of #{ticker.ticker} for $#{(num_shares * price).round(2)}"
    profile.update_available_funds(profile.available_funds + (num_shares * price).round(2))
    profile.remove_investments(ticker.ticker, num_shares)
    save_profile(profile, 'profiles.json')
    return profile_controller(prompt, profile)
end

def num_shares(ticker, profile, prompt, action)
    options = ["Yes", "No"]
    puts "Acquiring up to date information..."
    ticker.update_quote()
    message = "#{ticker.ticker} is currently trading at $#{ticker.get_price}"
    puts message
    response = prompt.select("Would you like to #{action} #{ticker.ticker}?", options)
    case response
    when "Yes"
        puts "How many shares would you like to #{action}?"
        num_shares = gets.chomp!
        until num_shares.to_i.is_a?(Integer) and num_shares.to_i > 0
            puts "Please enter a whole number."
            ticker.update_quote()
            puts message
            num_shares = gets.chomp!
        end
        return [num_shares.to_i, ticker.get_price()]
    when "No"
        return profile_controller(prompt, profile)
    end
end

def sell_shares(profile, prompt)
end

def menu_director(input)
end

# Verifies IEX API key is valid
# Returns false if not
def verify_iex_key(key)
    begin
        test = Stock.new("MSFT", key)
    rescue 
        return false
    end
    return true
end

# Controller for checking if login is successful
def login_check()
    username = get_username()
    if username == 'quit'
        handle_exit()
    end
    profile = load_profile(username, 'profiles.json')
    return profile
end

# Exit protocol for application
def handle_exit()
    puts "Thank you for using CB Finance"
    exit
end


# controller for terminal app
def main()
    prompt = TTY::Prompt.new
    option = welcome_message(prompt)
    case option
    when "Sign-up"
        profile = create_profile('profiles.json')
        profile.update_available_funds(profile.starting_funds)
        return save_profile(profile, 'profiles.json')
    when "Login"
        profile = login_check()
    when "Quit"
        return handle_exit()
    end
    puts "Please enter your public IEX key:"
    key = ENV['IEXKEY']
    puts "Verifying API Key..."
    until verify_iex_key(key) == true
        puts "Sorry, that key did not work, please enter a new key or enter 'quit':"
        key = gets.chomp!
        if key == 'quit'
            return handle_exit()
        end
        puts "Verifying API Key..."
    end
    profile.add_key(key)
    profile_controller(prompt, profile)
end

if ARGV.size == 0
    main()
end

if ARGV.include? "--help" and ARGV.size == 1
    puts "Welcome to the CB Finance Help Room"
    puts "To use this app, follow these instructions"
    puts "1) Direct your terminal to the src folder containing this application"
    puts "2) type ./install.sh - This will install all dependencies for my application"
    puts "Alternatively, view the README.md doc or navigate to my github for installation instructions https://github.com/ChrisBaker-dev/TerminalApplication"
    puts "3) View the README.md document for instructions on obtaining a API Key"
    puts "Or navigate to my github account at https://github.com/ChrisBaker-dev/TerminalApplication"
    puts "4)Once you have obtained your API Key, type [echo 'YOUR API KEY HERE' >> .env] in \nthe command line without the braces[]"
    puts "This will automate the software to make loading the application much more efficient"
    puts "\n\n"
    puts "COMMANDS:"
    puts "ruby main.rb --help"
    puts "ruby main.rb profile_name  => skips login screen if valid"
end