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
    return cast(JSON.parse(json), r("LatestBlock"));
}

function latestBlockToJson(value) {
    return JSON.stringify(uncast(value, r("LatestBlock")), null, 2);
}

function toUnconfirmedTransactions(json) {
    return cast(JSON.parse(json), r("UnconfirmedTransactions"));
}

function unconfirmedTransactionsToJson(value) {
    return JSON.stringify(uncast(value, r("UnconfirmedTransactions")), null, 2);
}

function invalidValue(typ, val) {
    throw Error(`Invalid value ${JSON.stringify(val)} for type ${JSON.stringify(typ)}`);
}

function jsonToJSProps(typ) {
    if (typ.jsonToJS === undefined) {
        var map = {};
        typ.props.forEach((p) => map[p.json] = { key: p.js, typ: p.typ });
        typ.jsonToJS = map;
    }
    return typ.jsonToJS;
}

function jsToJSONProps(typ) {
    if (typ.jsToJSON === undefined) {
        var map = {};
        typ.props.forEach((p) => map[p.js] = { key: p.json, typ: p.typ });
        typ.jsToJSON = map;
    }
    return typ.jsToJSON;
}

function transform(val, typ, getProps) {
    function transformPrimitive(typ, val) {
        if (typeof typ === typeof val) return val;
        return invalidValue(typ, val);
    }

    function transformUnion(typs, val) {
        // val must validate against one typ in typs
        var l = typs.length;
        for (var i = 0; i < l; i++) {
            var typ = typs[i];
            try {
                return transform(val, typ, getProps);
            } catch (_) {}
        }
        return invalidValue(typs, val);
    }

    function transformEnum(cases, val) {
        if (cases.indexOf(val) !== -1) return val;
        return invalidValue(cases, val);
    }

    function transformArray(typ, val) {
        // val must be an array with no invalid elements
        if (!Array.isArray(val)) return invalidValue("array", val);
        return val.map(el => transform(el, typ, getProps));
    }

    function transformObject(props, additional, val) {
        if (val === null || typeof val !== "object" || Array.isArray(val)) {
            return invalidValue("object", val);
        }
        var result = {};
        Object.getOwnPropertyNames(props).forEach(key => {
            const prop = props[key];
            const v = Object.prototype.hasOwnProperty.call(val, key) ? val[key] : undefined;
            result[prop.key] = transform(v, prop.typ, getProps);
        });
        Object.getOwnPropertyNames(val).forEach(key => {
            if (!Object.prototype.hasOwnProperty.call(props, key)) {
                result[key] = transform(val[key], additional, getProps);
            }
        });
        return result;
    }

    if (typ === "any") return val;
    if (typ === null) {
        if (val === null) return val;
        return invalidValue(typ, val);
    }
    if (typ === false) return invalidValue(typ, val);
    while (typeof typ === "object" && typ.ref !== undefined) {
        typ = typeMap[typ.ref];
    }
    if (Array.isArray(typ)) return transformEnum(typ, val);
    if (typeof typ === "object") {
        return typ.hasOwnProperty("unionMembers") ? transformUnion(typ.unionMembers, val)
            : typ.hasOwnProperty("arrayItems")    ? transformArray(typ.arrayItems, val)
            : typ.hasOwnProperty("props")         ? transformObject(getProps(typ), typ.additional, val)
            : invalidValue(typ, val);
    }
    return transformPrimitive(typ, val);
}

function cast(val, typ) {
    return transform(val, typ, jsonToJSProps);
}

function uncast(val, typ) {
    return transform(val, typ, jsToJSONProps);
}

function a(typ) {
    return { arrayItems: typ };
}

function u(...typs) {
    return { unionMembers: typs };
}

function o(props, additional) {
    return { props, additional };
}

function m(additional) {
    return { props: [], additional };
}

function r(name) {
    return { ref: name };
}

const typeMap = {
    "LatestBlock": o([
        { json: "hash", js: "hash", typ: "" },
        { json: "time", js: "time", typ: 0 },
        { json: "block_index", js: "block_index", typ: 0 },
        { json: "height", js: "height", typ: 0 },
        { json: "txIndexes", js: "txIndexes", typ: a(0) },
    ], false),
    "UnconfirmedTransactions": o([
        { json: "txs", js: "txs", typ: a(r("Tx")) },
    ], false),
    "Tx": o([
        { json: "ver", js: "ver", typ: 0 },
        { json: "inputs", js: "inputs", typ: a(r("Input")) },
        { json: "weight", js: "weight", typ: 0 },
        { json: "relayed_by", js: "relayed_by", typ: r("RelayedBy") },
        { json: "out", js: "out", typ: a(r("Out")) },
        { json: "lock_time", js: "lock_time", typ: 0 },
        { json: "size", js: "size", typ: 0 },
        { json: "double_spend", js: "double_spend", typ: true },
        { json: "time", js: "time", typ: 0 },
        { json: "tx_index", js: "tx_index", typ: 0 },
        { json: "vin_sz", js: "vin_sz", typ: 0 },
        { json: "hash", js: "hash", typ: "" },
        { json: "vout_sz", js: "vout_sz", typ: 0 },
    ], false),
    "Input": o([
        { json: "sequence", js: "sequence", typ: 0 },
        { json: "witness", js: "witness", typ: "" },
        { json: "prev_out", js: "prev_out", typ: r("Out") },
        { json: "script", js: "script", typ: "" },
    ], false),
    "Out": o([
        { json: "spent", js: "spent", typ: true },
        { json: "tx_index", js: "tx_index", typ: 0 },
        { json: "type", js: "type", typ: 0 },
        { json: "addr", js: "addr", typ: u(undefined, "") },
        { json: "value", js: "value", typ: 0 },
        { json: "n", js: "n", typ: 0 },
        { json: "script", js: "script", typ: "" },
    ], false),
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
