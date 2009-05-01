module ActiveSupport
  module Inflector
    
    if Module.method(:const_get).arity == 1   
      def constantize(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          module_with_constant = constant.ancestors.detect {|mod| mod.const_defined?(name)}
          constant = module_with_constant ? module_with_constant.const_get(name) : constant.const_missing(name)                    
        end
        constant
      end
    else
      def constantize(camel_cased_word) #:nodoc:
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          module_with_constant = constant.ancestors.detect {|mod| mod.const_defined?(name, false)}
          constant = module_with_constant ? module_with_constant.const_get(name, false) : constant.const_missing(name)          
        end
        constant
      end
    end
  end
end