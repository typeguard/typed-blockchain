# To use this code, make sure you
#
#     import json
#
# and then, to convert JSON from a string, do
#
#     result = latest_block_from_dict(json.loads(json_string))
#     result = unconfirmed_transactions_from_dict(json.loads(json_string))

from typing import List, Any, Optional, TypeVar, Callable, Type, cast
from enum import Enum


T = TypeVar("T")
EnumT = TypeVar("EnumT", bound=Enum)


def from_str(x: Any) -> str:
    assert isinstance(x, str)
    return x


def from_int(x: Any) -> int:
    assert isinstance(x, int) and not isinstance(x, bool)
    return x


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def from_bool(x: Any) -> bool:
    assert isinstance(x, bool)
    return x


def from_none(x: Any) -> Any:
    assert x is None
    return x


def from_union(fs, x):
    for f in fs:
        try:
            return f(x)
        except:
            pass
    assert False


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


def to_enum(c: Type[EnumT], x: Any) -> EnumT:
    assert isinstance(x, c)
    return x.value


class LatestBlock:
    hash: str
    time: int
    block_index: int
    height: int
    tx_indexes: List[int]

    def __init__(self, hash: str, time: int, block_index: int, height: int, tx_indexes: List[int]) -> None:
        self.hash = hash
        self.time = time
        self.block_index = block_index
        self.height = height
        self.tx_indexes = tx_indexes

    @staticmethod
    def from_dict(obj: Any) -> 'LatestBlock':
        assert isinstance(obj, dict)
        hash = from_str(obj.get("hash"))
        time = from_int(obj.get("time"))
        block_index = from_int(obj.get("block_index"))
        height = from_int(obj.get("height"))
        tx_indexes = from_list(from_int, obj.get("txIndexes"))
        return LatestBlock(hash, time, block_index, height, tx_indexes)

    def to_dict(self) -> dict:
        result: dict = {}
        result["hash"] = from_str(self.hash)
        result["time"] = from_int(self.time)
        result["block_index"] = from_int(self.block_index)
        result["height"] = from_int(self.height)
        result["txIndexes"] = from_list(from_int, self.tx_indexes)
        return result


class Out:
    spent: bool
    tx_index: int
    type: int
    addr: Optional[str]
    value: int
    n: int
    script: str

    def __init__(self, spent: bool, tx_index: int, type: int, addr: Optional[str], value: int, n: int, script: str) -> None:
        self.spent = spent
        self.tx_index = tx_index
        self.type = type
        self.addr = addr
        self.value = value
        self.n = n
        self.script = script

    @staticmethod
    def from_dict(obj: Any) -> 'Out':
        assert isinstance(obj, dict)
        spent = from_bool(obj.get("spent"))
        tx_index = from_int(obj.get("tx_index"))
        type = from_int(obj.get("type"))
        addr = from_union([from_str, from_none], obj.get("addr"))
        value = from_int(obj.get("value"))
        n = from_int(obj.get("n"))
        script = from_str(obj.get("script"))
        return Out(spent, tx_index, type, addr, value, n, script)

    def to_dict(self) -> dict:
        result: dict = {}
        result["spent"] = from_bool(self.spent)
        result["tx_index"] = from_int(self.tx_index)
        result["type"] = from_int(self.type)
        result["addr"] = from_union([from_str, from_none], self.addr)
        result["value"] = from_int(self.value)
        result["n"] = from_int(self.n)
        result["script"] = from_str(self.script)
        return result


class Input:
    sequence: int
    witness: str
    prev_out: Out
    script: str

    def __init__(self, sequence: int, witness: str, prev_out: Out, script: str) -> None:
        self.sequence = sequence
        self.witness = witness
        self.prev_out = prev_out
        self.script = script

    @staticmethod
    def from_dict(obj: Any) -> 'Input':
        assert isinstance(obj, dict)
        sequence = from_int(obj.get("sequence"))
        witness = from_str(obj.get("witness"))
        prev_out = Out.from_dict(obj.get("prev_out"))
        script = from_str(obj.get("script"))
        return Input(sequence, witness, prev_out, script)

    def to_dict(self) -> dict:
        result: dict = {}
        result["sequence"] = from_int(self.sequence)
        result["witness"] = from_str(self.witness)
        result["prev_out"] = to_class(Out, self.prev_out)
        result["script"] = from_str(self.script)
        return result


