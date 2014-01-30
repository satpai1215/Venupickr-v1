class AddGmailContactsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :gmail_contacts, :text
  end
end
