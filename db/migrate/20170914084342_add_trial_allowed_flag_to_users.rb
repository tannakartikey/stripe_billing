class AddTrialAllowedFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_allowed, :boolean, default: true
  end
end
