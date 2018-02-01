defmodule EsprezzoCore.Blockchain.Persistence.Schemas.Block do
  use Ecto.Schema
  use EsprezzoCore.Blockchain.Persistence.QueryMacros

  import Ecto.Changeset
  import Ecto.Query
  
  alias EsprezzoCore.Repo
  
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

  @doc false
  def find(hash) do
    __MODULE__
      |> where([b], fragment("header_hash = ?", ^hash))
      |> order_by([b], desc: b.timestamp)
      |> Repo.one
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