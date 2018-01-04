defmodule EsprezzoCore.Fabric.Schemas.Block do
  use Ecto.Schema
  # use Esprezzo.Makro.Questionable
  # use Esprezzo.Makro.Uniquely

  import Ecto.Changeset
  alias EsprezzoCore.Fabric.Schemas.Block

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "blocks" do
    field :previous_hash, :string, null: false
    field :timestamp, :integer
    field :chain_id, :string, null: false
    field :data, :string
    field :nonce, :integer
    field :hash, :string
    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [])
    |> validate_required([])
  end
end
