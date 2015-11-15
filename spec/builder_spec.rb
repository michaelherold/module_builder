require "spec_helper"

RSpec.describe ModuleBuilder::Builder do
  it "has a module" do
    builder = ModuleBuilder::Builder.new
    expect(builder.module).to be_a_kind_of Module
  end
end
