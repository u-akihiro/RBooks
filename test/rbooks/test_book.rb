require 'test-unit'
require "rbooks"
require "uri"

class TestBook < Test::Unit::TestCase
  def test_encode_each_param
    params = Rbooks::Book.encode_each_params({title: ['なれるSE', 'こころ']})
    assert_equal Hash, params.class
    assert_equal params[:title], URI.encode_www_form_component('なれるSE こころ')
  end
end