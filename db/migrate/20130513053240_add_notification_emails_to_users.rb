class AddNotificationEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_emails, :boolean, :default => true
  end
end
