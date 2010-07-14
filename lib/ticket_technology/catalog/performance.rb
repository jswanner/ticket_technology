module TicketTechnology::Catalog
  class Performance < Base
    class Parser
      include ParseHelper

      class Performer
        include ParseHelper
      end
    end

    def self.all(parameters={})
      raise NotImplementedError
    end
  end
end
