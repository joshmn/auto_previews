module AutoPreviews
  module ActionMailerExtensions
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      # use an array so we can use only/except
      def previews_for(options = {})
        autopreview_configs << _normalized_previews_for_options(options)
      end

      def autopreview_configs
        @_autopreview_configs ||= []
      end

      private

      def _normalized_previews_for_options(options)
        unless options[:model] === false
          options[:model] ||= self.class.name.delete_suffix('Mailer')
          if options[:model].is_a?(Class)
            options[:model] = options[:model].to_s
          end
          options[:scope] ||= :all
        end
        options[:using] ||= :parameters
        options
      end
    end

  end
end
