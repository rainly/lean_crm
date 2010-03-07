module SphinxIndex
  def self.included( base )
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      cattr_accessor :indexed_fields
      after_save :reindex
    end
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
      puts MongoSphinx::Indexer::XMLDocset.new(all(:fields => indexed_fields)).to_s
    end
  end

  module InstanceMethods
    def reindex
      Rake::Task['sphinx:index'].invoke
    end
  end
end
