defmodule EsprezzoCore.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do

      timestamps()
    end

  end
end
