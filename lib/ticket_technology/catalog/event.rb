module TicketTechnology::Catalog
  class Event < Base
    class Parser
      include ParseHelper

      class Event
        include ParseHelper

        element :event_id, :as => :id
        element :event, :as => :name
        element :date
        element :time
        element :category_id
        element :headliner_id, :as => :performer_id
        element :venue_id
      end

      elements :table, :as => :events, :class => Event
    end

    get :get_events, :as => :fetch do
      parameter :b_with_tickets, :as => :with_tickets, :default => false
      parameter :b_verbose, :as => :verbose, :default => true
    end

    get :get_events_at_venue, :as => :fetch_by_venue do
      parameter :venue_id
      parameter :b_with_tickets, :as => :with_tickets, :default => false
      parameter :b_verbose, :as => :verbose, :default => true
    end

    get :get_event_info, :as => :fetch_info do
      parameter :event_id
    end

    def self.all(parameters={})
      fetch(parameters).events
    end

    def self.by_venue(venue_id, parameters={})
      parameters[:venue_id] = venue_id
      fetch_by_venue(parameters).events
    end
  end
end
