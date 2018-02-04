package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class Tx {
    private long ver;
    private Input[] inputs;
    private long weight;
    private RelayedBy relayedBy;
    private Out[] out;
    private long lockTime;
    private long size;
    private boolean doubleSpend;
    private long time;
    private long txIndex;
    private long vinSz;
    private String hash;
    private long voutSz;

    @JsonProperty("ver")
    public long getVer() { return ver; }
    @JsonProperty("ver")
    public void setVer(long value) { this.ver = value; }

    @JsonProperty("inputs")
    public Input[] getInputs() { return inputs; }
    @JsonProperty("inputs")
    public void setInputs(Input[] value) { this.inputs = value; }

    @JsonProperty("weight")
    public long getWeight() { return weight; }
    @JsonProperty("weight")
    public void setWeight(long value) { this.weight = value; }

    @JsonProperty("relayed_by")
    public RelayedBy getRelayedBy() { return relayedBy; }
    @JsonProperty("relayed_by")
    public void setRelayedBy(RelayedBy value) { this.relayedBy = value; }

    @JsonProperty("out")
    public Out[] getOut() { return out; }
    @JsonProperty("out")
    public void setOut(Out[] value) { this.out = value; }

    @JsonProperty("lock_time")
    public long getLockTime() { return lockTime; }
    @JsonProperty("lock_time")
    public void setLockTime(long value) { this.lockTime = value; }

    @JsonProperty("size")
    public long getSize() { return size; }
    @JsonProperty("size")
    public void setSize(long value) { this.size = value; }

    @JsonProperty("double_spend")
    public boolean getDoubleSpend() { return doubleSpend; }
    @JsonProperty("double_spend")
    public void setDoubleSpend(boolean value) { this.doubleSpend = value; }

    @JsonProperty("time")
    public long getTime() { return time; }
    @JsonProperty("time")
    public void setTime(long value) { this.time = value; }

    @JsonProperty("tx_index")
    public long getTxIndex() { return txIndex; }
    @JsonProperty("tx_index")
    public void setTxIndex(long value) { this.txIndex = value; }

    @JsonProperty("vin_sz")
    public long getVinSz() { return vinSz; }
    @JsonProperty("vin_sz")
    public void setVinSz(long value) { this.vinSz = value; }

    @JsonProperty("hash")
    public String getHash() { return hash; }
    @JsonProperty("hash")
    public void setHash(String value) { this.hash = value; }

    @JsonProperty("vout_sz")
    public long getVoutSz() { return voutSz; }
    @JsonProperty("vout_sz")
    public void setVoutSz(long value) { this.voutSz = value; }
}
