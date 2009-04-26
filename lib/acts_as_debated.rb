module ActiveRecord
  module Acts
    module Debated
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_debated(options = {})
          has_many :debateables, :as => :debated, :dependent => :destroy
          
          include ActiveRecord::Acts::Debated::InstanceMethods
          extend ActiveRecord::Acts::Debated::SingletonMethods
        end
      end
      
      module SingletonMethods
        def find_average_of( score )
          find(:all, :include => [:rates] ).collect {|i| i if i.average_rating.to_i == score }.compact
        end
      end

      module InstanceMethods
        # Rates the object by a given score. A user object can be passed to the method.
        def debate_it( thumbs_up, user_id )
          return unless user_id
          debateable = Debateable.find_or_create_by_user_id_and_debated_type_and_debated_id(1,self.class,self.id)
          debateable.user_id = user_id
          debateable.score = (thumbs_up) ? 1 : -1
          debateables << debateable
        end
        
        def debate_score
          debateables.sum(:score)
        end
      end
      
    end
  end
end