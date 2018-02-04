// To parse and unparse this JSON data, add this code to your project and do:
//
//    r, err := UnmarshalLatestBlock(bytes)
//    bytes, err = r.Marshal()
//
//    r, err := UnmarshalUnconfirmedTransactions(bytes)
//    bytes, err = r.Marshal()

package main

import "encoding/json"

func UnmarshalLatestBlock(data []byte) (LatestBlock, error) {
	var r LatestBlock
	err := json.Unmarshal(data, &r)
	return r, err
}

func (r *LatestBlock) Marshal() ([]byte, error) {
	return json.Marshal(r)
}

func UnmarshalUnconfirmedTransactions(data []byte) (UnconfirmedTransactions, error) {
	var r UnconfirmedTransactions
	err := json.Unmarshal(data, &r)
	return r, err
}

func (r *UnconfirmedTransactions) Marshal() ([]byte, error) {
	return json.Marshal(r)
}

type LatestBlock struct {
	Hash       string  `json:"hash"`
	Time       int64   `json:"time"`
	BlockIndex int64   `json:"block_index"`
	Height     int64   `json:"height"`
	TxIndexes  []int64 `json:"txIndexes"`
}

type UnconfirmedTransactions struct {
	Txs []Tx `json:"txs"`
}

type Tx struct {
	Ver         int64     `json:"ver"`
	Inputs      []Input   `json:"inputs"`
	Weight      int64     `json:"weight"`
	RelayedBy   RelayedBy `json:"relayed_by"`
	Out         []Out     `json:"out"`
	LockTime    int64     `json:"lock_time"`
	Size        int64     `json:"size"`
	Rbf         *bool     `json:"rbf"`
	DoubleSpend bool      `json:"double_spend"`
	Time        int64     `json:"time"`
	TxIndex     int64     `json:"tx_index"`
	VinSz       int64     `json:"vin_sz"`
	Hash        string    `json:"hash"`
	VoutSz      int64     `json:"vout_sz"`
}

type Input struct {
	Sequence int64  `json:"sequence"`
	Witness  string `json:"witness"`
	PrevOut  Out    `json:"prev_out"`
	Script   string `json:"script"`
}

type Out struct {
	Spent   bool   `json:"spent"`
	TxIndex int64  `json:"tx_index"`
	Type    int64  `json:"type"`
	Addr    string `json:"addr"`
	Value   int64  `json:"value"`
	N       int64  `json:"n"`
	Script  string `json:"script"`
}

type RelayedBy string
const (
	The0000 RelayedBy = "0.0.0.0"
	The127001 RelayedBy = "127.0.0.1"
)
