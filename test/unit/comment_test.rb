require 'test_helper.rb'

class CommentTest < ActiveSupport::TestCase
  context 'Instance' do
    setup do
      @comment = Comment.make_unsaved(:made_offer_to_erich)
    end

    should 'return first 60 characters of text for name' do
      assert_equal "#{@comment.text[0..30]}...", @comment.name
    end

    should 'be valid with all required attributes' do
      assert @comment.valid?
    end

    should 'not be valid without user' do
      @comment.user_id = nil
      assert !@comment.valid?
      assert @comment.errors.on(:user_id)
    end

    should 'not be valid without commentable' do
      @comment.commentable = nil
      assert !@comment.valid?
      assert @comment.errors.on(:commentable)
    end
  end
end
