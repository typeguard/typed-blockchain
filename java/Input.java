package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class Input {
    private long sequence;
    private Witness witness;
    private Out prevOut;
    private String script;

    @JsonProperty("sequence")
    public long getSequence() { return sequence; }
    @JsonProperty("sequence")
    public void setSequence(long value) { this.sequence = value; }

    @JsonProperty("witness")
    public Witness getWitness() { return witness; }
    @JsonProperty("witness")
    public void setWitness(Witness value) { this.witness = value; }

    @JsonProperty("prev_out")
    public Out getPrevOut() { return prevOut; }
    @JsonProperty("prev_out")
    public void setPrevOut(Out value) { this.prevOut = value; }

    @JsonProperty("script")
    public String getScript() { return script; }
    @JsonProperty("script")
    public void setScript(String value) { this.script = value; }
}
