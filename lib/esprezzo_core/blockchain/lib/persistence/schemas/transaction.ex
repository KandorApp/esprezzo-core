defmodule EsprezzoCore.Blockchain.Persistence.Schemas.Transaction do
  use Ecto.Schema
  use EsprezzoCore.Blockchain.Persistence.QueryMacros
  require IEx
  import Ecto.Changeset

  schema "ledger_transactions" do
    field :version, :integer
    field :block_hash, :string
    field :txid, :string
    field :timestamp, :integer, null: false
    field :meta, :string
    embeds_many :vin, Input
    embeds_many :vout, Output
  end

  def changeset(block, attrs) do
    block
    |> cast(attrs, [:version, :timestamp, :block_hash, :txid, :meta])
    |> Ecto.Changeset.put_embed(:vin, attrs.vin)
    |> Ecto.Changeset.put_embed(:vout, attrs.vout)
    |> validate_required([:timestamp, :block_hash, :txid, :version])
  end
  
end

defmodule Output do
  use Ecto.Schema
  embedded_schema do
    field :val, :string
    field :locking_contract, :string
  end
end

defmodule Input do
  use Ecto.Schema
  embedded_schema do
    field :txid, :string
    field :vout, :string
    field :script_sig, :string
  end
end