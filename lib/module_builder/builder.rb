require "module_builder/build_context"

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
      add_extended_hook
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
    # @note This method is called by the constructor and can be
    #   overridden.
    #
    # @return [void]
    def add_inclusions
      inclusions.each { |inclusion| @module.__send__(:include, inclusion) }
    end

    # Gives access to the builder's context when dynamically defining
    # hooks.
    #
    # @api private
    #
    # @return [void]
    def within_context
      yield BuildContext.new(self)
    end
  end
end
