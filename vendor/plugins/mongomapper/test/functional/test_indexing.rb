require 'test_helper'

class IndexingTest < Test::Unit::TestCase
  context "Indexing" do
    setup do
      @document = Doc do
        set_collection_name 'users'

        key :first_name, String
        key :last_name, String
        key :age, Integer
        key :date, Date
      end
      drop_indexes(@document)
    end

    should "allow creating index for a key" do
      @document.ensure_index :first_name
      @document.should have_index('first_name_1')
    end

    should "allow creating unique index for a key" do
      @document.ensure_index :first_name, :unique => true
      @document.should have_index('first_name_1')
    end

    should "allow creating index on multiple keys" do
      @document.ensure_index [[:first_name, 1], [:last_name, -1]]

      # order is different for different versions of ruby so instead of
      # just checking have_index('first_name_1_last_name_-1') I'm checking
      # the values of the indexes to make sure the index creation was successful
      @document.collection.index_information.detect do |index|
        keys = index[1]
        keys.include?(['first_name', 1]) && keys.include?(['last_name', -1])
      end.should_not be_nil
    end

    should "work with :index shortcut when defining key" do
      @document.key :father, String, :index => true
      @document.should have_index('father_1')
    end
  end
end