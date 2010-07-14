module TicketTechnology::Catalog
  class PerformerRank < Base
    class Parser
      include ParseHelper

      class PerformerRank
        include ParseHelper
      end
    end

    def self.all(parameters={})
      raise NotImplementedError
    end
  end
end
