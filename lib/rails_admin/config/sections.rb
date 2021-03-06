require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/sections/create'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/sections/update'
require 'rails_admin/config/sections/export'
require 'rails_admin/config/sections/show'

module RailsAdmin
  module Config
    # Sections describe different views in the RailsAdmin engine. Configurable sections are
    # list and navigation.
    #
    # Each section's class object can store generic configuration about that section (such as the
    # number of visible tabs in the main navigation), while the instances (accessed via model
    # configuration objects) store model specific configuration (such as the visibility of the
    # model).
    module Sections
      def self.included(klass)
        # Register accessors for all the sections in this namespace
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase.to_sym
          klass.send(:define_method, name) do |&block|
            @sections = {} unless @sections
            unless @sections[name]
              @sections[name] = section.new(self)
            end
            @sections[name].instance_eval &block if block
            @sections[name]
          end
        end
      end
    end
  end
end
