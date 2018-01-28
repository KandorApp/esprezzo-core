defmodule EsprezzoCore.Blockchain.Persistence.QueryMacros do
  @moduledoc"""
    # mostly macros attached to Schemas to make them
    # more "Familiar" to work with
  """
  alias EsprezzoCore.Repo
    # compiles into any db schema and adds functionality
    # add with use EsprezzoCore.QueryMacros
    defmacro __using__(_) do
      quote do
        import EsprezzoCore.Blockchain.Persistence.QueryMacros
        import Ecto.Query
  
        def all() do
          Repo.all(__MODULE__)
        end
  
        def last() do
          Repo.one(from x in __MODULE__, order_by: [desc: x.timestamp], limit: 1)
        end
  
        def first() do
          Repo.one(from x in __MODULE__, order_by: [asc: x.timestamp], limit: 1)
        end
  
        def count() do
          Enum.count(Repo.all(__MODULE__))
        end
  
        # def find(uuid) do
        # end
  
      end # END QUOTE
  
    end
  
  end
  