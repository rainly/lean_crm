class AttachmentsController < InheritedResources::Base

  skip_before_filter :log_viewed_item

  def show
    GridFS::GridStore.open(MongoMapper.database,
                           resource.attachment.url.gsub(/\/image\/show\//, ''), 'r') do |file|
      send_data(file.read, :filename => resource.attachment_filename) if file
    end
  end
end
