# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :sales_receipts do
      primary_key :id
      foreign_key :classification_id, :classifications, on_delete: :cascade, on_update: :cascade
      column :date, DateTime, null: false
      column :amount, BigDecimal, null: false
    end
  end
end
