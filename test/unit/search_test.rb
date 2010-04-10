require 'test_helper.rb'

class SearchTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_key :terms, :user_id, :created_at, :updated_at, :collections
    should_require_key :terms
    should_belong_to :user
  end

  context 'Instance' do
    setup do
      @search = Search.make_unsaved
    end
  end
end
