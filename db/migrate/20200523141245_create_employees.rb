# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :employees do
      primary_key :id
      column :name, String, null: false
      column :address, String, null: false
    end
  end
end
