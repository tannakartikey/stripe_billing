class AddPaymentFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string, null: true
    add_column :users, :subscription_id, :string, null: true
    add_column :users, :payment_source, :string, null: true
    add_column :users, :is_active, :boolean, default: true
  end
end
