module TicketTechnology::Catalog
  class Ticket < Base
    class Parser
      include ParseHelper

      class Ticket
        include ParseHelper
      end
    end

    def self.all(parameters={})
      raise NotImplementedError
    end
  end
end
