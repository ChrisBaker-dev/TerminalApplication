require 'test/unit'
require_relative '../profile.rb'

class ProfileTest < Test::Unit::TestCase

    def setup()
        @profile1 = Profile.new('John', 50000)
    end

    def test_new_instance()
        assert_not_nil(@profile1)
    end

    def test_available_funds()
        assert_equal(50000, @profile1.available_funds)
    end

    def test_update_description()
        @profile1.update_description("test")
        assert_equal('test', @profile1.description)
    end

    

end