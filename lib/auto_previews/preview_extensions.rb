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
            model = setup_model(autopreview_config[:model])
            scoped_collection = setup_scope(model, autopreview_config)
            finder = record_finder(scoped_collection, autopreview_config)
            record_proc, preview_params = finder[0], finder[1]
            define_method(m) do
              mailer_params = {}
              record = record_proc.call
              if record.nil?
                raise ActiveRecord::RecordNotFound, "Cannot find a record. Should be a type of `#{model}`. Create one?"
              end
              preview_params.each do |k,v|
                mailer_params[k] = record.public_send(v)
              end
              if autopreview_config[:using] == :arguments
                mailer_class.public_send(m, *mailer_params.values)
              else
                mailer_class.with(mailer_params).public_send(m)
              end
            end
          end
        end
      end

      private

      def setup_model(model_class)
        return false if model_class === false
        model = model_class.safe_constantize || model_class.to_s.delete_suffix('MailerPreview').safe_constantize
        if model.nil?
          raise ArgumentError, "unable to infer model from `#{model_class}`."
        end
        model
      end

      def setup_scope(model, config)
        return model if config[:model] === false
        scope = config[:scope]
        scoped_collection = model
        if scope.is_a?(Proc)
          scoped_collection = scoped_collection.instance_exec(&scope)
        elsif scope.is_a?(Symbol)
          scoped_collection = scoped_collection.send(scope)
        else
          raise ArgumentError, "invalid scope for #{model} `#{scope.inspect}`"
        end
        scoped_collection
      end

      # I hate this. So hacky.
      def record_finder(collection, config)
        if config[:model] === false
          struct = OpenStruct.new
          config[:params].each do |k,v|
            struct[k] = v
            config[:params][k] = k
          end
          return [-> { struct }, config[:params]]
        end
        [-> { collection.first }, config[:params]]
      end
    end
  end
end
