class RemoveVoteCountFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :votecount
  end

  def down
    add_column :events, :votecount, :integer
  end
end
