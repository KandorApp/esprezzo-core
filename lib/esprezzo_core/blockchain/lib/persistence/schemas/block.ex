defmodule EsprezzoCore.Blockchain.Persistence.Schemas.Block do
  use Ecto.Schema
  use EsprezzoCore.Blockchain.Persistence.QueryMacros
  require IEx
  import Ecto.Changeset
  #alias EsprezzoCore.Blockchain.Persistence.Schemas.Block

  #@primary_key {:id, :binary_id, autogenerate: true}
  
  schema "ledger_blocks" do
    embeds_one :header, Header
    field :header_hash, :string, null: false
    field :timestamp, :integer, null: false
    field :meta, :string
  end

  @doc false
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:timestamp, :header_hash, :meta])
    |> Ecto.Changeset.put_embed(:header, attrs.header)
    |> validate_required([:timestamp, :header_hash])
  end
end

defmodule Header do
  use Ecto.Schema
  embedded_schema do
    field :version, :integer
    field :previous_hash, :string
    field :txns_merkle_root
    field :timestamp, :integer
    field :nonce, :integer
    field :difficulty_target, :integer
  end
end