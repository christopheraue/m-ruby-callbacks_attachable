require 'spec_helper'

shared_examples_for "triggering callbacks registered for an instance" do |target|
  let(:callback) { proc{} }
  before do
    callback = self.callback
    instance.__send__(target).on(:event){ |*args| callback.call(self, args) }
  end

  before { expect(callback).to receive(:call).with(__send__(target == :class ? :instance : :itself), [:arg]) }
  it { expect{ subject }.not_to raise_error }
end

describe "CallbacksAttachable included into a regular class" do
  subject(:instance) { klass.new }
  let!(:klass) { Class.new{ include CallbacksAttachable } }

  describe "Triggering callbacks" do
    subject { instance.trigger(:event, :arg) }

    it_behaves_like "triggering callbacks registered for an instance", :class
    it_behaves_like "triggering callbacks registered for an instance", :singleton_class
    it_behaves_like "triggering callbacks registered for an instance", :itself
  end
end

describe "CallbacksAttachable included into a singleton class" do
  subject(:instance) { Object.new.extend CallbacksAttachable }
  before { instance.singleton_class.class_eval{ include CallbacksAttachable } }

  describe "Triggering callbacks" do
    subject { instance.trigger(:event, :arg) }

    it_behaves_like "triggering callbacks registered for an instance", :singleton_class
    it_behaves_like "triggering callbacks registered for an instance", :itself
  end
end

describe "CallbacksAttachable extending an object" do
  subject(:instance) { Object.new.extend CallbacksAttachable }

  describe "Triggering callbacks" do
    subject { instance.trigger(:event, :arg) }

    it_behaves_like "triggering callbacks registered for an instance", :singleton_class
    it_behaves_like "triggering callbacks registered for an instance", :itself
  end
end
