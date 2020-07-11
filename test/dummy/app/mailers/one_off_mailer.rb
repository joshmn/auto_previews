class OneOffMailer < ApplicationMailer
  previews_for model: false,
               params: {
                   subject: -> { SecureRandom.hex },
                   body: "You're pretty good."
               },
               only: [:alert]

  previews_for model: false,
               params: {
                   subject: -> { SecureRandom.hex },
                   body: :rando
               },
               only: [:digest],
               using: :arguments

  before_action only: [:alert] do
    @subject = params[:subject]
    @body = params[:body]
  end

  def alert
    mail(to: "joshmn@example.com", subject: @subject)
  end

  def digest(subject, body)
    @subject = subject
    @body = body
    mail(to: "joshmn@example.com", subject: @subject)
  end
end
