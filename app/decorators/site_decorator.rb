class SiteDecorator < ApplicationDecorator
  decorates :site

  def status_data
    counts = model.status_counts_by_type
    formatted_counts = Hash.new
    counts.each do |type, type_count|
      formatted_counts[type] = [type_count[:total], type_count[:available], type_count[:unavailable], type_count[:offline]].join('-')
    end
    "data-macs=""#{formatted_counts[:mac]}"" data-pcs=""#{formatted_counts[:pc]}"" data-thinclients=""#{formatted_counts[:tc]}"""
  end
  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by including this module:
  #     include Draper::LazyHelpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
end