package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class Out {
    private boolean spent;
    private long txIndex;
    private long type;
    private String addr;
    private long value;
    private long n;
    private String script;

    @JsonProperty("spent")
    public boolean getSpent() { return spent; }
    @JsonProperty("spent")
    public void setSpent(boolean value) { this.spent = value; }

    @JsonProperty("tx_index")
    public long getTxIndex() { return txIndex; }
    @JsonProperty("tx_index")
    public void setTxIndex(long value) { this.txIndex = value; }

    @JsonProperty("type")
    public long getType() { return type; }
    @JsonProperty("type")
    public void setType(long value) { this.type = value; }

    @JsonProperty("addr")
    public String getAddr() { return addr; }
    @JsonProperty("addr")
    public void setAddr(String value) { this.addr = value; }

    @JsonProperty("value")
    public long getValue() { return value; }
    @JsonProperty("value")
    public void setValue(long value) { this.value = value; }

    @JsonProperty("n")
    public long getN() { return n; }
    @JsonProperty("n")
    public void setN(long value) { this.n = value; }

    @JsonProperty("script")
    public String getScript() { return script; }
    @JsonProperty("script")
    public void setScript(String value) { this.script = value; }
}
