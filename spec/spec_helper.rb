require_relative '../config/common_helper'

RSpec.configure do |config|
  config.before(:each) do
    get_db_connections.each do |name|
      plsql(name).savepoint "before_each"
    end
  end
  config.after(:each) do
    # Always perform rollback to savepoint after each test
    get_db_connections.each do |name|
      plsql(name).rollback_to "before_each"
    end
  end
  config.after(:all) do
    # Always perform rollback after each describe block
    get_db_connections.each do |name|
      plsql(name).rollback
    end
  end
end

# require all helper methods which are located in any helpers subdirectories
Dir[File.dirname(__FILE__) + '/**/helpers/*.rb'].each {|f| require f}

# require all factory modules which are located in any factories subdirectories
Dir[File.dirname(__FILE__) + '/**/factories/*.rb'].each {|f| require f}

# If necessary add source directory to load path where PL/SQL procedures are defined.
# It is not required if PL/SQL procedures are already loaded in test database in some other way.
# $:.push File.dirname(__FILE__) + '/../source'
