class Debateable < ActiveRecord::Base
  belongs_to :debated, :polymorphic => true
end