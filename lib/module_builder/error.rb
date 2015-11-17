module ModuleBuilder
  # Represents any error that is expected to be raised by {ModuleBuilder}.
  class Error < StandardError; end

  # Raised when a {ModuleBuilder::Buildable} module cannot find the
  # {ModuleBuilder::Builder} to use when building itself.
  class UnspecifiedBuilder < Error; end
end
