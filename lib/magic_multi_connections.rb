$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined?(ActiveSupport) && defined?(ActiveRecord)
  begin
    require 'active_support'  
    require 'active_record'  
  rescue LoadError
    require 'rubygems'
    require 'active_support'
    require 'active_record'  
  end
end

# check for Rails 2.2.X upto Rails 3 to fix constantize
require 'active_support/version'
if ActiveSupport::VERSION::MAJOR == 2 && ActiveSupport::VERSION::MINOR >= 2
  require 'fix_active_support/inflector_constantize_fix'
end

module MagicMultiConnection
  def self.using_connection_pool?
    return @using_connection_pool unless @using_connection_pool.nil?

    require 'active_record/version'
#    puts "AR: " + ActiveRecord::VERSION::STRING
    @using_connection_pool = (ActiveRecord::VERSION::MAJOR > 2 || (ActiveRecord::VERSION::MAJOR == 2 && ActiveRecord::VERSION::MINOR >= 2))
  end
end

#puts "MagicMultiConnection.using_connection_pool? > #{MagicMultiConnection.using_connection_pool?}"

require 'magic_multi_connections/version'
require 'magic_multi_connections/connected'
require 'magic_multi_connections/module'
if MagicMultiConnection.using_connection_pool?
  require 'magic_multi_connections/ar_connection_methods'
else
  require 'ext_active_record/connection_specification'
end
require 'ext_active_record/association_extensions'

