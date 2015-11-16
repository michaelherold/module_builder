module ModuleBuilder
  class UnspecifiedBuilder < Error
    def initialize(attributes = {})
      super(compose_message("unspecified_builder", attributes))
    end
  end
end
