class PostMailer < ApplicationMailer
  previews_for model: 'Post',
               params: { post_id: :id },
               only: [:created]

  previews_for model: 'Post',
               params: { post_id: :id },
               only: [:deleted],
               using: :arguments

  before_action only: [:created] do
    @post = Post.find_by(id: params[:post_id])
  end

  def created
    mail(to: "joshmn@example.com", subject: "Nice post #{@post.id}")
  end

  def deleted(post_id)
    @post = Post.find_by(id: post_id)
    mail(to: "joshmn@example.com", subject: "Deleted post #{@post.id}")
  end
end
