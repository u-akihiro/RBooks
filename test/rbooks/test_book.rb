require 'test-unit'
require "rbooks"
require "uri"

class TestBook < Test::Unit::TestCase
  def test_concat_each_item_by_space
    params = Rbooks::Book.concat_each_item_by_space({title: ["なれるSE", "こころ"], author: ["夏目漱石", "与謝野晶子"]})

    assert_equal Hash, params.class
    assert_equal params[:title], "なれるSE こころ"
  end

  def test_raised_exception
  end
end