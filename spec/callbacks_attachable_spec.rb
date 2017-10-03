require 'spec_helper'

shared_examples "triggering event" do |event, scope|
  context "when triggering event #{event.inspect}" do
    subject { instance.trigger(event, :arg) }
    before { expect(callback).to receive(:call).with(__send__(scope), [:arg]) }
    it { expect{ subject }.not_to raise_error }
  end
end

shared_examples_for "triggering events registered for an instance" do |target|
  scope = target == :class ? :instance : :itself

  let(:callback) { proc{} }

  context "when a callback is attached for a single event" do
    before do
      callback = self.callback
      instance.__send__(target).on(:event){ |*args| callback.call(self, args) }
    end

    include_examples "triggering event", :event, scope
  end

  context "when a callback is attached for multiple events" do
    before do
      callback = self.callback
      instance.__send__(target).on(:event1, :event2){ |*args| callback.call(self, args) }
    end

    include_examples "triggering event", :event1, scope
    include_examples "triggering event", :event2, scope
  end
end

describe "CallbacksAttachable included into a regular class" do
  subject(:instance) { klass.new }
  let!(:klass) { Class.new{ include CallbacksAttachable } }

  include_examples "triggering events registered for an instance", :class
  include_examples "triggering events registered for an instance", :singleton_class
  include_examples "triggering events registered for an instance", :itself
end

describe "CallbacksAttachable included into a singleton class" do
  subject(:instance) { Object.new.extend CallbacksAttachable }
  before { instance.singleton_class.class_eval{ include CallbacksAttachable } }

  include_examples "triggering events registered for an instance", :singleton_class
  include_examples "triggering events registered for an instance", :itself
end

describe "CallbacksAttachable extending an object" do
  subject(:instance) { Object.new.extend CallbacksAttachable }

  include_examples "triggering events registered for an instance", :singleton_class
  include_examples "triggering events registered for an instance", :itself
end
