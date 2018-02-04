//  To parse this JSON data, first install
//
//      Boost     http://www.boost.org
//      json.hpp  https://github.com/nlohmann/json
//
//  Then include this file, and then do
//
//     LatestBlock data = nlohmann::json::parse(jsonString);
//     UnconfirmedTransactions data = nlohmann::json::parse(jsonString);

#include "json.hpp"

namespace quicktype {
    using nlohmann::json;

    struct LatestBlock {
        std::string hash;
        int64_t time;
        int64_t block_index;
        int64_t height;
        std::vector<int64_t> tx_indexes;
    };

    struct Out {
        bool spent;
        int64_t tx_index;
        int64_t type;
        std::string addr;
        int64_t value;
        int64_t n;
        std::string script;
    };

    enum class Witness { EMPTY };

    struct Input {
        int64_t sequence;
        Witness witness;
        struct Out prev_out;
        std::string script;
    };

    enum class RelayedBy { THE_0000, THE_127001 };

    struct Tx {
        int64_t ver;
        std::vector<struct Input> inputs;
        int64_t weight;
        RelayedBy relayed_by;
        std::vector<struct Out> out;
        int64_t lock_time;
        int64_t size;
        std::unique_ptr<bool> rbf;
        bool double_spend;
        int64_t time;
        int64_t tx_index;
        int64_t vin_sz;
        std::string hash;
        int64_t vout_sz;
    };

    struct UnconfirmedTransactions {
        std::vector<struct Tx> txs;
    };
    
    inline json get_untyped(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<json>();
        }
        return json();
    }
    
    template <typename T>
    inline std::unique_ptr<T> get_optional(const json &j, const char *property) {
        if (j.find(property) != j.end())
            return j.at(property).get<std::unique_ptr<T>>();
        return std::unique_ptr<T>();
    }
}

namespace nlohmann {
    template <typename T>
    struct adl_serializer<std::unique_ptr<T>> {
        static void to_json(json& j, const std::unique_ptr<T>& opt) {
            if (!opt)
                j = nullptr;
            else
                j = *opt;
        }

        static std::unique_ptr<T> from_json(const json& j) {
            if (j.is_null())
                return std::unique_ptr<T>();
            else
                return std::unique_ptr<T>(new T(j.get<T>()));
        }
    };

    inline void from_json(const json& _j, struct quicktype::LatestBlock& _x) {
        _x.hash = _j.at("hash").get<std::string>();
        _x.time = _j.at("time").get<int64_t>();
        _x.block_index = _j.at("block_index").get<int64_t>();
        _x.height = _j.at("height").get<int64_t>();
        _x.tx_indexes = _j.at("txIndexes").get<std::vector<int64_t>>();
    }

    inline void to_json(json& _j, const struct quicktype::LatestBlock& _x) {
        _j = json::object();
        _j["hash"] = _x.hash;
        _j["time"] = _x.time;
        _j["block_index"] = _x.block_index;
        _j["height"] = _x.height;
        _j["txIndexes"] = _x.tx_indexes;
    }

    inline void from_json(const json& _j, struct quicktype::Out& _x) {
        _x.spent = _j.at("spent").get<bool>();
        _x.tx_index = _j.at("tx_index").get<int64_t>();
        _x.type = _j.at("type").get<int64_t>();
        _x.addr = _j.at("addr").get<std::string>();
        _x.value = _j.at("value").get<int64_t>();
        _x.n = _j.at("n").get<int64_t>();
        _x.script = _j.at("script").get<std::string>();
    }

    inline void to_json(json& _j, const struct quicktype::Out& _x) {
        _j = json::object();
        _j["spent"] = _x.spent;
        _j["tx_index"] = _x.tx_index;
        _j["type"] = _x.type;
        _j["addr"] = _x.addr;
        _j["value"] = _x.value;
        _j["n"] = _x.n;
        _j["script"] = _x.script;
    }

