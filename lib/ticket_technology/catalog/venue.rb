module TicketTechnology::Catalog
  class Venue < Base
    class Parser
      include ParseHelper

      class Venue
        include ParseHelper

        element :venue_id, :as => :id
        element :venue, :as => :name
        element :venue_city, :as => :locality
        element :venue_state, :as => :region
        element :map_location
      end

      elements :table, :as => :venues, :class => Venue
    end

    get :get_venues, :as => :fetch do
      parameter :b_verbose, :as => :verbose, :default => false
    end

    get :get_venue_info, :as => :fetch_info do
      parameter :venue_id
    end

    def self.all(parameters={:verbose => true})
      fetch(parameters).venues
    end
  end
end
