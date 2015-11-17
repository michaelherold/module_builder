require "spec_helper"

RSpec.describe ModuleBuilder::Buildable do
  it "has a DSL for setting the builder class" do
    builder_class = Class.new(ModuleBuilder::Builder) do
      def inclusions
        [
          Module.new do
            define_method :yodel do
              "yodel lay hee hoo!"
            end
          end
        ]
      end
    end

    buildable = Module.new do
      include ModuleBuilder::Buildable

      builder builder_class
    end

    buildable_class = Class.new do
      include buildable.new
    end

    object = buildable_class.new
    expect(object).to respond_to(:yodel)
  end

  it "defaults the builder to a nested Builder class in its namespace" do
    module BuildableWithBuilder
      include ModuleBuilder::Buildable

      class Builder < ModuleBuilder::Builder
        def inclusions
          [
            Module.new do
              define_method(:laugh) do
                "ha ha ha!"
              end
            end
          ]
        end
      end
    end

    buildable_class = Class.new do
      include BuildableWithBuilder.new
    end

    object = buildable_class.new
    expect(object).to respond_to(:laugh)
  end

  it "raises an error when there is no builder specified" do
    module NoBuilder
      include ModuleBuilder::Buildable
    end

    expect { NoBuilder.new }.to raise_error(ModuleBuilder::UnspecifiedBuilder)
  end

  it "passes the state onto the builder" do
    builder_class = Class.new(ModuleBuilder::Builder) do
      def inclusions
        [
          Module.new do
            define_method :yodel do
              "yodel lay hee hoo!"
            end
          end
        ]
      end
    end

    buildable = Module.new do
      include ModuleBuilder::Buildable

      builder builder_class
    end

    expect(builder_class).to receive(:new).
      with(:example => "value").
      and_call_original

    buildable.new(:example => "value")
  end
end
