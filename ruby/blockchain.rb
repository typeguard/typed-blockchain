# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   latest_block = LatestBlock.from_json! "{…}"
#   puts latest_block.tx_indexes.first.even?
#
#   unconfirmed_transactions = UnconfirmedTransactions.from_json! "{…}"
#   puts unconfirmed_transactions.txs.first.out.first.spent
#
# If from_json! succeeds, the value returned matches the schema.

require 'json'
require 'dry-types'
require 'dry-struct'

module Types
  include Dry::Types.module

  Int       = Strict::Int
  Bool      = Strict::Bool
  Hash      = Strict::Hash
  String    = Strict::String
  RelayedBy = Strict::String.enum("0.0.0.0", "127.0.0.1")
end

class LatestBlock < Dry::Struct
  attribute :latest_block_hash, Types::String
  attribute :time,              Types::Int
  attribute :block_index,       Types::Int
  attribute :height,            Types::Int
  attribute :tx_indexes,        Types.Array(Types::Int)

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      latest_block_hash: d.fetch("hash"),
      time:              d.fetch("time"),
      block_index:       d.fetch("block_index"),
      height:            d.fetch("height"),
      tx_indexes:        d.fetch("txIndexes"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "hash"        => @latest_block_hash,
      "time"        => @time,
      "block_index" => @block_index,
      "height"      => @height,
      "txIndexes"   => @tx_indexes,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Out < Dry::Struct
  attribute :spent,    Types::Bool
  attribute :tx_index, Types::Int
  attribute :out_type, Types::Int
  attribute :addr,     Types::String.optional
  attribute :value,    Types::Int
  attribute :n,        Types::Int
  attribute :script,   Types::String

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      spent:    d.fetch("spent"),
      tx_index: d.fetch("tx_index"),
      out_type: d.fetch("type"),
      addr:     d["addr"],
      value:    d.fetch("value"),
      n:        d.fetch("n"),
      script:   d.fetch("script"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "spent"    => @spent,
      "tx_index" => @tx_index,
      "type"     => @out_type,
      "addr"     => @addr,
      "value"    => @value,
      "n"        => @n,
      "script"   => @script,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Input < Dry::Struct
  attribute :sequence, Types::Int
  attribute :witness,  Types::String
  attribute :prev_out, Out
  attribute :script,   Types::String

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      sequence: d.fetch("sequence"),
      witness:  d.fetch("witness"),
      prev_out: Out.from_dynamic!(d.fetch("prev_out")),
      script:   d.fetch("script"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "sequence" => @sequence,
      "witness"  => @witness,
      "prev_out" => @prev_out.to_dynamic,
      "script"   => @script,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

module RelayedBy
  The0000   = "0.0.0.0"
  The127001 = "127.0.0.1"
end

class Tx < Dry::Struct
  attribute :ver,          Types::Int
  attribute :inputs,       Types.Array(Input)
  attribute :weight,       Types::Int
  attribute :relayed_by,   Types::RelayedBy
  attribute :out,          Types.Array(Out)
  attribute :lock_time,    Types::Int
  attribute :size,         Types::Int
  attribute :double_spend, Types::Bool
  attribute :time,         Types::Int
  attribute :tx_index,     Types::Int
  attribute :vin_sz,       Types::Int
  attribute :tx_hash,      Types::String
  attribute :vout_sz,      Types::Int

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      ver:          d.fetch("ver"),
      inputs:       d.fetch("inputs").map { |x| Input.from_dynamic!(x) },
      weight:       d.fetch("weight"),
      relayed_by:   d.fetch("relayed_by"),
      out:          d.fetch("out").map { |x| Out.from_dynamic!(x) },
      lock_time:    d.fetch("lock_time"),
      size:         d.fetch("size"),
      double_spend: d.fetch("double_spend"),
      time:         d.fetch("time"),
      tx_index:     d.fetch("tx_index"),
      vin_sz:       d.fetch("vin_sz"),
      tx_hash:      d.fetch("hash"),
      vout_sz:      d.fetch("vout_sz"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "ver"          => @ver,
      "inputs"       => @inputs.map { |x| x.to_dynamic },
      "weight"       => @weight,
      "relayed_by"   => @relayed_by,
      "out"          => @out.map { |x| x.to_dynamic },
      "lock_time"    => @lock_time,
      "size"         => @size,
      "double_spend" => @double_spend,
      "time"         => @time,
      "tx_index"     => @tx_index,
      "vin_sz"       => @vin_sz,
      "hash"         => @tx_hash,
      "vout_sz"      => @vout_sz,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class UnconfirmedTransactions < Dry::Struct
  attribute :txs, Types.Array(Tx)

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      txs: d.fetch("txs").map { |x| Tx.from_dynamic!(x) },
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "txs" => @txs.map { |x| x.to_dynamic },
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end
