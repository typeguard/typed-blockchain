// Example code that deserializes and serializes the model.
// extern crate serde;
// #[macro_use]
// extern crate serde_derive;
// extern crate serde_json;
// 
// use generated_module::LatestBlock;
// 
// fn main() {
//     let json = r#"{"answer": 42}"#;
//     let model: LatestBlock = serde_json::from_str(&json).unwrap();
// }

extern crate serde_json;

#[derive(Serialize, Deserialize)]
pub struct LatestBlock {
    #[serde(rename = "hash")]
    hash: String,

    #[serde(rename = "time")]
    time: i64,

    #[serde(rename = "block_index")]
    block_index: i64,

    #[serde(rename = "height")]
    height: i64,

    #[serde(rename = "txIndexes")]
    tx_indexes: Vec<i64>,
}

#[derive(Serialize, Deserialize)]
pub struct UnconfirmedTransactions {
    #[serde(rename = "txs")]
    txs: Vec<Tx>,
}

#[derive(Serialize, Deserialize)]
pub struct Tx {
    #[serde(rename = "ver")]
    ver: i64,

    #[serde(rename = "inputs")]
    inputs: Vec<Input>,

    #[serde(rename = "weight")]
    weight: i64,

    #[serde(rename = "relayed_by")]
    relayed_by: RelayedBy,

    #[serde(rename = "out")]
    out: Vec<Out>,

    #[serde(rename = "lock_time")]
    lock_time: i64,

    #[serde(rename = "size")]
    size: i64,

    #[serde(rename = "double_spend")]
    double_spend: bool,

    #[serde(rename = "time")]
    time: i64,

    #[serde(rename = "tx_index")]
    tx_index: i64,

    #[serde(rename = "vin_sz")]
    vin_sz: i64,

    #[serde(rename = "hash")]
    hash: String,

    #[serde(rename = "vout_sz")]
    vout_sz: i64,
}

#[derive(Serialize, Deserialize)]
pub struct Input {
    #[serde(rename = "sequence")]
    sequence: i64,

    #[serde(rename = "witness")]
    witness: String,

    #[serde(rename = "prev_out")]
    prev_out: Out,

    #[serde(rename = "script")]
    script: String,
}

#[derive(Serialize, Deserialize)]
pub struct Out {
    #[serde(rename = "spent")]
    spent: bool,

    #[serde(rename = "tx_index")]
    tx_index: i64,

    #[serde(rename = "type")]
    out_type: i64,

    #[serde(rename = "addr")]
    addr: String,

    #[serde(rename = "value")]
    value: i64,

    #[serde(rename = "n")]
    n: i64,

    #[serde(rename = "script")]
    script: String,
}

#[derive(Serialize, Deserialize)]
pub enum RelayedBy {
    #[serde(rename = "0.0.0.0")]
    The0000,

    #[serde(rename = "127.0.0.1")]
    The127001,
}
