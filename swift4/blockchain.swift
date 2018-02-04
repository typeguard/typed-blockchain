// To parse the JSON, add this file to your project and do:
//
//   guard let latestBlock = try LatestBlock(json) else { ... }
//   guard let unconfirmedTransactions = try UnconfirmedTransactions(json) else { ... }

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
    let rbf: Bool?

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
        case rbf
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
    let addr: String
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

// MARK: Convenience initializers

extension LatestBlock {
    init(data: Data) throws {
        self = try JSONDecoder().decode(LatestBlock.self, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }

    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}

extension UnconfirmedTransactions {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UnconfirmedTransactions.self, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }

    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}

extension Tx {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Tx.self, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }

    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}

extension Input {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Input.self, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }

    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}

extension Out {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Out.self, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }

    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}
