module MongoMapper
  module Mixins
    module Indexer
      module ClassMethods
        # Searches for an object of this model class (e.g. Post, Comment) and
        # the requested query string. The query string may contain any query 
        # provided by Sphinx.
        #
        # Call MongoMapper::Document.by_fulltext_index() to query
        # without reducing to a single class type.
        #
        # Parameters:
        #
        # [query] Query string like "foo @title bar"
        # [options] Additional options to set
        #
        # Options:
        #
        # [:match_mode] Optional Riddle match mode (defaults to :extended)
        # [:limit] Optional Riddle limit (Riddle default)
        # [:max_matches] Optional Riddle max_matches (Riddle default)
        # [:sort_by] Optional Riddle sort order (also sets sort_mode to :extended)
        # [:raw] Flag to return only IDs and do not lookup objects (defaults to false)

        def by_fulltext_index(query, options = {})
          if self == Document
            client = Riddle::Client.new
          else
            client = Riddle::Client.new(fulltext_opts[:server],
                     fulltext_opts[:port])

            query = query + " @classname #{self}"
          end

          client.match_mode = options[:match_mode] || :extended2

          if (limit = options[:limit])
            client.limit = limit
          end

          if (max_matches = options[:max_matches])
            client.max_matches = max_matches
          end

          if (sort_by = options[:sort_by])
            client.sort_mode = :extended
            client.sort_by = sort_by
          end
          
          if (filter = options[:with])
            client.filters = options[:with].collect{ |attrib, value|
              Riddle::Client::Filter.new attrib.to_s, value
            }
          end
          
          
          if (page_size = options[:page_size] || 20)
            page_size = 20 if (page_size.to_i == 0) # Justin Case
            client.limit = page_size
          end
          
          if (page = options[:page] || 1)
            page = 1 if (page.to_i == 0) # Justin Case
            client.offset = (page-1) * client.limit
          end

          result = client.query(query)

          #TODO
          if result and result[:total_found] and result[:total_found] > 0 and (matches = result[:matches])
            classname = nil
            ids = matches.collect do |row|
              classname = MongoSphinx::MultiAttribute.decode(row[:attributes]['csphinx-class'])
              row[:doc]
              # (classname + '-' + row[:doc].to_s) rescue nil
            end.compact

            return ids if options[:raw]
            query_opts = {:_sphinx_id => ids}
            options[:select] and query_opts[:select] = options[:select]
            documents = Object.const_get(classname).all(query_opts).sort_by{|x| ids.index(x._sphinx_id)}
            return MongoSphinx::SearchResults.new(result, documents, page, page_size)
          else
            return MongoSphinx::SearchResults.new(result, [], page, page_size)
          end
        end
      end
    end
  end
end
