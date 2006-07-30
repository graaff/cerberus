require File.dirname(__FILE__) + '/test_helper'

require 'cerberus/notifier/irc'
require 'mock/irc'
require 'mock/build'

class IrcNotifierTest < Test::Unit::TestCase
  def test_notifier
    options = {:notifier => {:irc => {:channel => '#hello'}}, :application_name => 'IrcApp'}
    build = DummyBuild.new('last message', 'this is output', 1232, 'anatol')

    Cerberus::Notifier::Irc.notify(:setup, build, options)

    messages = IRCConnection.messages
    assert_equal 1, messages.size
    assert_equal 'JOIN #hello', messages[0]
  end
end
