require_relative './profile.rb'

# Welcoming message to the application
# Returns string login or sign-up depending on users choice
def welcome_message()
    puts "-------------------------------------------------"
    puts "Thank you for using CB Finance Tools!"
    puts "Would you like to login or sign-up?"
    while true
        answer = gets.chomp!.downcase
        puts answer
        if answer == "login" or answer == "sign-up"
            puts "WE HERE"
            return answer
        else 
            puts "Please enter 'login' or sign-up'"
        end
    end
end

# controller for terminal appÿ
def main()
    welcome_message()



end
main()