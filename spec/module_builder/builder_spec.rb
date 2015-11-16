require "spec_helper"

RSpec.describe ModuleBuilder::Builder do
  it "has a module" do
    builder = ModuleBuilder::Builder.new
    expect(builder.module).to be_a_kind_of Module
  end

  it "builds an includable module by default" do
    builder = ModuleBuilder::Builder.new

    class_with_built_module = Class.new do
      include builder.module
    end

    expect { class_with_built_module.new }.not_to raise_error
  end

  it "builds an extendable module by default" do
    builder = ModuleBuilder::Builder.new

    class_with_built_module = Class.new do
      extend builder.module
    end

    expect { class_with_built_module.new }.not_to raise_error
  end

  it "includes all modules listed for inclusion in the built module" do
    Quack = Module.new do
      def quack
        "quack"
      end
    end

    including_builder = Class.new(ModuleBuilder::Builder) do
      def inclusions
        [Quack]
      end
    end

    quacking_class = Class.new do
      include including_builder.new.module
    end

    quacker = quacking_class.new
    expect(quacker).to respond_to(:quack)
    expect(quacker.quack).to eq("quack")
  end

  it "extends all modules listed for extension on the built module" do
    Bark = Module.new do
      def bark
        "bark"
      end
    end

    extending_builder = Class.new(ModuleBuilder::Builder) do
      def extensions
        [Bark]
      end
    end

    barking_class = Class.new do
      extend extending_builder.new.module
    end

    expect(barking_class).to respond_to(:bark)
    expect(barking_class.bark).to eq("bark")
  end

  it "calls any defined hooks" do
    defined_hook_builder = Class.new(ModuleBuilder::Builder) do
      def hooks
        [:add_quack_method, :add_quack_bang_method]
      end

      def add_quack_bang_method
        @module.__send__(:alias_method, :quack!, :quack)
      end

      private

      def add_quack_method
        @module.__send__(:define_method, :quack, -> { "quack" })
      end
    end

    quacking_class = Class.new do
      include defined_hook_builder.new.module
    end

    quacker = quacking_class.new
    expect(quacker).to respond_to(:quack)
    expect(quacker.quack).to eq("quack")
    expect(quacker).to respond_to(:quack!)
    expect(quacker.quack!).to eq("quack")
  end

  it "allows for stateful hooks based on the state passed into the builder" do
    Persisting = Module.new do
      def persist
        "persisting"
      end
    end

    stateful_hook_builder = Class.new(ModuleBuilder::Builder) do
      def hooks
        [:rename_persist_method]
      end

      def inclusions
        [Persisting]
      end

      def rename_persist_method
        return if @persist_method == :persist

        @module.__send__(:alias_method, @persist_method, :persist)
        @module.__send__(:undef_method, :persist)
      end
    end

    persisting_class = Class.new do
      include stateful_hook_builder.new(:persist_method => :save).module
    end

    persister = persisting_class.new
    expect(persister).to respond_to(:save)
    expect(persister).not_to respond_to(:persist)
    expect(persister.save).to eq("persisting")
  end
end
