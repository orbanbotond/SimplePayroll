# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :classifications do
      primary_key :id
      foreign_key :employee_id, :employees, on_delete: :cascade, on_update: :cascade
      column :type, String, null: false
      column :salary, BigDecimal, null: true # if the type is
      column :rate, BigDecimal, null: false
    end
  end
end
