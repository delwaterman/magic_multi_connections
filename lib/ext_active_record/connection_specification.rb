module ActiveRecord
  class Base

    class << self

      if MagicMultiConnection.using_connection_pool?
        def retrieve_connection
          if self.parent_module.ancestors.include?(MagicMultiConnection::Connected)
            # Part of the MMC namespace so use the parent modules connection klass
            conn_klass = parent_module.get_connection_klass(self)
            connection_handler.retrieve_connection(conn_klass)
          else
            # Normal AR, use standard method
            connection_handler.retrieve_connection(self)
          end
        end
      else
        def active_connection_name #:nodoc:
          @active_connection_name ||=
                  if active_connections[name] || @@defined_connections[name]
                    name
                  elsif self == ActiveRecord::Base
                    nil
                  elsif self.parent_module.ancestors.include?(MagicMultiConnection::Connected)
                    self.parent_module.establish_connection_on self
                    self.active_connection_name
                  else
                    superclass.active_connection_name
                  end
        end
      end


    end


  end
end
