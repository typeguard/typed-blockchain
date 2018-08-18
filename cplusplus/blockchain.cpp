//  To parse this JSON data, first install
//
//      Boost     http://www.boost.org
//      json.hpp  https://github.com/nlohmann/json
//
//  Then include this file, and then do
//
//     LatestBlock data = nlohmann::json::parse(jsonString);
//     UnconfirmedTransactions data = nlohmann::json::parse(jsonString);

#pragma once

#include "json.hpp"

#include <boost/optional.hpp>
#include <stdexcept>
#include <regex>
namespace nlohmann {
    template <typename T>
    struct adl_serializer<std::shared_ptr<T>> {
        static void to_json(json& j, const std::shared_ptr<T>& opt) {
            if (!opt) j = nullptr; else j = *opt;
        }

        static std::shared_ptr<T> from_json(const json& j) {
            if (j.is_null()) return std::unique_ptr<T>(); else return std::unique_ptr<T>(new T(j.get<T>()));
        }
    };
}

namespace quicktype {
    using nlohmann::json;

    inline json get_untyped(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<json>();
        }
        return json();
    }

    template <typename T>
    inline std::shared_ptr<T> get_optional(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<std::shared_ptr<T>>();
        }
        return std::shared_ptr<T>();
    }

    class LatestBlock {
        public:
        LatestBlock() = default;
        virtual ~LatestBlock() = default;

        private:
        std::string hash;
        int64_t time;
        int64_t block_index;
        int64_t height;
        std::vector<int64_t> tx_indexes;

        public:
        const std::string & get_hash() const { return hash; }
        std::string & get_mutable_hash() { return hash; }
        void set_hash(const std::string& value) { this->hash = value; }

        const int64_t & get_time() const { return time; }
        int64_t & get_mutable_time() { return time; }
        void set_time(const int64_t& value) { this->time = value; }

        const int64_t & get_block_index() const { return block_index; }
        int64_t & get_mutable_block_index() { return block_index; }
        void set_block_index(const int64_t& value) { this->block_index = value; }

        const int64_t & get_height() const { return height; }
        int64_t & get_mutable_height() { return height; }
        void set_height(const int64_t& value) { this->height = value; }

        const std::vector<int64_t> & get_tx_indexes() const { return tx_indexes; }
        std::vector<int64_t> & get_mutable_tx_indexes() { return tx_indexes; }
        void set_tx_indexes(const std::vector<int64_t>& value) { this->tx_indexes = value; }
    };

    class Out {
        public:
        Out() = default;
        virtual ~Out() = default;

        private:
        bool spent;
        int64_t tx_index;
        int64_t type;
        std::shared_ptr<std::string> addr;
        int64_t value;
        int64_t n;
        std::string script;

        public:
        const bool & get_spent() const { return spent; }
        bool & get_mutable_spent() { return spent; }
        void set_spent(const bool& value) { this->spent = value; }

        const int64_t & get_tx_index() const { return tx_index; }
        int64_t & get_mutable_tx_index() { return tx_index; }
        void set_tx_index(const int64_t& value) { this->tx_index = value; }

        const int64_t & get_type() const { return type; }
        int64_t & get_mutable_type() { return type; }
        void set_type(const int64_t& value) { this->type = value; }

        std::shared_ptr<std::string> get_addr() const { return addr; }
        void set_addr(std::shared_ptr<std::string> value) { this->addr = value; }

        const int64_t & get_value() const { return value; }
        int64_t & get_mutable_value() { return value; }
        void set_value(const int64_t& value) { this->value = value; }

        const int64_t & get_n() const { return n; }
        int64_t & get_mutable_n() { return n; }
        void set_n(const int64_t& value) { this->n = value; }

        const std::string & get_script() const { return script; }
        std::string & get_mutable_script() { return script; }
        void set_script(const std::string& value) { this->script = value; }
    };

    class Input {
        public:
        Input() = default;
        virtual ~Input() = default;

        private:
        int64_t sequence;
        std::string witness;
        Out prev_out;
        std::string script;

        public:
        const int64_t & get_sequence() const { return sequence; }
        int64_t & get_mutable_sequence() { return sequence; }
        void set_sequence(const int64_t& value) { this->sequence = value; }

        const std::string & get_witness() const { return witness; }
        std::string & get_mutable_witness() { return witness; }
        void set_witness(const std::string& value) { this->witness = value; }

        const Out & get_prev_out() const { return prev_out; }
        Out & get_mutable_prev_out() { return prev_out; }
        void set_prev_out(const Out& value) { this->prev_out = value; }

        const std::string & get_script() const { return script; }
        std::string & get_mutable_script() { return script; }
        void set_script(const std::string& value) { this->script = value; }
    };

    enum class RelayedBy : int { THE_0000, THE_127001 };

    class Tx {
        public:
        Tx() = default;
        virtual ~Tx() = default;

        private:
        int64_t ver;
        std::vector<Input> inputs;
        int64_t weight;
        RelayedBy relayed_by;
        std::vector<Out> out;
        int64_t lock_time;
        int64_t size;
        bool double_spend;
        int64_t time;
        int64_t tx_index;
        int64_t vin_sz;
        std::string hash;
        int64_t vout_sz;

        public:
        const int64_t & get_ver() const { return ver; }
        int64_t & get_mutable_ver() { return ver; }
        void set_ver(const int64_t& value) { this->ver = value; }

        const std::vector<Input> & get_inputs() const { return inputs; }
        std::vector<Input> & get_mutable_inputs() { return inputs; }
        void set_inputs(const std::vector<Input>& value) { this->inputs = value; }

        const int64_t & get_weight() const { return weight; }
        int64_t & get_mutable_weight() { return weight; }
        void set_weight(const int64_t& value) { this->weight = value; }

        const RelayedBy & get_relayed_by() const { return relayed_by; }
        RelayedBy & get_mutable_relayed_by() { return relayed_by; }
        void set_relayed_by(const RelayedBy& value) { this->relayed_by = value; }

        const std::vector<Out> & get_out() const { return out; }
        std::vector<Out> & get_mutable_out() { return out; }
        void set_out(const std::vector<Out>& value) { this->out = value; }

        const int64_t & get_lock_time() const { return lock_time; }
        int64_t & get_mutable_lock_time() { return lock_time; }
        void set_lock_time(const int64_t& value) { this->lock_time = value; }

        const int64_t & get_size() const { return size; }
        int64_t & get_mutable_size() { return size; }
        void set_size(const int64_t& value) { this->size = value; }

        const bool & get_double_spend() const { return double_spend; }
        bool & get_mutable_double_spend() { return double_spend; }
        void set_double_spend(const bool& value) { this->double_spend = value; }

        const int64_t & get_time() const { return time; }
        int64_t & get_mutable_time() { return time; }
        void set_time(const int64_t& value) { this->time = value; }

        const int64_t & get_tx_index() const { return tx_index; }
        int64_t & get_mutable_tx_index() { return tx_index; }
        void set_tx_index(const int64_t& value) { this->tx_index = value; }

        const int64_t & get_vin_sz() const { return vin_sz; }
        int64_t & get_mutable_vin_sz() { return vin_sz; }
        void set_vin_sz(const int64_t& value) { this->vin_sz = value; }

        const std::string & get_hash() const { return hash; }
        std::string & get_mutable_hash() { return hash; }
        void set_hash(const std::string& value) { this->hash = value; }

        const int64_t & get_vout_sz() const { return vout_sz; }
        int64_t & get_mutable_vout_sz() { return vout_sz; }
        void set_vout_sz(const int64_t& value) { this->vout_sz = value; }
    };

    class UnconfirmedTransactions {
        public:
        UnconfirmedTransactions() = default;
        virtual ~UnconfirmedTransactions() = default;

        private:
        std::vector<Tx> txs;

        public:
        const std::vector<Tx> & get_txs() const { return txs; }
        std::vector<Tx> & get_mutable_txs() { return txs; }
        void set_txs(const std::vector<Tx>& value) { this->txs = value; }
    };
}

