# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :service_charges do
      primary_key :id
      foreign_key :union_membership_id, :union_memberships, on_delete: :cascade, on_update: :cascade
      column :date, Date, null: false
      column :charge, BigDecimal, null: false
    end
  end
end
