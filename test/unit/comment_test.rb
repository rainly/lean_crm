require 'test_helper.rb'

class CommentTest < ActiveSupport::TestCase
  context 'Instance' do
    setup do
      @comment = Comment.make_unsaved(:made_offer_to_erich)
    end

    should 'alias text to name' do
      assert @comment.name == @comment.text
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
