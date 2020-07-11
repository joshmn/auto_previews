# AutoPreviews

I got tired of writing `ActionMailer::Preview` classes. So I let Ruby write it for me.

## Usage

In your mailer class, define some options:

```ruby
class PostMailer < ApplicationMailer 
  previews_for model: 'Post',
               params: { post_id: :id }
  
  before_action do 
    @post = Post.includes(:user).find(params[:post_id])
  end
  
  def created 
    mail(to: @post.user.email, subject: "New post created")
  end 

  def deleted  
    mail(to: @post.user.email, subject: "Post #{@post.id} deleted.")
  end 
end 
```

In your previewer class, just call `auto_preview!`

```ruby 
class PostMailerPreview < ActionMailer::Preview 
  auto_preview! 
end 
```

`auto_preview!` will do some lazy metaprogramming to create your mailer previews, like so:

```ruby 
  post = Post.first 
  params_to_send_to_mailer = {}
  params_given = { post_id: :id }
  params_given.each do |mailer_key, model_method| 
    params_to_send_to_mailer[mailer_key] = post.public_send(model_method) 
  end   
  PostMailer.with(params_to_send_to_mailer).created 
```

## Installation

1. Add this line to your application's Gemfile:

```ruby
gem 'auto_previews'
```

2. And then execute:
```bash
$ bundle
```

3. Restart your Rails server 
 
4. Implement 

5. Enjoy! 

## Roadmap 

* Support argument mailers 
* More options 
* Better extensibility 
* Better record lookup 
* Better serialization of mailer params 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
