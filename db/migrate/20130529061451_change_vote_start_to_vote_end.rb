class ChangeVoteStartToVoteEnd < ActiveRecord::Migration
	def change
    	rename_column :events, :vote_start, :vote_end
  	end
end
