# frozen_string_literal: true

module Google
  module AMP
    module Cache
      class Configuration
        attr_accessor :private_key, :amp_cache_domain

        def initialize
          @amp_cache_domain = 'cdn.ampproject.org'
        end
      end

      # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
      def self.configuration
        @configuration ||= Configuration.new
      end
      # rubocop:enable ThreadSafety/InstanceVariableInClassMethod

      def self.configure
        yield configuration
      end
    end
  end
end
