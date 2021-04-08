require_relative './profile.rb'
require_relative './exceptions.rb'
require 'json'


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



# controller for terminal app
def main()
    option = welcome_message()
    case option
    when "sign-up"
        profile = create_profile('profiles.json')
        profile.update_available_funds(profile.starting_funds)

        save_profile(profile, 'profiles.json')
    when "login"
        username = get_username
        profile = load_profile(username, 'profiles.json')
        puts "TODO"
    when "quit"
        puts "Thank you for using CB Finance"
        exit
    end
    puts "WE HERE"

end
main()