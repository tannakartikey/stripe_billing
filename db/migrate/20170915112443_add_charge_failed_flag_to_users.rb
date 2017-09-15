class AddChargeFailedFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :charge_failed, :boolean, default: false
  end
end
