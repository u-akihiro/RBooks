require 'test-unit'

class TestRbooks < Test::Unit::TestCase
  class << self
  end

  def test_assertion
    assert_equal 1, 1
  end
end