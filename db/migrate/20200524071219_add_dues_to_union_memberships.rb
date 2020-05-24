# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table(:union_memberships) do
      add_column :dues, BigDecimal, default: 0, null: false
    end
  end
end
