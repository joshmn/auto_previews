module AutoPreviews
  module ActionMailerExtensions
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      def previews_for(options = {})
        autopreview_configs << _normalized_previews_for_options(options)
      end

      def autopreview_configs
        @_autopreview_configs ||= []
      end

      private

      # todo
      def _normalized_previews_for_options(options)
        options
      end
    end

  end
end
