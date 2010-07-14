module TicketTechnology::Catalog
  class Performer < Base
    class Parser
      include ParseHelper

      class Performer
        include ParseHelper

        element :headliner_id, :as => :id
        element :category_id
        element :event_headliner_name, :as => :name
      end

      elements :table, :as => :performers, :class => Performer
    end

    ##
    # NOTE: not sure if we want to get performers by category id as before,
    # or get all performs.  both are available
    #
    get :get_headliners_in_category, :as => :fetch do
      parameter :category_id
      parameter :b_verbose, :as => :verbose, :default => true
    end

    get :get_headliner_info, :as => :fetch_info do
      parameter :headliner_id
    end

    def self.all(parameters={})
      fetch(parameters).performers
    end
  end
end
