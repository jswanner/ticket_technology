module TicketTechnology
  module FormatHelper
    # Formats keys for use in parsing responses and building query strings.
    def format_key(key, query=false)
      key = key.to_s
      key.upcase! if key == 'id'
      key.gsub!(/_id$/, '_ID')
      key.gsub!(/_url$/, '_URL')
      key = key.camelize(!query ? :upper : :lower) unless key == 'int'
      key
    end

    # Formats query keys for use in a query string.
    def format_query_key(key)
      format_key(key, true)
    end

    # Formats and escapes query values for use in a query string.
    def format_query_value(value)
      value = case value
        when Time, Date
          value.to_s(:db)
        else
          value.to_s
      end

      CGI.escape(value)
    end
  end
end
