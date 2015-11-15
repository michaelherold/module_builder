module ModuleBuilder
  class Builder
    # @!attribute [r] module
    #   @return [Module] the Module built by the builder
    attr_reader :module

    # Creates a new module builder that uses the specified base module
    # as a foundation for its built module.
    #
    # @example
    #   ModuleBuilder::Builder.new(base: Module.new)
    #
    # @param [Module] base the module to use as a base on which to build.
    def initialize(base: Module.new)
      @module = base
    end
  end
end
