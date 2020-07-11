# AutoPreviews

I got tired of writing `ActionMailer::Preview` classes. So I let Ruby write it for me.

## Usage

In your mailer class, define some options:

```ruby
class PostMailer < ApplicationMailer
  previews_for model: 'Post', # otherwise automatically infered based on class.name.delete_suffix('Mailer')
               params: { post_id: :id },
               only: [:created]

  previews_for model: 'Post',
               params: { post_id: :id },
               only: [:deleted],
               scope: :with_deleted,
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
```

In your previewer class, just call `auto_preview!`

```ruby 
class PostMailerPreview < ActionMailer::Preview 
  auto_preview! 
end 
```

`auto_preview!` will do some metaprogramming to create your mailer previews, like so:

```ruby 
  post = Post.first 
  params_to_send_to_mailer = {}
  params_given = { post_id: :id }
  params_given.each do |mailer_key, model_method| 
    params_to_send_to_mailer[mailer_key] = post.public_send(model_method) 
  end   
  PostMailer.with(params_to_send_to_mailer).created # or `*params_to_send_to_mailer.values` if `using: :arguments`
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

## Options

By default, the `previews_for` will define mailer preview methods for `class.instance_methods(false)`.

* `model`: the model you want to use for the record lookup; defaults to `self.class.name.delete_suffix('Mailer')`; if 
`false` is passed, no model will be used
* `params`: a hash of `mailer_method_name: :model_method_name`; used to map values to the mailer from the model 
* `using`: the type of mailer to use; defaults to using `ActionMailer::Parameterized`
* `only`: the methods to only use the given `previews_for` on; defaults to `[]`
* `except`: the methods to not use the given `previews_for` on; defaults to `[]`
* `scope`: scope to use on the model; defaults to `:all`

## Usage without a model 

Just pass `model: false` and define some sort of values to pass in the `params`:

Passing a proc will `call`; passing a symbol will call the given method on the mailer preview class if it is defined, otherwise it will be sent to your mailer preview as the symbol.

```ruby 
class OneOffMailer < ApplicationMailer 
  previews_for model: false,
               params: {
                 subject: -> :random_subject,
                 body: -> { FFaker::CheesyLingo.paragraph },
               },
end 
```

## Roadmap 

* More options
* Better extensibility
* Better record lookup 
* Better serialization of mailer params 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
