require 'test/unit'
require File.dirname(__FILE__) + '/../lib/belongs_to_demeter'

class BelongsToDemeterTest < Test::Unit::TestCase
  def setup
    c = Class.new
    c.send(:include, BelongsToDemeter)
  end

  def test_runs
    assert 'yay'
  end
end
