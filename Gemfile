source "https://rubygems.org"

gemspec

group :development do
  gem "guard"
  gem "guard-bundler"
  gem "guard-inch"
  gem "guard-rspec", "~> 4.6"
  gem "guard-rubocop"
  gem "guard-yard"
  gem "inch"
  gem "mutant-rspec" unless RUBY_VERSION < "2.1"
  gem "rake"
  gem "rubocop", "0.35.1"
  gem "yard", "~> 0.8"
end

group :development, :test do
  gem "pry"
end

group :test do
  gem "codeclimate-test-reporter", :require => false
  gem "rspec", "~> 3.4"
  gem "simplecov"
end
