# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :union_memberships do
      primary_key :id
      foreign_key :employee_id, :employees, on_delete: :cascade, on_update: :cascade
    end
  end
end
