module SphinxIndex
  def self.included( base )
    base.extend(ClassMethods)
    base.cattr_accessor :indexed_fields
  end

  module ClassMethods
    def sphinx_index( *cols )
      self.class_eval do
        fulltext_index(*cols)
        indexed_fields = "_sphinx_id, #{cols.join(',')}"
      end
    end

    def search( query )
      by_fulltext_index(query).each { |p| p }
    end

    def xml_for_sphinx_pipe
      File.open("#{Rails.root}/tmp/#{self.to_s.downcase.pluralize}.xml", 'w+') do |f|
        f.write MongoSphinx::Indexer::XMLDocset.new(all(:fields => indexed_fields)).to_s
      end
    end
  end
end
