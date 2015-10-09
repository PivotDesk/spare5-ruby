$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'spare5-ruby/version'

Gem::Specification.new do |s|
  s.name        = 'spare5-ruby'
  s.version     = Spare5::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Spare5 API toolkit for creating and managing job batches, jobs, questions, and answers!"
  s.description = "A gem for accessing the Spare5 API"
  s.authors     = ["Spare5"]
  s.email       = 'support@spare5.com'
  s.files       = Dir.glob(`git ls-files`.split("\n"))
  #["lib/spare5-ruby.rb", "lib/spare5-ruby/verion.rb", "lib/spare5-ruby/connection.rb", "lib/spare5-ruby/job_requester.rb"]
  s.homepage    = 'http://github.com/spare5/spare5-ruby'
  s.license       = 'MIT'
end