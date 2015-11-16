module ModuleBuilder
  module Buildable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def builder(builder_class = :not_set)
        if builder_class == :not_set
          builder_or_fail
        else
          @builder = builder_class
        end
      end

      def new(**state)
        builder.new(state).module
      end

      private

      def builder_or_fail
        if @builder
          @builder
        else
          default_builder
        end
      end

      def default_builder
        const_get("Builder")
      rescue NameError
        raise ModuleBuilder::UnspecifiedBuilder, "No builder specified"
      end
    end
  end
end
