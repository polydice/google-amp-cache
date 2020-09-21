# frozen_string_literal: true

module Google
  module AMP
    module Cache
      class PrivateKeyNotFound < StandardError
        def initialize(msg = 'Please ensure private key is properly configured to sign AMP update-cache requests')
          super(msg)
        end
      end

      class ForbiddenError < StandardError
        def initialize(msg = 'Request Forbidden', response = nil)
          @response = response
          super(msg)
        end
      end
    end
  end
end
