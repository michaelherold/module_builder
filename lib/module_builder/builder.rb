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

      add_inclusions
    end

    # Lists the modules to be included into the built module.
    #
    # @note This can be overridden in a subclass to automatically
    #   include modules in the built module.
    #
    # @return [Array<Module>] the modules to be included into the built
    #   module.
    def inclusions
      []
    end

    private

    # Includes the modules listed by the builder's {#inclusions} in the
    # built module.
    #
    # @note This method is called by the constructor and can be
    #   overridden.
    #
    # @return [void]
    def add_inclusions
      inclusions.each { |inclusion| @module.__send__(:include, inclusion) }
    end
  end
end
