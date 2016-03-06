require 'spec_helper'

class CallbacksAttached
  include CallbacksAttachable

  def self.method(*args, &block) :result end
  def self.true(*args, &block) true end
  def self.false(*args, &block) false end
  def method(*args, &block) :result end
  def true(*args, &block) true end
  def false(*args, &block) false end
end

describe CallbacksAttachable do
  subject(:klass) { CallbacksAttached.clone }
  subject(:instance) { klass.new }

  it "needs to be tested"
end
