module TicketTechnology::Catalog
  class Base < TicketTechnology::Base
    service :catalog
  end

  ParseHelper = TicketTechnology::ParseHelper
end
