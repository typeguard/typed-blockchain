// To parse this data:
//
//   const Convert = require("./file");
//
//   const latestBlock = Convert.toLatestBlock(json);
//   const unconfirmedTransactions = Convert.toUnconfirmedTransactions(json);
//
// These functions will throw an error if the JSON doesn't
// match the expected interface, even if the JSON is valid.

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
function toLatestBlock(json) {
    return cast(JSON.parse(json), o("LatestBlock"));
}

function latestBlockToJson(value) {
    return JSON.stringify(value, null, 2);
}

function toUnconfirmedTransactions(json) {
    return cast(JSON.parse(json), o("UnconfirmedTransactions"));
}

function unconfirmedTransactionsToJson(value) {
    return JSON.stringify(value, null, 2);
}

function cast(obj, typ) {
    if (!isValid(typ, obj)) {
        throw `Invalid value`;
    }
    return obj;
}

function isValid(typ, val) {
    if (typ === undefined) return true;
    if (typ === null) return val === null || val === undefined;
    return typ.isUnion  ? isValidUnion(typ.typs, val)
            : typ.isArray  ? isValidArray(typ.typ, val)
            : typ.isMap    ? isValidMap(typ.typ, val)
            : typ.isEnum   ? isValidEnum(typ.name, val)
            : typ.isObject ? isValidObject(typ.cls, val)
            :                isValidPrimitive(typ, val);
}

function isValidPrimitive(typ, val) {
    return typeof typ === typeof val;
}

function isValidUnion(typs, val) {
    // val must validate against one typ in typs
    return typs.find(typ => isValid(typ, val)) !== undefined;
}

function isValidEnum(enumName, val) {
    const cases = typeMap[enumName];
    return cases.indexOf(val) !== -1;
}

function isValidArray(typ, val) {
    // val must be an array with no invalid elements
    return Array.isArray(val) && val.every(element => {
        return isValid(typ, element);
    });
}

function isValidMap(typ, val) {
    if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
    // all values in the map must be typ
    return Object.keys(val).every(prop => {
        if (!Object.prototype.hasOwnProperty.call(val, prop)) return true;
        return isValid(typ, val[prop]);
    });
}

function isValidObject(className, val) {
    if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
    let typeRep = typeMap[className];
    return Object.keys(typeRep).every(prop => {
        if (!Object.prototype.hasOwnProperty.call(typeRep, prop)) return true;
        return isValid(typeRep[prop], val[prop]);
    });
}

function a(typ) {
    return { typ, isArray: true };
}

function e(name) {
    return { name, isEnum: true };
}

function u(...typs) {
    return { typs, isUnion: true };
}

function m(typ) {
    return { typ, isMap: true };
}

function o(className) {
    return { cls: className, isObject: true };
}

const typeMap = {
    "LatestBlock": {
        hash: "",
        time: 0,
        block_index: 0,
        height: 0,
        txIndexes: a(0),
    },
    "UnconfirmedTransactions": {
        txs: a(o("Tx")),
    },
    "Tx": {
        ver: 0,
        inputs: a(o("Input")),
        weight: 0,
        relayed_by: e("RelayedBy"),
        out: a(o("Out")),
        lock_time: 0,
        size: 0,
        rbf: u(null, false),
        double_spend: false,
        time: 0,
        tx_index: 0,
        vin_sz: 0,
        hash: "",
        vout_sz: 0,
    },
    "Input": {
        sequence: 0,
        witness: "",
        prev_out: o("Out"),
        script: "",
    },
    "Out": {
        spent: false,
        tx_index: 0,
        type: 0,
        addr: u(null, ""),
        value: 0,
        n: 0,
        script: "",
    },
    "RelayedBy": [
        "0.0.0.0",
        "127.0.0.1",
    ],
};

module.exports = {
    "latestBlockToJson": latestBlockToJson,
    "toLatestBlock": toLatestBlock,
    "unconfirmedTransactionsToJson": unconfirmedTransactionsToJson,
    "toUnconfirmedTransactions": toUnconfirmedTransactions,
};
