class DebateableMigration < ActiveRecord::Migration
  def self.up
    create_table :debateables do |t|
      t.column :user_id, :integer
      t.column :debated_id, :integer
      t.column :debated_type, :string, :limit => 32
      t.integer :score
      t.timestamps
    end
    
    add_index :debateables, :user_id
    add_index :debateables, [:debated_id, :debated_type]
  end
  
  def self.down
    drop_table :debateables
  end
end