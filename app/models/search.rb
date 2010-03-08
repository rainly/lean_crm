class Search
  include MongoMapper::Document

  key :terms,   String,   :required => true
  key :user_id, ObjectId
  timestamps!

  belongs_to :user

  def results
    @results ||= (Lead.scoped(:conditions => { :id => Lead.search(terms).map(&:id) }).permitted_for(user).not_deleted +
      Contact.scoped(:conditions => { :id => Contact.search(terms).map(&:id) }).permitted_for(user).not_deleted +
      Account.scoped(:conditions => { :id => Account.search(terms).map(&:id) }).permitted_for(user).not_deleted)
  end
end
