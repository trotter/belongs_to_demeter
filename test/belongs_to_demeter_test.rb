require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require File.dirname(__FILE__) + '/../lib/belongs_to_demeter'

class User
  def self.find_by_login(login)
    login
  end

  def login
    'login'
  end
end

class BelongsToDemeterTest < Test::Unit::TestCase
  def setup
    @c = Class.new(ActiveRecord::Base)
    class << @c
      def columns; []; end
    end
    @c.send(:include, BelongsToDemeter)
  end

  def test_responds_to_belongs_to_attribute
    @c.belongs_to :user
    assert @c.new.respond_to?(:user_login)
  end

  def test_calls_belongs_to_attribute
    @c.belongs_to :user
    @c.send(:define_method, :user) { User.new }
    assert_equal User.new.login, @c.new.user_login

    @c.send(:define_method, :user) { nil }
    assert_equal nil, @c.new.user_login
  end

  def test_responds_to_belongs_to_assign
    @c.belongs_to :user
    assert @c.new.respond_to?(:user_login=)
  end

  def test_calls_belongs_to_assign
    @c.belongs_to :user
    @c.send(:define_method, :user=) { @user = :set_user }
    @c.send(:define_method, :user) { @user }
    obj = @c.new
    obj.user_login = 'tony'
    assert_equal :set_user, obj.user
  end
end
