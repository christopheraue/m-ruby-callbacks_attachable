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

  describe "Registering a callback through the class" do
    describe "Attaching a callback to an event indefinitely" do
      subject { klass.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { klass.on(:event) { |*args| method(*args) } }
        it { is_expected.to send_message(:method).to(klass).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { klass.on(:event, skip: 1) { |*args| method(*args) } }
        it { is_expected.not_to send_message(:method).to(klass) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { klass.trigger(:event, :arg) }
            it { is_expected.to send_message(:method).to(klass).with(:arg) }
            it { is_expected.to be true }
          end
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end
    end

    describe "Attaching a callback to an event to be executed once" do
      subject { klass.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { klass.once_on(:event) { |*args| method(*args) } }
        it { is_expected.to send_message(:method).to(klass).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { klass.once_on(:event, skip: 1) { |*args| method(*args) } }
        it { is_expected.not_to send_message(:method).to(klass) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { klass.trigger(:event, :arg) }
            it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
            it { is_expected.to be true }
          end
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end
    end

    describe "Attaching a callback to an event until a condition is met" do
      subject { klass.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { klass.until_true_on(:event) { |*args| self.true(*args) } }
        it { is_expected.to send_message(:true).to(klass).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.not_to send_message(:true).to(klass).with(:arg) }
          it { is_expected.to be true }
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { klass.once_on(:event, skip: 1) { |*args| self.true(*args) } }
        it { is_expected.not_to send_message(:true).to(klass) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { klass.trigger(:event, :arg) }
          it { is_expected.to send_message(:true).to(klass).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { klass.trigger(:event, :arg) }
            it { is_expected.not_to send_message(:true).to(klass).with(:arg) }
            it { is_expected.to be true }
          end
        end

        context "when the callback is deregistered" do
          before { klass.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
          it { is_expected.to be true }
        end
      end
    end

    context "when no callback is registered" do
      context "when triggering the event anyway" do
        subject { klass.trigger(:event) }
        it { is_expected.to be true }
      end

      context "when a callback is deregistered anyway" do
        subject { klass.off(:event, proc{}) }
        it { is_expected.to be true }
      end
    end

    context "when more than one callback is registered for an event" do
      subject { klass.trigger(:event, :arg) }

      let!(:callback1) { klass.once_on(:event) { |*args| self.method(*args) } }
      let!(:callback2) { klass.until_true_on(:event) { |*args| self.true(*args) } }
      let!(:callback3) { klass.on(:event) { |*args| self.method(*args) } }

      it { is_expected.to send_message(:method).to(klass).with(:arg).twice }
      it { is_expected.to send_message(:true).to(klass).with(:arg) }
      it { is_expected.to be true }

      context "when one callback returns false" do
        let!(:callback1) { klass.once_on(:event) { |*args| self.false(*args) } }

        it { is_expected.not_to send_message(:method).to(klass).with(:arg) }
        it { is_expected.not_to send_message(:true).to(klass).with(:arg) }
        it { is_expected.to send_message(:false).to(klass).with(:arg) }
        it { is_expected.to be false }
      end
    end

    context "when the event is triggered with a context" do
      subject { klass.trigger(:event, :arg, context: instance) }
      let!(:callback) { klass.on(:event) { |*args| method(*args) } }
      it { is_expected.to send_message(:method).to(instance).with(:arg) }
    end
  end

  describe "Registering a callback through an instance" do
    describe "Attaching a callback to an event indefinitely" do
      subject { instance.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { instance.on(:event) { |*args| instance.method(*args) } }
        it { is_expected.to send_message(:method).to(instance).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { instance.on(:event, skip: 1) { |*args| instance.method(*args) } }
        it { is_expected.not_to send_message(:method).to(instance) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { instance.trigger(:event, :arg) }
            it { is_expected.to send_message(:method).to(instance).with(:arg) }
            it { is_expected.to be true }
          end
        end
      end
    end

    describe "Attaching a callback to an event to be executed once" do
      subject { instance.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { instance.once_on(:event) { |*args| instance.method(*args) } }
        it { is_expected.to send_message(:method).to(instance).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.not_to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { instance.once_on(:event, skip: 1) { |*args| instance.method(*args) } }
        it { is_expected.not_to send_message(:method).to(instance) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { instance.trigger(:event, :arg) }
            it { is_expected.not_to send_message(:method).to(instance).with(:arg) }
            it { is_expected.to be true }
          end
        end
      end
    end

    describe "Attaching a callback to an event until a condition is met" do
      subject { instance.trigger(:event, :arg) }

      context "when the callback should be called right away" do
        let!(:callback) { instance.until_true_on(:event) { |*args| instance.true(*args) } }
        it { is_expected.to send_message(:true).to(instance).with(:arg) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.not_to send_message(:true).to(instance).with(:arg) }
          it { is_expected.to be true }
        end

        context "when the callback is deregistered" do
          before { instance.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }
        end
      end

      context "when the callback should skip the first N events" do
        let!(:callback) { instance.once_on(:event, skip: 1) { |*args| instance.true(*args) } }
        it { is_expected.not_to send_message(:true).to(instance) }
        it { is_expected.to be true }

        context "when triggered a second time" do
          before { instance.trigger(:event, :arg) }
          it { is_expected.to send_message(:true).to(instance).with(:arg) }
          it { is_expected.to be true }

          context "when triggered a third time" do
            before { instance.trigger(:event, :arg) }
            it { is_expected.not_to send_message(:true).to(instance).with(:arg) }
            it { is_expected.to be true }
          end
        end

        context "when the callback is deregistered" do
          before { instance.off(:event, callback) }
          it { is_expected.not_to send_message(:method).to(instance).with(:arg) }
          it { is_expected.to be true }
        end
      end
    end

    describe "#off: Deregisters a callback for this instance" do
      subject { instance.off(:event, :callback) }
      it { is_expected.to send_message(:off).to(klass).with(:event, :callback) }
    end

    describe "#trigger: Triggers the event in the context of the instance" do
      subject { instance.trigger(:event, :arg) }
      before { instance.on(:event) { |*args| callback.call(*args) } }
      let(:callback) { proc{} }
      it { is_expected.to send_message(:call).to(callback).with(:arg) }

      context "when another callback has been registered for the whole class" do
        before { klass.on(:event) { |*args| method(*args) } }
        it { is_expected.to send_message(:call).to(callback).with(:arg) }
        it { is_expected.to send_message(:method).to(instance) }
      end

      context "when another callback has been registered for a different context" do
        before { instance2.on(:event) { |*args| method(*args) } }
        let(:instance2) { klass.new }
        it { is_expected.to send_message(:call).to(callback).with(:arg) }
        it { is_expected.not_to send_message(:method).to(instance2) }
      end
    end
  end
end
