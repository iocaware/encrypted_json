require "bundler"
Bundler::GemHelper.install_tasks

desc "Run all tests"
task :default => :spec

desc "Run Specs"
task :spec do 
	system 'bundle exec rspec --color --format documentation spec/*_spec.rb'
end
	
end
