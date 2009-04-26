begin
  require File.expand_path(File.dirname(__FILE__) + '/../../../../spec/spec_helper')
rescue LoadError => error
  puts "You need to install rspec in your base app because of this error:\n" + error
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

