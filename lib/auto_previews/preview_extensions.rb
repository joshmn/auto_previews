module AutoPreviews
  module PreviewExtensions
    extend ActiveSupport::Concern

    included do #
      extend ClassMethods
    end

    module ClassMethods
      def auto_preview!
        mailer_class = self.name.delete_suffix("Preview").constantize
        mailer_class.instance_methods(false).each do |m|
          define_method(m) do
            model = (mailer_class.autopreview_config[:model] || self.class.name.delete_suffix("MailerPreview")).constantize
            _params = {}
            mailer_class.autopreview_config[:params].each do |k,v|
              record = model.first
              if record.nil?
                raise ActiveRecord::RecordNotFound, "Cannot find a record. Should be a type of `#{model}`. Create one?"
              end
              _params[k] = record.public_send(v)
            end
            mailer_class.with(_params).public_send(m)
          end
        end
      end
    end
  end
end
