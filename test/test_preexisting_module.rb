require File.dirname(__FILE__) + '/test_helper.rb'

module Preexisting
  class Person < ActiveRecord::Base
  end
  
  Foo = "foo" # just to ensure it doesn't do anything stupid with non-classes
  
  class NotAciveRecord; end # similarly, this class should be ignored
end

module AnotherPre
end

class TestPreexistingModule < ActiveSupport::TestCase

  def setup
    create_fixtures :people
  end
  
  def test_update_existing_classes
    assert_equal(ActiveRecord::Base.configurations['production'], Preexisting::Person.connection.instance_variable_get(:@config))
    Preexisting.establish_connection :contact_repo
    assert_equal(ActiveRecord::Base.configurations['contact_repo'], Preexisting::Person.connection.instance_variable_get(:@config))
  end
  
  # Rails can dynamically load classes when requested
  def test_update_on_load
    AnotherPre.establish_connection :contact_repo
    AnotherPre.class_eval <<-EOS
      class Person < ActiveRecord::Base
        def tester; end
      end
    EOS
    assert(AnotherPre::Person.instance_methods.include?("tester"), "AnotherPre::Person should include #tester method")
    assert_equal("AnotherPre::Person", AnotherPre::Person.name)
    assert_equal(ActiveRecord::Base.configurations['contact_repo'], AnotherPre::Person.connection.instance_variable_get(:@config))
  end
end
