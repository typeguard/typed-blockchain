package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.annotation.*;

public enum Witness {
    EMPTY;

    @JsonValue
    public String toValue() {
        switch (this) {
        case EMPTY: return "";
        }
        return null;
    }

    @JsonCreator
    public static Witness forValue(String value) throws IOException {
        if (value.equals("")) return EMPTY;
        throw new IOException("Cannot deserialize Witness");
    }
}
