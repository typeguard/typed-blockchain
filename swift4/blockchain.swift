// To parse the JSON, add this file to your project and do:
//
//   let latestBlock = try LatestBlock(json)
//   let unconfirmedTransactions = try UnconfirmedTransactions(json)

import Foundation

struct LatestBlock: Codable {
    let hash: String
    let time, blockIndex, height: Int
    let txIndexes: [Int]

    enum CodingKeys: String, CodingKey {
        case hash, time
        case blockIndex = "block_index"
        case height, txIndexes
    }
}

struct UnconfirmedTransactions: Codable {
    let txs: [Tx]
}

struct Tx: Codable {
    let ver: Int
    let inputs: [Input]
    let weight: Int
    let relayedBy: RelayedBy
    let out: [Out]
    let lockTime, size: Int
    let doubleSpend: Bool
    let time, txIndex, vinSz: Int
    let hash: String
    let voutSz: Int

    enum CodingKeys: String, CodingKey {
        case ver, inputs, weight
        case relayedBy = "relayed_by"
        case out
        case lockTime = "lock_time"
        case size
        case doubleSpend = "double_spend"
        case time
        case txIndex = "tx_index"
        case vinSz = "vin_sz"
        case hash
        case voutSz = "vout_sz"
    }
}

struct Input: Codable {
    let sequence: Int
    let witness: String
    let prevOut: Out
    let script: String

    enum CodingKeys: String, CodingKey {
        case sequence, witness
        case prevOut = "prev_out"
        case script
    }
}

struct Out: Codable {
    let spent: Bool
    let txIndex, type: Int
    let addr: String?
    let value, n: Int
    let script: String

    enum CodingKeys: String, CodingKey {
        case spent
        case txIndex = "tx_index"
        case type, addr, value, n, script
    }
}

enum RelayedBy: String, Codable {
    case the0000 = "0.0.0.0"
    case the127001 = "127.0.0.1"
}

// MARK: Convenience initializers and mutators

extension LatestBlock {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LatestBlock.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        hash: String? = nil,
        time: Int? = nil,
        blockIndex: Int? = nil,
        height: Int? = nil,
        txIndexes: [Int]? = nil
    ) -> LatestBlock {
        return LatestBlock(
            hash: hash ?? self.hash,
            time: time ?? self.time,
            blockIndex: blockIndex ?? self.blockIndex,
            height: height ?? self.height,
            txIndexes: txIndexes ?? self.txIndexes
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UnconfirmedTransactions {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UnconfirmedTransactions.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        txs: [Tx]? = nil
    ) -> UnconfirmedTransactions {
        return UnconfirmedTransactions(
            txs: txs ?? self.txs
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Tx {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Tx.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        ver: Int? = nil,
        inputs: [Input]? = nil,
        weight: Int? = nil,
        relayedBy: RelayedBy? = nil,
        out: [Out]? = nil,
        lockTime: Int? = nil,
        size: Int? = nil,
        doubleSpend: Bool? = nil,
        time: Int? = nil,
        txIndex: Int? = nil,
        vinSz: Int? = nil,
        hash: String? = nil,
        voutSz: Int? = nil
    ) -> Tx {
        return Tx(
            ver: ver ?? self.ver,
            inputs: inputs ?? self.inputs,
            weight: weight ?? self.weight,
            relayedBy: relayedBy ?? self.relayedBy,
            out: out ?? self.out,
            lockTime: lockTime ?? self.lockTime,
            size: size ?? self.size,
            doubleSpend: doubleSpend ?? self.doubleSpend,
            time: time ?? self.time,
            txIndex: txIndex ?? self.txIndex,
            vinSz: vinSz ?? self.vinSz,
            hash: hash ?? self.hash,
            voutSz: voutSz ?? self.voutSz
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Input {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Input.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        sequence: Int? = nil,
        witness: String? = nil,
        prevOut: Out? = nil,
        script: String? = nil
    ) -> Input {
        return Input(
            sequence: sequence ?? self.sequence,
            witness: witness ?? self.witness,
            prevOut: prevOut ?? self.prevOut,
            script: script ?? self.script
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Out {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Out.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        spent: Bool? = nil,
        txIndex: Int? = nil,
        type: Int? = nil,
        addr: String?? = nil,
        value: Int? = nil,
        n: Int? = nil,
        script: String? = nil
    ) -> Out {
        return Out(
            spent: spent ?? self.spent,
            txIndex: txIndex ?? self.txIndex,
            type: type ?? self.type,
            addr: addr ?? self.addr,
            value: value ?? self.value,
            n: n ?? self.n,
            script: script ?? self.script
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
