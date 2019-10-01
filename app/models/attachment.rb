class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true, optional: false

  mount_uploader :file, FileUploader
end
