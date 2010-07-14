module TicketTechnology
  module ParseHelper
    def self.included(base)
      base.class_eval do
        include SAXMachine
      end

      base.extend(ClassMethods)
    end

    module ClassMethods
      include FormatHelper

      def element(name, options={})
        options.reverse_merge!(:as => name)
        name = format_key(name)
        super(name, options)
      end

      def elements(name, options={})
        options.reverse_merge!(:as => name)
        name = format_key(name)
        super(name, options)
      end
    end
  end
end