class RelayedBy(Enum):
    THE_0000 = "0.0.0.0"
    THE_127001 = "127.0.0.1"


class Tx:
    ver: int
    inputs: List[Input]
    weight: int
    relayed_by: RelayedBy
    out: List[Out]
    lock_time: int
    size: int
    double_spend: bool
    time: int
    tx_index: int
    vin_sz: int
    hash: str
    vout_sz: int

    def __init__(self, ver: int, inputs: List[Input], weight: int, relayed_by: RelayedBy, out: List[Out], lock_time: int, size: int, double_spend: bool, time: int, tx_index: int, vin_sz: int, hash: str, vout_sz: int) -> None:
        self.ver = ver
        self.inputs = inputs
        self.weight = weight
        self.relayed_by = relayed_by
        self.out = out
        self.lock_time = lock_time
        self.size = size
        self.double_spend = double_spend
        self.time = time
        self.tx_index = tx_index
        self.vin_sz = vin_sz
        self.hash = hash
        self.vout_sz = vout_sz

    @staticmethod
    def from_dict(obj: Any) -> 'Tx':
        assert isinstance(obj, dict)
        ver = from_int(obj.get("ver"))
        inputs = from_list(Input.from_dict, obj.get("inputs"))
        weight = from_int(obj.get("weight"))
        relayed_by = RelayedBy(obj.get("relayed_by"))
        out = from_list(Out.from_dict, obj.get("out"))
        lock_time = from_int(obj.get("lock_time"))
        size = from_int(obj.get("size"))
        double_spend = from_bool(obj.get("double_spend"))
        time = from_int(obj.get("time"))
        tx_index = from_int(obj.get("tx_index"))
        vin_sz = from_int(obj.get("vin_sz"))
        hash = from_str(obj.get("hash"))
        vout_sz = from_int(obj.get("vout_sz"))
        return Tx(ver, inputs, weight, relayed_by, out, lock_time, size, double_spend, time, tx_index, vin_sz, hash, vout_sz)

    def to_dict(self) -> dict:
        result: dict = {}
        result["ver"] = from_int(self.ver)
        result["inputs"] = from_list(lambda x: to_class(Input, x), self.inputs)
        result["weight"] = from_int(self.weight)
        result["relayed_by"] = to_enum(RelayedBy, self.relayed_by)
        result["out"] = from_list(lambda x: to_class(Out, x), self.out)
        result["lock_time"] = from_int(self.lock_time)
        result["size"] = from_int(self.size)
        result["double_spend"] = from_bool(self.double_spend)
        result["time"] = from_int(self.time)
        result["tx_index"] = from_int(self.tx_index)
        result["vin_sz"] = from_int(self.vin_sz)
        result["hash"] = from_str(self.hash)
        result["vout_sz"] = from_int(self.vout_sz)
        return result


class UnconfirmedTransactions:
    txs: List[Tx]

    def __init__(self, txs: List[Tx]) -> None:
        self.txs = txs

    @staticmethod
    def from_dict(obj: Any) -> 'UnconfirmedTransactions':
        assert isinstance(obj, dict)
        txs = from_list(Tx.from_dict, obj.get("txs"))
        return UnconfirmedTransactions(txs)

    def to_dict(self) -> dict:
        result: dict = {}
        result["txs"] = from_list(lambda x: to_class(Tx, x), self.txs)
        return result


def latest_block_from_dict(s: Any) -> LatestBlock:
    return LatestBlock.from_dict(s)


def latest_block_to_dict(x: LatestBlock) -> Any:
    return to_class(LatestBlock, x)


def unconfirmed_transactions_from_dict(s: Any) -> UnconfirmedTransactions:
    return UnconfirmedTransactions.from_dict(s)


def unconfirmed_transactions_to_dict(x: UnconfirmedTransactions) -> Any:
    return to_class(UnconfirmedTransactions, x)
