require 'test_helper'

class AutoPreviews::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, AutoPreviews
  end

  test "mailer repsonds_to previews_for" do
    assert PostMailer.respond_to?(:previews_for)
  end

  test "mailer autopreview_configs is an array" do
    assert PostMailer.autopreview_configs.is_a?(Array)
  end

  # flaky because of loading. lame.
  # SEED=40541
  test "previews has preview methods" do
    require_relative 'dummy/lib/mailer_previews/post_mailer_preview'
    methods = PostMailerPreview.instance_methods(false)
    assert_equal methods, [:created, :deleted]
  end
end
