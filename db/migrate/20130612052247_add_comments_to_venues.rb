class AddCommentsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :comments, :string
  end
end
