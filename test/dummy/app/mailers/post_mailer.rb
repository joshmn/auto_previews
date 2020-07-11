class PostMailer < ApplicationMailer
  previews_for model: 'Post',
               params: { post_id: :id }

  before_action do
    @post = Post.find_by(id: params[:post_id])
  end

  def created
    mail(to: "joshmn@example.com", subject: "Nice post #{@post.id}")
  end

  def deleted
    mail(to: "joshmn@example.com", subject: "Deleted post #{@post.id}")
  end
end
