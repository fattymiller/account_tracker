$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "account_tracker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "account_tracker"
  s.version     = AccountTracker::VERSION
  s.authors     = ["fattymiller"]
  s.email       = ["fatty@mobcash.com.au"]
  s.homepage    = "https://github.com/fattymiller/base_jump"
  s.summary     = "Simple way of tracking accounts and invoices."
  s.description = "An extremely basic account tracker to handle invoice, payments and batch payment allocation."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
  
  s.add_dependency "base_jump_commands_base"
  s.add_dependency "base_jump_plugins_base"
  s.add_dependency "base_jump_scheduler"

  s.add_development_dependency "sqlite3"
end
