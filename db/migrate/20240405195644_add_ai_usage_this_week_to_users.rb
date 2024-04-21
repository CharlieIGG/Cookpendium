class AddAiUsageThisWeekToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :ai_usage_this_week, :integer, default: 0
  end
end
