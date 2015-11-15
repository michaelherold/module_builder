module ModuleBuilder
  # A simple class that allows access to the builder's context
  # when dynamically defining any methods on a built module.
  #
  # @api private
  BuildContext = Class.new(SimpleDelegator)
end
