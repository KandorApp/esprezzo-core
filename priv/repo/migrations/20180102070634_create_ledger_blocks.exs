defmodule EsprezzoCore.Repo.Migrations.CreateLedgerBlocks do
  use Ecto.Migration

  def change do
    create table(:ledger_blocks) do

      add :header, :map
      add :block_number, :integer
      add :timestamp, :integer
      add :header_hash, :string
      add :meta, :string
      add :txn_count, {:array, :map}, default: []
      add :txns, {:array, :map}, default: []
   
    end

  end

end
