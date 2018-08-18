-- To decode the JSON data, add this file to your project, run
--
--     elm-package install NoRedInk/elm-decode-pipeline
--
-- add these imports
--
--     import Json.Decode exposing (decodeString)`);
--     import QuickType exposing (latestBlock, unconfirmedTransactions)
--
-- and you're off to the races with
--
--     decodeString latestBlock myJsonString
--     decodeString unconfirmedTransactions myJsonString

module QuickType exposing
    ( LatestBlock
    , latestBlockToString
    , latestBlock
    , UnconfirmedTransactions
    , unconfirmedTransactionsToString
    , unconfirmedTransactions
    , Tx
    , Input
    , Out
    , RelayedBy(..)
    )

import Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Dict exposing (Dict, map, toList)
import Array exposing (Array, map)

type alias LatestBlock =
    { hash : String
    , time : Int
    , blockIndex : Int
    , height : Int
    , txIndexes : Array Int
    }

type alias UnconfirmedTransactions =
    { txs : Array Tx
    }

type alias Tx =
    { ver : Int
    , inputs : Array Input
    , weight : Int
    , relayedBy : RelayedBy
    , out : Array Out
    , lockTime : Int
    , size : Int
    , doubleSpend : Bool
    , time : Int
    , txIndex : Int
    , vinSz : Int
    , hash : String
    , voutSz : Int
    }

type alias Input =
    { sequence : Int
    , witness : String
    , prevOut : Out
    , script : String
    }

type alias Out =
    { spent : Bool
    , txIndex : Int
    , outType : Int
    , addr : Maybe String
    , value : Int
    , n : Int
    , script : String
    }

type RelayedBy
    = The0000
    | The127001

-- decoders and encoders

latestBlockToString : LatestBlock -> String
latestBlockToString r = Jenc.encode 0 (encodeLatestBlock r)

unconfirmedTransactionsToString : UnconfirmedTransactions -> String
unconfirmedTransactionsToString r = Jenc.encode 0 (encodeUnconfirmedTransactions r)

latestBlock : Jdec.Decoder LatestBlock
latestBlock =
    Jpipe.decode LatestBlock
        |> Jpipe.required "hash" Jdec.string
        |> Jpipe.required "time" Jdec.int
        |> Jpipe.required "block_index" Jdec.int
        |> Jpipe.required "height" Jdec.int
        |> Jpipe.required "txIndexes" (Jdec.array Jdec.int)

encodeLatestBlock : LatestBlock -> Jenc.Value
encodeLatestBlock x =
    Jenc.object
        [ ("hash", Jenc.string x.hash)
        , ("time", Jenc.int x.time)
        , ("block_index", Jenc.int x.blockIndex)
        , ("height", Jenc.int x.height)
        , ("txIndexes", makeArrayEncoder Jenc.int x.txIndexes)
        ]

unconfirmedTransactions : Jdec.Decoder UnconfirmedTransactions
unconfirmedTransactions =
    Jpipe.decode UnconfirmedTransactions
        |> Jpipe.required "txs" (Jdec.array tx)

encodeUnconfirmedTransactions : UnconfirmedTransactions -> Jenc.Value
encodeUnconfirmedTransactions x =
    Jenc.object
        [ ("txs", makeArrayEncoder encodeTx x.txs)
        ]

tx : Jdec.Decoder Tx
tx =
    Jpipe.decode Tx
        |> Jpipe.required "ver" Jdec.int
        |> Jpipe.required "inputs" (Jdec.array input)
        |> Jpipe.required "weight" Jdec.int
        |> Jpipe.required "relayed_by" relayedBy
        |> Jpipe.required "out" (Jdec.array out)
        |> Jpipe.required "lock_time" Jdec.int
        |> Jpipe.required "size" Jdec.int
        |> Jpipe.required "double_spend" Jdec.bool
        |> Jpipe.required "time" Jdec.int
        |> Jpipe.required "tx_index" Jdec.int
        |> Jpipe.required "vin_sz" Jdec.int
        |> Jpipe.required "hash" Jdec.string
        |> Jpipe.required "vout_sz" Jdec.int

encodeTx : Tx -> Jenc.Value
encodeTx x =
    Jenc.object
        [ ("ver", Jenc.int x.ver)
        , ("inputs", makeArrayEncoder encodeInput x.inputs)
        , ("weight", Jenc.int x.weight)
        , ("relayed_by", encodeRelayedBy x.relayedBy)
        , ("out", makeArrayEncoder encodeOut x.out)
        , ("lock_time", Jenc.int x.lockTime)
        , ("size", Jenc.int x.size)
        , ("double_spend", Jenc.bool x.doubleSpend)
        , ("time", Jenc.int x.time)
        , ("tx_index", Jenc.int x.txIndex)
        , ("vin_sz", Jenc.int x.vinSz)
        , ("hash", Jenc.string x.hash)
        , ("vout_sz", Jenc.int x.voutSz)
        ]

input : Jdec.Decoder Input
input =
    Jpipe.decode Input
        |> Jpipe.required "sequence" Jdec.int
        |> Jpipe.required "witness" Jdec.string
        |> Jpipe.required "prev_out" out
        |> Jpipe.required "script" Jdec.string

encodeInput : Input -> Jenc.Value
encodeInput x =
    Jenc.object
        [ ("sequence", Jenc.int x.sequence)
        , ("witness", Jenc.string x.witness)
        , ("prev_out", encodeOut x.prevOut)
        , ("script", Jenc.string x.script)
        ]

out : Jdec.Decoder Out
out =
    Jpipe.decode Out
        |> Jpipe.required "spent" Jdec.bool
        |> Jpipe.required "tx_index" Jdec.int
        |> Jpipe.required "type" Jdec.int
        |> Jpipe.optional "addr" (Jdec.nullable Jdec.string) Nothing
        |> Jpipe.required "value" Jdec.int
        |> Jpipe.required "n" Jdec.int
        |> Jpipe.required "script" Jdec.string

encodeOut : Out -> Jenc.Value
encodeOut x =
    Jenc.object
        [ ("spent", Jenc.bool x.spent)
        , ("tx_index", Jenc.int x.txIndex)
        , ("type", Jenc.int x.outType)
        , ("addr", makeNullableEncoder Jenc.string x.addr)
        , ("value", Jenc.int x.value)
        , ("n", Jenc.int x.n)
        , ("script", Jenc.string x.script)
        ]

relayedBy : Jdec.Decoder RelayedBy
relayedBy =
    Jdec.string
        |> Jdec.andThen (\str ->
            case str of
                "0.0.0.0" -> Jdec.succeed The0000
                "127.0.0.1" -> Jdec.succeed The127001
                somethingElse -> Jdec.fail <| "Invalid RelayedBy: " ++ somethingElse
        )

encodeRelayedBy : RelayedBy -> Jenc.Value
encodeRelayedBy x = case x of
    The0000 -> Jenc.string "0.0.0.0"
    The127001 -> Jenc.string "127.0.0.1"

--- encoder helpers

makeArrayEncoder : (a -> Jenc.Value) -> Array a -> Jenc.Value
makeArrayEncoder f arr =
    Jenc.array (Array.map f arr)

makeDictEncoder : (a -> Jenc.Value) -> Dict String a -> Jenc.Value
makeDictEncoder f dict =
    Jenc.object (toList (Dict.map (\k -> f) dict))

makeNullableEncoder : (a -> Jenc.Value) -> Maybe a -> Jenc.Value
makeNullableEncoder f m =
    case m of
    Just x -> f x
    Nothing -> Jenc.null
