defmodule EsprezzoCore.Repo.Migrations.CreateLedgerTransactions do
  use Ecto.Migration

  
  def change do
    create table(:ledger_transactions) do
      add :version, :map
      add :block_hash, :string
      add :timestamp, :integer
      add :txid, :string
      add :vin, {:array, :map}, default: []
      add :vout, {:array, :map}, default: []
    end
  end
end