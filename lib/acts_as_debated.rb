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
        end
      end

      module InstanceMethods
        # Rates the object by a given score. A user object can be passed to the method.
        def debate_it( thumbs_up, user )
          return unless user
          debateable = debateables.find_or_create_by_user_id(user.id)
          debateable.score = (thumbs_up) ? 1 : -1
          (debateable.new_record?) ? debateables << debateable : debateable.save
          debateable
        end
        
        def debated_score
          debateables.sum(:score)
        end
        
        def thumbs_up_from(user)
          debate_it(true,user)
        end
        
        def thumbs_down_from(user)
          debate_it(false,user)
        end
        
        # Checks wheter a user rated the object or not.
        def debated_by?(user)
          (debateables.detect {|r| r.user_id == user.id })
        end
      end
      
    end
  end
end