class AddNotesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :notes, :text, :limit => 255
  end
end
