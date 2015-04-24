class CreatePartnerCosts < ActiveRecord::Migration
  def change
    create_table :partner_costs do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :cost

      t.timestamps
    end
  end
end
