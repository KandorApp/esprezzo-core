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
  end

  @doc false
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:timestamp, :header_hash])
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
  end
end
 
defmodule Transaction do
  use Ecto.Schema
  embedded_schema do
    field :version, :integer
    field :txid, :string
    field :vin, {:array, :map}
    field :vout, {:array, :map}
  end
end

defmodule Output do
  use Ecto.Schema
  embedded_schema do
    field :val, :string
    field :script_pub_key, :string
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