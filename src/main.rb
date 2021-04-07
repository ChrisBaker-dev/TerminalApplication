require_relative './profile.rb'
require 'csv'

# Welcoming message to the application
# Returns string login or sign-up depending on users choice
def welcome_message()
    options = "options: login, sign-up or quit"

    puts "-------------------------------------------------"
    puts "Thank you for using CB Finance Tools!"
    puts "Would you like to login or sign-up?"
    puts options

    while true
        answer = gets.chomp!.downcase
        if answer == "login" or answer == "sign-up" or answer == "quit"
            return answer
        else 
            puts "Please enter valid option"
            puts options
        end
    end
end

# Creates object Profile for new account
def create_profile()
    puts "-------------------------------------------------"
    puts "You have selected to create a new profile"
    puts "Please enter a username:"
    username = gets.chomp!
    puts "Please enter a starting amount of funds (ex. 50000):"
    funds = gets.chomp!
    profile = Profile.new(username, funds)
end


# Request user for IEX API key for querying stocks
def enter_key()
    puts "Please enter your IEX API key"
    return gets
end



# controller for terminal app
def main()
    option = welcome_message()
    case option
    when "sign-up"
        profile = create_profile()
    when "login"
        #profile = load_profile()
        puts "TODO"
    when "quit"
        puts "Thank you for using CB Finance"
        exit
    end
    puts "WE HERE"



end
main()