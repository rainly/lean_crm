class Attachment
  include MongoMapper::Document

  key :subject_id,    ObjectId
  key :subject_type,  String
  key :attachment,    String

  belongs_to :subject, :polymorphic => true

  validates_presence_of :subject

  mount_uploader :attachment, AttachmentUploader
end
