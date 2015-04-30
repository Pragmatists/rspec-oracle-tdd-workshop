require "rubygems"
require "ruby-plsql-spec"
require "yaml"

database_config_file = File.expand_path(File.dirname(__FILE__)) + '/database.yml'
database_config = YAML.load(File.read(database_config_file))
database_config = {} unless database_config.is_a?(Hash)

def get_db_config
  @@database_config
end

def get_db_connections
  get_db_config.keys.map{|k| k.to_sym}
end

def connect_all(database_config)
  @@database_config = database_config
  database_config.each do |name, params|
    # change all keys to symbols
    name = name.to_sym
    symbol_params = Hash[*params.map{|k,v| [k.to_sym, v]}.flatten]

    unless ENV['ORACLE_CURRENT_SCHEMA'].nil?
      symbol_params[:schema] = ENV['ORACLE_CURRENT_SCHEMA'].to_s
    end
    plsql(name).connect! symbol_params
    plsql(name).connection.prefetch_rows = 1000
    #plsql(name).set_current_schema(symbol_params)

    # Set autocommit to false so that automatic commits after each statement are _not_ performed
    plsql(name).connection.autocommit = false
    # reduce network traffic in case of large resultsets
    plsql(name).connection.prefetch_rows = 10
    # log DBMS_OUTPUT to standard output
    if ENV['PLSQL_DBMS_OUTPUT']
      plsql(name).dbms_output_stream = STDOUT
    end

    # start code coverage collection
    if ENV['PLSQL_COVERAGE']
      PLSQL::Coverage.start(name)
    end
  end
end

connect_all(database_config)
