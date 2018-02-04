package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.annotation.*;

public enum RelayedBy {
    THE_0000, THE_127001;

    @JsonValue
    public String toValue() {
        switch (this) {
        case THE_0000: return "0.0.0.0";
        case THE_127001: return "127.0.0.1";
        }
        return null;
    }

    @JsonCreator
    public static RelayedBy forValue(String value) throws IOException {
        if (value.equals("0.0.0.0")) return THE_0000;
        if (value.equals("127.0.0.1")) return THE_127001;
        throw new IOException("Cannot deserialize RelayedBy");
    }
}
