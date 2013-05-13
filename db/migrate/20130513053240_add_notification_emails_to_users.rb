class AddNotificationEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_emails, :boolean, :default => 1
  end
end
