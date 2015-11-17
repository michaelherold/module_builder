module ModuleBuilder
  # Gives a module the ability to be customized via a {ModuleBuilder::Builder}
  # in a class-like manner via a {::new} method.
  module Buildable
    # Extends the {ClassMethods} module onto any descendent.
    #
    # @param [Module] descendent the descendent module.
    # @return [void]
    def self.included(descendent)
      descendent.extend(ClassMethods)
    end

    # Gives a module that mixes in Buildable a small DSL for specifying the
    # class to use when building the module and the ability to easily build a
    # new copy of the module using a given state.
    module ClassMethods
      # Sets and accesses the builder class for a buildable module.
      #
      # @example
      #   class MyBuilder < ModuleBuilder::Builder
      #   end
      #
      #   module MyBuiltModule
      #     include ModuleBuilder::Buildable
      #
      #     builder MyBuilder
      #   end
      #
      # @note When used as a class method, it declaratively sets the builder
      #   class. When used without a parameter, it uses the `:not_set` symbol
      #   as a marker to set itself into reader mode.
      #
      # @param [Class] builder_class the class to instantiate when building the
      #   module.
      # @raise [ModuleBuilder::UnspecifiedBuilder] if the builder is not found.
      # @return [Class] the builder class.
      def builder(builder_class = :not_set)
        if builder_class.equal?(:not_set)
          builder_or_fail
        else
          @builder = builder_class
        end
      end

      # Builds a module with the configured builder class using the given
      # state.
      #
      # @example
      #   module MyBuildableModule
      #     include ModuleBuilder::Buildable
      #
      #     class Builder < ModuleBuilder::Builder
      #     end
      #   end
      #
      #   class MyClass
      #     include MyBuildableModule.new(:example => "value")
      #   end
      #
      # @param [Hash] state the state to use when configuring the builder.
      # @return [Module] the newly built module.
      def new(**state)
        builder.new(state).module
      end

      private

      # Fetches the configured or default builder class for the module.
      #
      # @raise [ModuleBuilder::UnspecifiedBuilder] if the builder is not found.
      # @return [Class] the builder class.
      def builder_or_fail
        if @builder
          @builder
        else
          default_builder
        end
      end

      # Fetches the default builder for the module.
      #
      # @raise [ModuleBuilder::UnspecifiedBuilder] if there is no default
      #   Builder within the module.
      # @return [Class] the default builder class.
      def default_builder
        const_get("Builder")
      rescue NameError
        raise UnspecifiedBuilder, "No builder specified"
      end
    end
  end
end
