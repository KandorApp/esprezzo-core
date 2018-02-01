defmodule EsprezzoCore.BlockChain.Settlement.TransactionValidator do
  require IEx
  require Logger

  alias EsprezzoCore.Blockchain.Settlment.Transactions
  alias EsprezzoCore.BlockChain.Settlement.Structs.Transaction

  @doc """
  Validate a Settlement Ledger block 
  Current Conditions
  EsprezzoCore.BlockChain.Settlement.TransactionValidator.validate(block)
  """
  @spec is_valid?(Transaction.t()) :: Boolean
  def is_valid?(txn) do
    with computed_hash <- Transactions.hash_transaction(txn),
      true <- hash_is_valid?(txn, computed_hash),
      true <- inputs_are_valid?(txn),
      true <- outputs_are_valid?(txn),
      true <- scripts_are_valid?(txn),
      do: true
  end

  @spec inputs_are_valid?(Transaction.t()) :: Boolean
  def inputs_are_valid?(txn) do
    # does the txid exist?
    # does the index exist? 
    # check script_sig elements
    true
  end

  @spec outputs_are_valid?(Transaction.t()) :: Boolean
  def outputs_are_valid?(txn) do
    # does this match the avail inputs? :val
    # :locking_contract is this valid?
    true
  end

  @spec scripts_are_valid?(Transaction.t()) :: Boolean
  def scripts_are_valid?(txn) do
    # does this match the avail inputs? :val
    # :locking_contract is this valid?
    true
  end

  @doc """
    Rehashes txn to make sure the embedded txid is correct 
  """
  @spec hash_is_valid?(Block.t, String.t) :: Boolean.t
  defp hash_is_valid?(txn, computed_hash) do
    case computed_hash == txn.txid do
      true ->
        Logger.warn "txn hash is valid"
        true
      false -> 
        Logger.error "txn hash is not valid"
        false
    end
  end
 
end