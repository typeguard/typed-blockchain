// To parse this JSON data, do
//
//     final latestBlock = latestBlockFromJson(jsonString);
//     final unconfirmedTransactions = unconfirmedTransactionsFromJson(jsonString);

import 'dart:convert';

LatestBlock latestBlockFromJson(String str) {
    final jsonData = json.decode(str);
    return LatestBlock.fromJson(jsonData);
}

String latestBlockToJson(LatestBlock data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

UnconfirmedTransactions unconfirmedTransactionsFromJson(String str) {
    final jsonData = json.decode(str);
    return UnconfirmedTransactions.fromJson(jsonData);
}

String unconfirmedTransactionsToJson(UnconfirmedTransactions data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class LatestBlock {
    String hash;
    int time;
    int blockIndex;
    int height;
    List<int> txIndexes;

    LatestBlock({
        this.hash,
        this.time,
        this.blockIndex,
        this.height,
        this.txIndexes,
    });

    factory LatestBlock.fromJson(Map<String, dynamic> json) => new LatestBlock(
        hash: json["hash"],
        time: json["time"],
        blockIndex: json["block_index"],
        height: json["height"],
        txIndexes: new List<int>.from(json["txIndexes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "hash": hash,
        "time": time,
        "block_index": blockIndex,
        "height": height,
        "txIndexes": new List<dynamic>.from(txIndexes.map((x) => x)),
    };
}

class UnconfirmedTransactions {
    List<Tx> txs;

    UnconfirmedTransactions({
        this.txs,
    });

    factory UnconfirmedTransactions.fromJson(Map<String, dynamic> json) => new UnconfirmedTransactions(
        txs: new List<Tx>.from(json["txs"].map((x) => Tx.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "txs": new List<dynamic>.from(txs.map((x) => x.toJson())),
    };
}

class Tx {
    int ver;
    List<Input> inputs;
    int weight;
    RelayedBy relayedBy;
    List<Out> out;
    int lockTime;
    int size;
    bool doubleSpend;
    int time;
    int txIndex;
    int vinSz;
    String hash;
    int voutSz;

    Tx({
        this.ver,
        this.inputs,
        this.weight,
        this.relayedBy,
        this.out,
        this.lockTime,
        this.size,
        this.doubleSpend,
        this.time,
        this.txIndex,
        this.vinSz,
        this.hash,
        this.voutSz,
    });

    factory Tx.fromJson(Map<String, dynamic> json) => new Tx(
        ver: json["ver"],
        inputs: new List<Input>.from(json["inputs"].map((x) => Input.fromJson(x))),
        weight: json["weight"],
        relayedBy: relayedByValues.map[json["relayed_by"]],
        out: new List<Out>.from(json["out"].map((x) => Out.fromJson(x))),
        lockTime: json["lock_time"],
        size: json["size"],
        doubleSpend: json["double_spend"],
        time: json["time"],
        txIndex: json["tx_index"],
        vinSz: json["vin_sz"],
        hash: json["hash"],
        voutSz: json["vout_sz"],
    );

    Map<String, dynamic> toJson() => {
        "ver": ver,
        "inputs": new List<dynamic>.from(inputs.map((x) => x.toJson())),
        "weight": weight,
        "relayed_by": relayedByValues.reverse[relayedBy],
        "out": new List<dynamic>.from(out.map((x) => x.toJson())),
        "lock_time": lockTime,
        "size": size,
        "double_spend": doubleSpend,
        "time": time,
        "tx_index": txIndex,
        "vin_sz": vinSz,
        "hash": hash,
        "vout_sz": voutSz,
    };
}

class Input {
    int sequence;
    String witness;
    Out prevOut;
    String script;

    Input({
        this.sequence,
        this.witness,
        this.prevOut,
        this.script,
    });

    factory Input.fromJson(Map<String, dynamic> json) => new Input(
        sequence: json["sequence"],
        witness: json["witness"],
        prevOut: Out.fromJson(json["prev_out"]),
        script: json["script"],
    );

    Map<String, dynamic> toJson() => {
        "sequence": sequence,
        "witness": witness,
        "prev_out": prevOut.toJson(),
        "script": script,
    };
}

class Out {
    bool spent;
    int txIndex;
    int type;
    String addr;
    int value;
    int n;
    String script;

    Out({
        this.spent,
        this.txIndex,
        this.type,
        this.addr,
        this.value,
        this.n,
        this.script,
    });

    factory Out.fromJson(Map<String, dynamic> json) => new Out(
        spent: json["spent"],
        txIndex: json["tx_index"],
        type: json["type"],
        addr: json["addr"] == null ? null : json["addr"],
        value: json["value"],
        n: json["n"],
        script: json["script"],
    );

    Map<String, dynamic> toJson() => {
        "spent": spent,
        "tx_index": txIndex,
        "type": type,
        "addr": addr == null ? null : addr,
        "value": value,
        "n": n,
        "script": script,
    };
}

enum RelayedBy { THE_0000, THE_127001 }

final relayedByValues = new EnumValues({
    "0.0.0.0": RelayedBy.THE_0000,
    "127.0.0.1": RelayedBy.THE_127001
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
