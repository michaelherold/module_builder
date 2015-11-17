# ModuleBuilder

ModuleBuilder gives you the ability to create modules that are customizable for
different situations. Are you creating a module that has an adapter, but don't
want to expose a setter on the including class because it's not a public API?
ModuleBuilder can help with that! Do you have two implementations of some
behavior that have different tradeoffs? Do you want to offer both through one
easy-to-use syntax? ModuleBuilder can do that too!

Come see what ModuleBuilder will help you with today!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'module_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install module_builder

## Usage

ModuleBuilder revolves around the concept of Builders that are responsible for
building modules based on your specification. For convenience, there is a
`Buildable` module that you can mix in to give your module building
superpowers.

You configure Builders through two channels: class-level configuration and
instance-level state. There are three types of class-level configuration:
stateless inclusions, stateless extensions, and defined hooks.

Stateless methods do not give much more power than just using a standard set of
`include`s and `extend`s. However, they help you organize your code in an
easily extensible fashion.

You can use instance-level state within defined hooks to customize the behavior
of the built module. If you need to conditionally define a method based on the
configuration, you want to look here.

### Stateless Inclusions

The builder simply `include`s stateless inclusions into the built module. There
are no customization hooks here, just a single place to specify all the modules
you want to `include` in your built module.

```ruby
class StatelessInclusionBuilder < ModuleBuilder::Builder
  def inclusions
    [Comparable, Enumerable]
  end
end

StatelessInclusionBuilder.new.module.ancestors
#=> [#<Module>, Enumerable, Comparable]
```

### Stateless Extensions

The builder adds all stateless extensions into the `Module#extended` hook of
the built module so they are extended onto anything that extends the built
module.

```ruby
module Quack
  def quack
    "quack"
  end
end

class QuackingBuilder < ModuleBuilder::Builder
  def extensions
    [Quack]
  end
end

class Duck
  extend QuackingBuilder.new.module
end

Duck.quack #=> "quack"
```

### Defined Hooks

Defined hooks are where you can do the heavy customization when building a
module. They are arbitrary methods that the builder invokes during its
initialization. Add any behavior that you want to make customizable via the
state that you give to the builder as a defined hook.

```ruby
module Walk
  def walk
    "step, step, step"
  end
end

class WalkingBuilder < ModuleBuilder::Builder
  def hooks
    [:rename_walk]
  end

  def inclusions
    [Walk]
  end

  private

  def rename_walk
    return unless @walk_method

    @module.__send__(:alias_method, @walk_method, :walk)
    @module.__send__(:undef_method, :walk)
  end
end

class Duck
  include WalkingBuilder.new(:walk_method => :waddle).module
end

Duck.new.waddle  #=> "step, step, step"
Duck.new.walk    #=> NoMethodError
```

### Buildable Module

Explicitly instantiating a Builder and accessing the module that it built is
clunky. To gain easy access to a consistent syntax for your module, you can
include the `Buildable` module and specify the builder you want to use when
building your module.

```ruby
class MyBuilder < ModuleBuilder::Builder
end

module BuildableExample
  include ModuleBuilder::Buildable

  builder MyBuilder
end

module IncludingModule
  include BuildableExample.new(:state => "value")
end
```

`Buildable` defaults to using a `Builder` defined within the current module.
You can rely on that instead of using the DSL for specifying the builder.

```ruby
module OtherBuildableExample
  include ModuleBuilder::Buildable

  class Builder < ModuleBuilder::Builder
  end
end

module OtherIncludingModule
  include OtherBuildableExample.new(:my_config_value => "awesome")
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

When writing code, you can use the helper application [Guard][guard] to
automatically run tests and coverage tools whenever you modify and save a file.
This helps to eliminate the tedium of running tests manually and reduces the
change that you will accidentally forget to run the tests. To use Guard, run
`bundle exec guard`.

Before committing code, run `rake` to check that the code conforms to the style
guidelines of the project, that all of the tests are green (if you're writing a
feature; if you're only submitting a failing test, then it does not have to
pass!), and that the changes are sufficiently documented.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org][rubygems].

[guard]: http://guardgem.org
[rubygems]: https://rubygems.org

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/michaelherold/module_builder. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant][covenant] code of conduct.

[covenant]: http://contributor-covenant.org

## Supported Ruby Versions

This library aims to support the following Ruby versions:

* Ruby 2.0
* Ruby 2.1
* Ruby 2.2
* JRuby 9.0

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions,
however support will only be provided for the versions listed above.

If you would like this library to support another Ruby version or
implementation, you may volunteer to be a maintainer. Being a maintainer
entails making sure all tests run and pass on that implementation. When
something breaks on your implementation, you will be responsible for providing
patches in a timely fashion. If critical issues for a particular implementation
exist at the time of a major release, support for that Ruby version may be
dropped.

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pessimistic] with two digits of precision. For example:

    spec.add_dependency "module_builder", "~> 0.1"

[pessimistic]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[semver]: http://semver.org/spec/v2.0.0.html

## License

The gem is available as open source under the terms of the [MIT License][license].

[license]: http://opensource.org/licenses/MIT.
