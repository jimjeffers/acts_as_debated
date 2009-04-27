class Debateable < ActiveRecord::Base
  belongs_to :debated, :polymorphic => true
  validates_uniqueness_of :score, :scope => [:user_id,:debated_id,:debated_type]
end