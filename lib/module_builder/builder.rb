module ModuleBuilder
  # Builds a module based on instance-level state and class-level configuration.
  #
  # This class is intended to be subclassed, not used as-is. There are several
  # methods to override in order to give the builder the behavior you want. You
  # can also define setup methods that are specified in the {Builder#hooks}
  # array for arbitrary setup based on the state passed into the builder's
  # constructor.
  class Builder
    # The module built by the builder.
    #
    # @!attribute [r] module
    #   @return [Module] the Module built by the builder
    attr_reader :module

    # Creates a new module builder that uses the specified base module as a
    # foundation for its built module and sets any other specified key/value
    # pairs as instance variables on the builder.
    #
    # @example
    #   ModuleBuilder::Builder.new(base: Module.new)
    #
    # @param [Hash] state the state to use for defined hooks.
    # @option state [Module] :base (Module.new) the module to use as a base on
    #   which to build.
    def initialize(state = {})
      state = [builder_defaults, defaults, state].reduce(&:merge)
      @module = state.delete(:base)

      state.each_pair do |attr, value|
        instance_variable_set("@#{attr}", value)
      end

      add_extended_hook
      add_inclusions
      add_defined_hooks
    end

    # The defaults for any state values that require them.
    #
    # @note This can be overridden in a subclass with any default values for
    #   state variables that are needed in defined hooks.
    #
    # @return [Hash] the default state for defined hooks.
    def defaults
      {}
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

    # Defines the basic defaults that every builder needs.
    #
    # @return [Hash] the defaults that every builder needs.
    def builder_defaults
      {:base => Module.new}
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
