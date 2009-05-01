module MagicMultiConnections


  module ActiveRecordConnectionMethods

    def self.set_connection(mmc_module, ar_class)
      unless mmc_module.connection_klass     # No connection has been established yet.
        ar_class.establish_connection mmc_module.connection_spec
        mmc_module.connection_klass = ar_class
      else
        ar_class.instance_eval <<-CODE
        def retrieve_connection
          connection_handler.retrieve_connection(#{mmc_module.connection_klass.name})
        end
        CODE
      end

      
    end

    module ClassMethods
      attr_accessor :primary_connection_klass

      # The class method here changes to use the parent modules
      # connection class.  We do this to preserve connection.
      def retrieve_connection
        connection_handler.retrieve_connection(primary_connection_klass)
      end
    end

  end

end