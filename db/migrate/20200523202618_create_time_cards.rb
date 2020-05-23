# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :time_cards do
      primary_key :id
      foreign_key :classification_id, :classifications, on_delete: :cascade, on_update: :cascade
      column :date, DateTime, null: false
      column :hours, Integer, null: false
    end
  end
end
