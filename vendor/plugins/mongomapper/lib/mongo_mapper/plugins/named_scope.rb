module MongoMapper
  module Plugins
    module NamedScope
      def self.configure( base )
        base.named_scope :scoped, lambda { |scope| scope }
      end

      module ClassMethods
        def scopes
          read_inheritable_attribute(:scopes) || write_inheritable_attribute(:scopes, {})
        end

        def current_scoped_methods
          scoped_methods.last
        end

        def scoped_methods
          Thread.current[:"#{self}_scoped_methods"] ||= self.default_scoping.dup
        end

        def default_scope(options={})
          self.default_scoping << { :find => options, :create => options[:conditions].is_a?(Hash) ? options[:conditions] : {} }
        end

        def default_scoping
          @default_scoping || []
        end

        def named_scope(name, options = {}, &block)
          name = name.to_sym
          scopes[name] = lambda do |parent_scope, *args|
            Scope.new(parent_scope, case options
              when Hash
                options
              when Proc
                options.call(*args)
            end, &block)
          end
          (class << self; self end).instance_eval do
            define_method name do |*args|
              scopes[name].call(self, *args)
            end
          end
        end

        # Retrieve the scope for the given method and optional key.
        def scope(method, key = nil) #:nodoc:
          if current_scoped_methods && (scope = current_scoped_methods[method])
            key ? scope[key] : scope
          end
        end

        def set_readonly_option!(options) #:nodoc:
          # Inherit :readonly from finder scope if set.  Otherwise,
          # if :joins is not blank then :readonly defaults to true.
          unless options.has_key?(:readonly)
            if scoped_readonly = scope(:find, :readonly)
              options[:readonly] = scoped_readonly
            elsif !options[:joins].blank? && !options[:select]
              options[:readonly] = true
            end
          end
        end

        # Merges conditions so that the result is a valid +condition+
        def merge_conditions(*conditions)
          segments = []

          conditions.each do |condition|
            unless condition.blank?
              sql = sanitize_sql(condition)
              segments << sql unless sql.blank?
            end
          end

          "(#{segments.join(') AND (')})" unless segments.empty?
        end
        VALID_FIND_OPTIONS = [ :conditions, :include, :joins, :limit, :offset,
                               :order, :select, :readonly, :group, :having, :from, :lock ]

        def with_scope(method_scoping = {}, action = :merge, &block)
          method_scoping = method_scoping.method_scoping if method_scoping.respond_to?(:method_scoping)

          # Dup first and second level of hash (method and params).
          method_scoping = method_scoping.inject({}) do |hash, (method, params)|
            hash[method] = (params == true) ? params : params.dup
            hash
          end

          method_scoping.assert_valid_keys([ :find, :create ])

          if f = method_scoping[:find]
            f.assert_valid_keys(VALID_FIND_OPTIONS)
            set_readonly_option! f
          end

          # Merge scopings
          if [:merge, :reverse_merge].include?(action) && current_scoped_methods
            method_scoping = current_scoped_methods.inject(method_scoping) do |hash, (method, params)|
              case hash[method]
                when Hash
                  if method == :find
                    (hash[method].keys + params.keys).uniq.each do |key|
                      merge = hash[method][key] && params[key] # merge if both scopes have the same key
                      if key == :conditions && merge
                        if params[key].is_a?(Hash) && hash[method][key].is_a?(Hash)
                          #hash[method][key] = merge_conditions(hash[method][key].deep_merge(params[key]))
                          hash[method][key] = hash[method][key].deep_merge(params[key])
                        else
                          hash[method][key] = merge_conditions(params[key], hash[method][key])
                        end
                      else
                        hash[method][key] = hash[method][key] || params[key]
                      end
                    end
                  else
                    if action == :reverse_merge
                      hash[method] = hash[method].merge(params)
                    else
                      hash[method] = params.merge(hash[method])
                    end
                  end
                else
                  hash[method] = params
              end
              hash
            end
          end

          self.scoped_methods << method_scoping
          begin
            yield
          ensure
            self.scoped_methods.pop
          end
        end
      end

      class Scope
        attr_reader :proxy_scope, :proxy_options, :current_scoped_methods_when_defined
        NON_DELEGATE_METHODS = %w(nil? send object_id class extend find size count sum average maximum minimum paginate first last empty? any? respond_to?).to_set
        [].methods.each do |m|
          unless m =~ /^__/ || NON_DELEGATE_METHODS.include?(m.to_s)
            delegate m, :to => :proxy_found
          end
        end

        delegate :scopes, :with_scope, :scoped_methods, :to => :proxy_scope

        def initialize(proxy_scope, options, &block)
          options ||= {}
          [options[:extend]].flatten.each { |extension| extend extension } if options[:extend]
          extend Module.new(&block) if block_given?
          unless Scope === proxy_scope
            @current_scoped_methods_when_defined = proxy_scope.send(:current_scoped_methods)
          end
          @proxy_scope, @proxy_options = proxy_scope, options.except(:extend)
        end

        def reload
          load_found; self
        end

        def first(*args)
          proxy_found.first(*args)
        end

        def last(*args)
          proxy_found.last(*args)
        end

        def size
          @found ? @found.length : count
        end

        def empty?
          @found ? @found.empty? : count.zero?
        end

        def respond_to?(method, include_private = false)
          super || @proxy_scope.respond_to?(method, include_private)
        end

        def any?
          if block_given?
            proxy_found.any? { |*block_args| yield(*block_args) }
          else
            !empty?
          end
        end

        protected
        def proxy_found
          @found || load_found
        end

        private
        def method_missing(method, *args, &block)
          if scopes.include?(method)
            scopes[method].call(self, *args)
          else
            with_scope({:find => proxy_options, :create => proxy_options[:conditions].is_a?(Hash) ?  proxy_options[:conditions] : {}}, :reverse_merge) do
              method = :new if method == :build
              if current_scoped_methods_when_defined && !scoped_methods.include?(current_scoped_methods_when_defined)
                with_scope current_scoped_methods_when_defined do
                  proxy_scope.send(method, *args, &block)
                end
              else
                proxy_scope.send(method, *args, &block)
              end
            end
          end
        end

        def load_found
          @found = all
        end
      end
    end
  end
end
