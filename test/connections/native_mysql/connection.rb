print "Using native MySQL\n"
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

db_connection_options = {
  :adapter  => "mysql",
  :encoding => "utf8",
  :database => 'magic_multi_connections_unittest',
  :username => "ruby",
  :password => "j04n43nry"
}

db_extra_connection_options = {
  :adapter  => "mysql",
  :encoding => "utf8",
  :database => 'magic_multi_connections_extra_unittest',
  :username => "ruby",
  :password => "j04n43nry"
}


ActiveRecord::Base.configurations = { 'production' => db_connection_options, 'contact_repo' => db_extra_connection_options }
ActiveRecord::Base.establish_connection(:production)
