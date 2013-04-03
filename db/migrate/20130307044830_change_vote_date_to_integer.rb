class ChangeVoteDateToInteger < ActiveRecord::Migration
  def up
  	remove_column :events, :vote_start
  	add_column :events, :vote_start, :integer
  end

  def down
  	remove_column :events, :vote_start
  	add_column :events, :vote_start, :datetime
  end
end
