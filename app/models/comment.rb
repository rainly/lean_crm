class Comment
  include MongoMapper::Document

  key :user_id,           ObjectId, :required => true, :index => true
  key :commentable_id,    ObjectId, :required => true, :index => true
  key :commentable_type,  String, :required => true, :index => true
  key :text,              String
  timestamps!

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end