    inline void from_json(const json& _j, struct quicktype::Input& _x) {
        _x.sequence = _j.at("sequence").get<int64_t>();
        _x.witness = _j.at("witness").get<quicktype::Witness>();
        _x.prev_out = _j.at("prev_out").get<struct quicktype::Out>();
        _x.script = _j.at("script").get<std::string>();
    }

    inline void to_json(json& _j, const struct quicktype::Input& _x) {
        _j = json::object();
        _j["sequence"] = _x.sequence;
        _j["witness"] = _x.witness;
        _j["prev_out"] = _x.prev_out;
        _j["script"] = _x.script;
    }

    inline void from_json(const json& _j, struct quicktype::Tx& _x) {
        _x.ver = _j.at("ver").get<int64_t>();
        _x.inputs = _j.at("inputs").get<std::vector<struct quicktype::Input>>();
        _x.weight = _j.at("weight").get<int64_t>();
        _x.relayed_by = _j.at("relayed_by").get<quicktype::RelayedBy>();
        _x.out = _j.at("out").get<std::vector<struct quicktype::Out>>();
        _x.lock_time = _j.at("lock_time").get<int64_t>();
        _x.size = _j.at("size").get<int64_t>();
        _x.rbf = quicktype::get_optional<bool>(_j, "rbf");
        _x.double_spend = _j.at("double_spend").get<bool>();
        _x.time = _j.at("time").get<int64_t>();
        _x.tx_index = _j.at("tx_index").get<int64_t>();
        _x.vin_sz = _j.at("vin_sz").get<int64_t>();
        _x.hash = _j.at("hash").get<std::string>();
        _x.vout_sz = _j.at("vout_sz").get<int64_t>();
    }

    inline void to_json(json& _j, const struct quicktype::Tx& _x) {
        _j = json::object();
        _j["ver"] = _x.ver;
        _j["inputs"] = _x.inputs;
        _j["weight"] = _x.weight;
        _j["relayed_by"] = _x.relayed_by;
        _j["out"] = _x.out;
        _j["lock_time"] = _x.lock_time;
        _j["size"] = _x.size;
        _j["rbf"] = _x.rbf;
        _j["double_spend"] = _x.double_spend;
        _j["time"] = _x.time;
        _j["tx_index"] = _x.tx_index;
        _j["vin_sz"] = _x.vin_sz;
        _j["hash"] = _x.hash;
        _j["vout_sz"] = _x.vout_sz;
    }

    inline void from_json(const json& _j, struct quicktype::UnconfirmedTransactions& _x) {
        _x.txs = _j.at("txs").get<std::vector<struct quicktype::Tx>>();
    }

    inline void to_json(json& _j, const struct quicktype::UnconfirmedTransactions& _x) {
        _j = json::object();
        _j["txs"] = _x.txs;
    }

    inline void from_json(const json& _j, quicktype::Witness& _x) {
        if (_j == "") _x = quicktype::Witness::EMPTY;
        else throw "Input JSON does not conform to schema";
    }

    inline void to_json(json& _j, const quicktype::Witness& _x) {
        switch (_x) {
            case quicktype::Witness::EMPTY: _j = ""; break;
            default: throw "This should not happen";
        }
    }

    inline void from_json(const json& _j, quicktype::RelayedBy& _x) {
        if (_j == "0.0.0.0") _x = quicktype::RelayedBy::THE_0000;
        else if (_j == "127.0.0.1") _x = quicktype::RelayedBy::THE_127001;
        else throw "Input JSON does not conform to schema";
    }

    inline void to_json(json& _j, const quicktype::RelayedBy& _x) {
        switch (_x) {
            case quicktype::RelayedBy::THE_0000: _j = "0.0.0.0"; break;
            case quicktype::RelayedBy::THE_127001: _j = "127.0.0.1"; break;
            default: throw "This should not happen";
        }
    }

}
