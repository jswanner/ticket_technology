require 'cgi'
require 'active_support/core_ext'
require 'patron'
require 'sax-machine'

module TicketTechnology
  ROOT = 'xmlfeed.eventprocess.com'.freeze
  CATALOG = "https://#{ROOT}/TicketsXml.asmx".freeze

  Error = Class.new(StandardError)
  AuthorizationError = Class.new(Error)
  ParameterError = Class.new(Error)
  NetworkError = Class.new(Error)

  mattr_accessor :user_name
  mattr_accessor :password
  mattr_accessor :domain_name

  autoload :Base,              'ticket_technology/base'
  autoload :FormatHelper,      'ticket_technology/format_helper'
  autoload :ParseHelper,       'ticket_technology/parse_helper'

  module Catalog
    autoload :Base,            'ticket_technology/catalog/base'
    autoload :Category,        'ticket_technology/catalog/category'
    autoload :Configuration,   'ticket_technology/catalog/configuration'
    autoload :Event,           'ticket_technology/catalog/event'
    autoload :Performance,     'ticket_technology/catalog/performance'
    autoload :Performer,       'ticket_technology/catalog/performer'
    autoload :PerformerRank,   'ticket_technology/catalog/performer_rank'
    autoload :Ticket,          'ticket_technology/catalog/ticket'
    autoload :Venue,           'ticket_technology/catalog/venue'
  end
end
