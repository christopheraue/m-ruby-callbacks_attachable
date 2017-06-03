require 'spec_helper'

describe "CallbacksAttachable included into a regular class" do
  let!(:klass) { Class.new{ include CallbacksAttachable } }
  subject(:instance) { klass.new }

  let(:callback) { proc{} }

  context "when a callback is attached to the class" do
    before do
      callback = self.callback
      klass.on(:event) { |*args| callback.call(self, args) }
    end

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(instance, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end

  context "when a callback is attached to an instance's singleton class" do
    before { instance.singleton_class.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end

  context "when a callback is attached to an instance" do
    before { instance.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end
end

describe "CallbacksAttachable included into a singleton class" do
  subject(:instance) { Object.new.extend CallbacksAttachable }
  before { instance.singleton_class.class_eval{ include CallbacksAttachable } }

  let(:callback) { proc{} }

  context "when a callback is attached to the singleton class" do
    before { instance.singleton_class.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end

  context "when a callback is attached to an instance" do
    before { instance.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end
end

describe "CallbacksAttachable extending an object" do
  subject(:instance) { Object.new.extend CallbacksAttachable }

  let(:callback) { proc{} }

  context "when a callback is attached to the singleton class" do
    before { instance.singleton_class.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end

  context "when a callback is attached to an instance" do
    before { instance.on(:event) do |*args|
      callback.call(self, args)
    end }

    context "when the event is triggered" do
      subject { instance.trigger(:event, :arg) }
      before { expect(callback).to receive(:call).with(self, [:arg]) }
      it { expect{ subject }.not_to raise_error }
    end
  end
end
