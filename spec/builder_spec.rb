require "spec_helper"

RSpec.describe ModuleBuilder::Builder do
  it "has a module" do
    builder = ModuleBuilder::Builder.new
    expect(builder.module).to be_a_kind_of Module
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
end
