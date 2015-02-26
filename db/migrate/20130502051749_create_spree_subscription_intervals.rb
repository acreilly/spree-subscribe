class CreateSpreeSubscriptionIntervals < ActiveRecord::Migration
  def change
    create_table :spree_subscription_intervals do |t|
      t.string :name
      t.integer :times
      t.integer :time_length
      t.integer :time_unit
      t.integer :time_unit_length
      t.timestamps
    end

    create_table :spree_subscription_intervals_products, :id => false do |t|
      t.references :product
      t.references :subscription_interval
    end
  end
end
