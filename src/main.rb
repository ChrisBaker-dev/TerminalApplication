require_relative './profile.rb'


# controller for terminal app
def main()
    jerry = Profile.new('Jerry')
    puts jerry.username



end
main()