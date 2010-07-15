module TicketTechnology::Catalog
  class Configuration < Base
    MAP_ROOT = 'http://maps.seatics.com/'.freeze

    def self.map_url(venue)
      "#{MAP_ROOT}#{URI.escape(venue.map_location)}"
    end
  end
end
