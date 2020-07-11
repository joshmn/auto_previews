module AutoPreviews
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:action_mailer) do
      include ::AutoPreviews::ActionMailerExtensions
      ::ActionMailer::Preview.include AutoPreviews::PreviewExtensions
    end
  end
end
