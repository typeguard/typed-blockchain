package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class LatestBlock {
    private String hash;
    private long time;
    private long blockIndex;
    private long height;
    private long[] txIndexes;

    @JsonProperty("hash")
    public String getHash() { return hash; }
    @JsonProperty("hash")
    public void setHash(String value) { this.hash = value; }

    @JsonProperty("time")
    public long getTime() { return time; }
    @JsonProperty("time")
    public void setTime(long value) { this.time = value; }

    @JsonProperty("block_index")
    public long getBlockIndex() { return blockIndex; }
    @JsonProperty("block_index")
    public void setBlockIndex(long value) { this.blockIndex = value; }

    @JsonProperty("height")
    public long getHeight() { return height; }
    @JsonProperty("height")
    public void setHeight(long value) { this.height = value; }

    @JsonProperty("txIndexes")
    public long[] getTxIndexes() { return txIndexes; }
    @JsonProperty("txIndexes")
    public void setTxIndexes(long[] value) { this.txIndexes = value; }
}
