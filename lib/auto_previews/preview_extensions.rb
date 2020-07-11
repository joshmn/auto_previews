module AutoPreviews
  module PreviewExtensions
    extend ActiveSupport::Concern

    included do #
      extend ClassMethods
    end

    module ClassMethods
      def auto_preview!(klass = nil)
        mailer_class = (klass || self.name.delete_suffix("Preview")).constantize
        mailer_class.autopreview_configs.each do |autopreview_config|
          methods_to_define = if autopreview_config[:except]
                                mailer_class.instance_methods(false) - Array(autopreview_config[:except])
                              elsif autopreview_config[:only]
                                Array(autopreview_config[:only])
                              else
                                mailer_class.instance_methods(false)
                              end
          methods_to_define.each do |m|
            define_method(m) do
              model = (autopreview_config[:model] || self.class.name.delete_suffix("MailerPreview")).constantize
              _params = {}
              autopreview_config[:params].each do |k,v|
                record = model.first
                if record.nil?
                  raise ActiveRecord::RecordNotFound, "Cannot find a record. Should be a type of `#{model}`. Create one?"
                end
                _params[k] = record.public_send(v)
              end
              if autopreview_config[:using] == :arguments
                mailer_class.public_send(m, _params.values)
              else
                mailer_class.with(_params).public_send(m)
              end
            end
          end
        end
      end
    end
  end
end
