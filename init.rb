# Include hook code here
require File.dirname(__FILE__) + '/lib/acts_as_debated'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Debated)