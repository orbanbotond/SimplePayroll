# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :payment_methods do
      primary_key :id
      foreign_key :employee_id, :employees, on_delete: :cascade, on_update: :cascade
      column :type, String, null: false
    end
  end
end
