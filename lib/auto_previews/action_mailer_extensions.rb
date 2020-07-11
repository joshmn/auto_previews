module AutoPreviews
  module ActionMailerExtensions
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      def previews_for(options = {})
        @_autopreview_config = _normalized_previews_for_options(options)
      end

      def autopreview_config
        @_autopreview_config ||= {}
      end

      private

      def _normalized_previews_for_options(options)
        options
      end
    end

  end
end
