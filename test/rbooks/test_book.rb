require 'test-unit'
require "rbooks"
require "uri"

class TestBook < Test::Unit::TestCase
  def test_concat_each_item_by_space
    params = Rbooks::Book.concat_each_item_by_space({title: ["なれるSE", "こころ"], author: ["夏目漱石", "与謝野晶子"]})

    assert_equal Hash, params.class
    assert_equal params[:title], "なれるSE こころ"
  end

  def test_exist_application_id
    assert Rbooks.const_defined?(:APPLICATION_ID)
  end

  def test_search
    books = Rbooks::Book.search({title: ["なれるSE"]})
    assert_equal false, books.empty?

    ["count", "page", "first", "last", "hits", "carrier", "pageCount", "Items", "GenreInformation"].each do |key|
      assert books.key?(key)
    end
  end
end
