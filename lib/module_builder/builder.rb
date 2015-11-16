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
    def initialize(base: Module.new, **state)
      @module = base

      state.each_pair do |attr, value|
        instance_variable_set("@#{attr}", value)
      end

      add_extended_hook
      add_inclusions
      add_defined_hooks
    end

    # Lists the modules to be added into the Module#extended hook
    # of the built module.
    #
    # @note This can be overridden in a subclass with any modules that
    #   should be extended onto modules that extend the built module.
    #
    # @return [Array<Module>] the modules to be extended onto any
    #   modules that extend the built module.
    def extensions
      []
    end

    # Lists the methods that should be called when building a module.
    #
    # @note This can be overridden in a subclass with any methods that
    #   should be called to build the built module.
    #
    # @return [Array<Symbol>] the methods to call when building the
    #   module.
    def hooks
      []
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

    # Performs every method listed in the builder's {#hooks}.
    #
    # @return [void]
    def add_defined_hooks
      hooks.each { |hook| __send__(hook) }
    end

    # Adds the modules listed by the builder's {#extensions} to the
    # Module#extended hook, for extension onto any modules that
    # extend the built module
    #
    # @return [void]
    def add_extended_hook
      within_context do |context|
        @module.define_singleton_method :extended do |object|
          context.extensions.each { |extension| object.extend(extension) }
        end
      end
    end

    # Includes the modules listed by the builder's {#inclusions} in the
    # built module.
    #
    # @return [void]
    def add_inclusions
      inclusions.each { |mod| @module.__send__(:include, mod) }
    end

    # Gives access to the builder's context when dynamically defining
    # hooks.
    #
    # @api private
    #
    # @return [void]
    def within_context
      yield self
    end
  end
end
