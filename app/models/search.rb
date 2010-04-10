class Search
  include MongoMapper::Document

  key :terms,       String,   :required => true
  key :user_id,     ObjectId
  key :collections, Array
  timestamps!

  belongs_to :user

  def results
    @results ||= (collections.blank? ? %w(Lead, Contact, Account) : collections).map do |klass|
      klass = klass.constantize
      klass.scoped(:conditions => { :id => klass.search(terms).map(&:id) }).permitted_for(user).not_deleted
    end.inject { |sum,n| sum += n }
  end
end
