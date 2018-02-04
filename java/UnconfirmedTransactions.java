package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class UnconfirmedTransactions {
    private Tx[] txs;

    @JsonProperty("txs")
    public Tx[] getTxs() { return txs; }
    @JsonProperty("txs")
    public void setTxs(Tx[] value) { this.txs = value; }
}
