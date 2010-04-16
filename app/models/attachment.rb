class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :attachment

  belongs_to_related :subject, :polymorphic => true

  validates_presence_of :subject

  mount_uploader :attachment, AttachmentUploader
end
