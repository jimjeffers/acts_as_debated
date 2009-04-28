module ActiveRecord
  module Acts
    module Debated
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_debated(options = {})
          has_many :debateables, :as => :debated, :dependent => :destroy
          extend ActiveRecord::Acts::Debated::SingletonMethods
          include ActiveRecord::Acts::Debated::InstanceMethods
        end
      end
      
      module OrderByScore
        def order_by_score(sql={})
          proxy_reflection.klass.order_by_score(sql.merge({:owner => proxy_owner}))
        end
      end
        
      module SingletonMethods
        def order_by_score(sql={})
          find_by_sql(" SELECT 
                          target_objects.*,
                          debateables.debated_id,
                          debateables.debated_type, 
                          sum(debateables.score) AS debated_score 
                        FROM 
                          #{table_name} target_objects, 
                          #{Debateable.table_name} debateables 
                        WHERE
                          debateables.debated_id = target_objects.id AND
                          debateables.debated_type = '#{name}'
                          #{'AND target_objects.'+sql[:owner].class.name+'_id = '+sql[:owner].id.to_s if sql[:owner]}
                        GROUP BY
                          debateables.debated_id
                        ORDER BY 
                          debated_score #{sql[:order] || 'DESC'}
                        #{'LIMIT '+sql[:limit].to_s if sql[:limit]} 
                        #{'OFFSET '+sql[:offset].to_s if sql[:offset]}")
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