class TestMailer < ApplicationMailer
  before_action only: [:parameterized_mailer] do
    @thing = OpenStruct.new(id: params[:id], full_name: params[:name])
  end

  def parameterized_mailer
    mail(to: "joshmn@example.com", subject: "Test subject parameterized", html_body: "Test body parameterized")
  end

  def argument_mailer(id, name)
    @thing = OpenStruct.new(id: params[:id], full_name: params[:name])
    mail(to: "joshmn@example.com", subject: "Test subject argument", html_body: "Test body argument")
  end
end
