// To parse this data:
//
//   import { Convert, LatestBlock, UnconfirmedTransactions } from "./file";
//
//   const latestBlock = Convert.toLatestBlock(json);
//   const unconfirmedTransactions = Convert.toUnconfirmedTransactions(json);
//
// These functions will throw an error if the JSON doesn't
// match the expected interface, even if the JSON is valid.

export interface LatestBlock {
    hash:        string;
    time:        number;
    block_index: number;
    height:      number;
    txIndexes:   number[];
}

export interface UnconfirmedTransactions {
    txs: Tx[];
}

export interface Tx {
    ver:          number;
    inputs:       Input[];
    weight:       number;
    relayed_by:   RelayedBy;
    out:          Out[];
    lock_time:    number;
    size:         number;
    rbf?:         boolean;
    double_spend: boolean;
    time:         number;
    tx_index:     number;
    vin_sz:       number;
    hash:         string;
    vout_sz:      number;
}

export interface Input {
    sequence: number;
    witness:  Witness;
    prev_out: Out;
    script:   string;
}

export interface Out {
    spent:    boolean;
    tx_index: number;
    type:     number;
    addr:     string;
    value:    number;
    n:        number;
    script:   string;
}

export enum Witness {
    Empty = "",
}

export enum RelayedBy {
    The0000 = "0.0.0.0",
    The127001 = "127.0.0.1",
}

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
export module Convert {
    export function toLatestBlock(json: string): LatestBlock {
        return cast(JSON.parse(json), O("LatestBlock"));
    }

    export function latestBlockToJson(value: LatestBlock): string {
        return JSON.stringify(value, null, 2);
    }

    export function toUnconfirmedTransactions(json: string): UnconfirmedTransactions {
        return cast(JSON.parse(json), O("UnconfirmedTransactions"));
    }

    export function unconfirmedTransactionsToJson(value: UnconfirmedTransactions): string {
        return JSON.stringify(value, null, 2);
    }
    
    function cast<T>(obj: any, typ: any): T {
        if (!isValid(typ, obj)) {
            throw `Invalid value`;
        }
        return obj;
    }

    function isValid(typ: any, val: any): boolean {
        if (typ === undefined) return true;
        if (typ === null) return val === null || val === undefined;
        return typ.isUnion  ? isValidUnion(typ.typs, val)
                : typ.isArray  ? isValidArray(typ.typ, val)
                : typ.isMap    ? isValidMap(typ.typ, val)
                : typ.isEnum   ? isValidEnum(typ.name, val)
                : typ.isObject ? isValidObject(typ.cls, val)
                :                isValidPrimitive(typ, val);
    }

    function isValidPrimitive(typ: string, val: any) {
        return typeof typ === typeof val;
    }

    function isValidUnion(typs: any[], val: any): boolean {
        // val must validate against one typ in typs
        return typs.find(typ => isValid(typ, val)) !== undefined;
    }

    function isValidEnum(enumName: string, val: any): boolean {
        const cases = typeMap[enumName];
        return cases.indexOf(val) !== -1;
    }

    function isValidArray(typ: any, val: any): boolean {
        // val must be an array with no invalid elements
        return Array.isArray(val) && val.every((element, i) => {
            return isValid(typ, element);
        });
    }

    function isValidMap(typ: any, val: any): boolean {
        if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
        // all values in the map must be typ
        return Object.keys(val).every(prop => {
            if (!Object.prototype.hasOwnProperty.call(val, prop)) return true;
            return isValid(typ, val[prop]);
        });
    }

    function isValidObject(className: string, val: any): boolean {
        if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
        let typeRep = typeMap[className];
        return Object.keys(typeRep).every(prop => {
            if (!Object.prototype.hasOwnProperty.call(typeRep, prop)) return true;
            return isValid(typeRep[prop], val[prop]);
        });
    }

    function A(typ: any) {
        return { typ, isArray: true };
    }

    function E(name: string) {
        return { name, isEnum: true };
    }

    function U(...typs: any[]) {
        return { typs, isUnion: true };
    }

    function M(typ: any) {
        return { typ, isMap: true };
    }

    function O(className: string) {
        return { cls: className, isObject: true };
    }

    const typeMap: any = {
        "LatestBlock": {
            hash: "",
            time: 0,
            block_index: 0,
            height: 0,
            txIndexes: A(0),
        },
        "UnconfirmedTransactions": {
            txs: A(O("Tx")),
        },
        "Tx": {
            ver: 0,
            inputs: A(O("Input")),
            weight: 0,
            relayed_by: E("RelayedBy"),
            out: A(O("Out")),
            lock_time: 0,
            size: 0,
            rbf: U(null, false),
            double_spend: false,
            time: 0,
            tx_index: 0,
            vin_sz: 0,
            hash: "",
            vout_sz: 0,
        },
        "Input": {
            sequence: 0,
            witness: E("Witness"),
            prev_out: O("Out"),
            script: "",
        },
        "Out": {
            spent: false,
            tx_index: 0,
            type: 0,
            addr: "",
            value: 0,
            n: 0,
            script: "",
        },
        "Witness": [
            Witness.Empty,
        ],
        "RelayedBy": [
            RelayedBy.The0000,
            RelayedBy.The127001,
        ],
    };
}
