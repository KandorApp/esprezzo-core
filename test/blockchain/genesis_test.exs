defmodule EsprezzoCore.GenesisTest do
  
  use ExUnit.Case
  use EsprezzoCoreWeb.ConnCase
  require IEx

  alias EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis
  alias EsprezzoCore.BlockChain.Settlement.TransactionValidator
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Settlment.Transactions
  
  test "genesis block hash validates" do
    gb = Genesis.genesis_block_template()
    assert BlockValidator.is_valid?(gb)
  end

  test "genesis txn hash validates" do
    gb = Genesis.genesis_block_template()
    txn = gb.txns |> List.first
    assert Transactions.hash_transaction(txn) == txn.txid
  end

  test "genesis txn merkle root validates" do
    genblock = Genesis.genesis_block_template()
    root = Transactions.compute_transactions_merkle_root(genblock)
    assert root == genblock.header.txns_merkle_root
  end

  test "transaction validators succeed on genesis block" do
    genblock = Genesis.genesis_block_template()
    txn = genblock.txns |> List.first
    assert TransactionValidator.is_valid?(txn)
  end

  test "genesis block saves and returns" do
    gb = EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis.reinitialize()
    IEx.pry
    assert false
  end


end