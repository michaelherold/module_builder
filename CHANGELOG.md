# Change Log

All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning 2.0.0][semver]. Any violations of this
scheme are considered to be bugs.

[semver]: http://semver.org/spec/v2.0.0.html

## [Unreleased][unreleased]

### Added

- Nothing yet.

## [0.1.0] - 2015-11-21

### Added

- Stateless inclusions via the `Builder#inclusions` extension method.
- Stateless extension via the `Builder#extensions` extension method.
- Defined hooks via the `Builder#hooks` extension method.
- Stateful building via passing state into the Builder constructor and using
  the resulting state in a defined hook.
- Buildable module to mix into modules that you want to be able to build.
- Default state via the `Builder#defaults` extension method.
- Including a `Buildable` module includes the default built version in the
  descendant class or module.

[0.1.0]: https://github.com/michaelherold/module_builder/tree/v0.1.0
[unreleased]: https://github.com/michaelherold/module_builder/compare/v0.1.0...HEAD
