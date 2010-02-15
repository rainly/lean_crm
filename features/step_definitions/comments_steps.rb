Given /^I fill in the comment form$/ do
  fill_in_comment_form
end

Then /^a comment should have been created$/ do
  assert_equal 1, Comment.count
end

module CommentsHelper
  def fill_in_comment_form( text = nil )
    fill_in 'comment_text', :with => text || 'a test comment'
  end
end

World(CommentsHelper)