namespace nlohmann {
    inline void from_json(const json& _j, quicktype::LatestBlock& _x) {
        _x.set_hash( _j.at("hash").get<std::string>() );
        _x.set_time( _j.at("time").get<int64_t>() );
        _x.set_block_index( _j.at("block_index").get<int64_t>() );
        _x.set_height( _j.at("height").get<int64_t>() );
        _x.set_tx_indexes( _j.at("txIndexes").get<std::vector<int64_t>>() );
    }

    inline void to_json(json& _j, const quicktype::LatestBlock& _x) {
        _j = json::object();
        _j["hash"] = _x.get_hash();
        _j["time"] = _x.get_time();
        _j["block_index"] = _x.get_block_index();
        _j["height"] = _x.get_height();
        _j["txIndexes"] = _x.get_tx_indexes();
    }

    inline void from_json(const json& _j, quicktype::Out& _x) {
        _x.set_spent( _j.at("spent").get<bool>() );
        _x.set_tx_index( _j.at("tx_index").get<int64_t>() );
        _x.set_type( _j.at("type").get<int64_t>() );
        _x.set_addr( quicktype::get_optional<std::string>(_j, "addr") );
        _x.set_value( _j.at("value").get<int64_t>() );
        _x.set_n( _j.at("n").get<int64_t>() );
        _x.set_script( _j.at("script").get<std::string>() );
    }

