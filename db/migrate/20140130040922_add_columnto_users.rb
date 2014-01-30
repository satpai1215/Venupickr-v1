class AddColumntoUsers < ActiveRecord::Migration
  def change
  	add_column :users, :gmail_contacts_updated_at, :datetime
  end

end
