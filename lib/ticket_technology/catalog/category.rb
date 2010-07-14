module TicketTechnology::Catalog
  class Category < Base
    class Parser
      include ParseHelper

      class Category
        include ParseHelper

        element :category_id, :as => :id
        element :category_type, :as => :type
        element :category, :as => :name
      end

      elements :table, :as => :categories, :class => Category
    end

    get :get_categories, :as => :fetch do
      parameter :b_verbose, :as => :verbose, :default => false
    end
    get :get_category_info, :as => :fetch_info do
      parameter :category_id
    end

    def self.all(parameters={:verbose => true})
      fetch(parameters).categories
    end
  end
end