    inline void to_json(json& _j, const quicktype::Out& _x) {
        _j = json::object();
        _j["spent"] = _x.get_spent();
        _j["tx_index"] = _x.get_tx_index();
        _j["type"] = _x.get_type();
        _j["addr"] = _x.get_addr();
        _j["value"] = _x.get_value();
        _j["n"] = _x.get_n();
        _j["script"] = _x.get_script();
    }

    inline void from_json(const json& _j, quicktype::Input& _x) {
        _x.set_sequence( _j.at("sequence").get<int64_t>() );
        _x.set_witness( _j.at("witness").get<std::string>() );
        _x.set_prev_out( _j.at("prev_out").get<quicktype::Out>() );
        _x.set_script( _j.at("script").get<std::string>() );
    }

    inline void to_json(json& _j, const quicktype::Input& _x) {
        _j = json::object();
        _j["sequence"] = _x.get_sequence();
        _j["witness"] = _x.get_witness();
        _j["prev_out"] = _x.get_prev_out();
        _j["script"] = _x.get_script();
    }

    inline void from_json(const json& _j, quicktype::Tx& _x) {
        _x.set_ver( _j.at("ver").get<int64_t>() );
        _x.set_inputs( _j.at("inputs").get<std::vector<quicktype::Input>>() );
        _x.set_weight( _j.at("weight").get<int64_t>() );
        _x.set_relayed_by( _j.at("relayed_by").get<quicktype::RelayedBy>() );
        _x.set_out( _j.at("out").get<std::vector<quicktype::Out>>() );
        _x.set_lock_time( _j.at("lock_time").get<int64_t>() );
        _x.set_size( _j.at("size").get<int64_t>() );
        _x.set_double_spend( _j.at("double_spend").get<bool>() );
        _x.set_time( _j.at("time").get<int64_t>() );
        _x.set_tx_index( _j.at("tx_index").get<int64_t>() );
        _x.set_vin_sz( _j.at("vin_sz").get<int64_t>() );
        _x.set_hash( _j.at("hash").get<std::string>() );
        _x.set_vout_sz( _j.at("vout_sz").get<int64_t>() );
    }

    inline void to_json(json& _j, const quicktype::Tx& _x) {
        _j = json::object();
        _j["ver"] = _x.get_ver();
        _j["inputs"] = _x.get_inputs();
        _j["weight"] = _x.get_weight();
        _j["relayed_by"] = _x.get_relayed_by();
        _j["out"] = _x.get_out();
        _j["lock_time"] = _x.get_lock_time();
        _j["size"] = _x.get_size();
        _j["double_spend"] = _x.get_double_spend();
        _j["time"] = _x.get_time();
        _j["tx_index"] = _x.get_tx_index();
        _j["vin_sz"] = _x.get_vin_sz();
        _j["hash"] = _x.get_hash();
        _j["vout_sz"] = _x.get_vout_sz();
    }

    inline void from_json(const json& _j, quicktype::UnconfirmedTransactions& _x) {
        _x.set_txs( _j.at("txs").get<std::vector<quicktype::Tx>>() );
    }

    inline void to_json(json& _j, const quicktype::UnconfirmedTransactions& _x) {
        _j = json::object();
        _j["txs"] = _x.get_txs();
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
