// To use this code, add the following Maven dependency to your project:
// 
//     com.fasterxml.jackson.core : jackson-databind : 2.9.0
// 
// Import this package:
// 
//     import io.quicktype.Converter;
//
// Then you can deserialize a JSON string with
//
//     LatestBlock data = Converter.LatestBlockFromJsonString(jsonString);
//     UnconfirmedTransactions data = Converter.UnconfirmedTransactionsFromJsonString(jsonString);

package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.core.JsonProcessingException;

public class Converter {
    // Serialize/deserialize helpers

    public static LatestBlock LatestBlockFromJsonString(String json) throws IOException {
        return getLatestBlockObjectReader().readValue(json);
    }

    public static String LatestBlockToJsonString(LatestBlock obj) throws JsonProcessingException {
        return getLatestBlockObjectWriter().writeValueAsString(obj);
    }

    public static UnconfirmedTransactions UnconfirmedTransactionsFromJsonString(String json) throws IOException {
        return getUnconfirmedTransactionsObjectReader().readValue(json);
    }

    public static String UnconfirmedTransactionsToJsonString(UnconfirmedTransactions obj) throws JsonProcessingException {
        return getUnconfirmedTransactionsObjectWriter().writeValueAsString(obj);
    }

    private static ObjectReader LatestBlockReader;
    private static ObjectWriter LatestBlockWriter;

    private static void instantiateLatestBlockMapper() {
        ObjectMapper mapper = new ObjectMapper();
        LatestBlockReader = mapper.reader(LatestBlock.class);
        LatestBlockWriter = mapper.writerFor(LatestBlock.class);
    }

    private static ObjectReader getLatestBlockObjectReader() {
        if (LatestBlockReader == null) instantiateMapper();
        return LatestBlockReader;
    }

    private static ObjectWriter getLatestBlockObjectWriter() {
        if (LatestBlockWriter == null) instantiateMapper();
        return LatestBlockWriter;
    }

    private static ObjectReader UnconfirmedTransactionsReader;
    private static ObjectWriter UnconfirmedTransactionsWriter;

    private static void instantiateUnconfirmedTransactionsMapper() {
        ObjectMapper mapper = new ObjectMapper();
        UnconfirmedTransactionsReader = mapper.reader(UnconfirmedTransactions.class);
        UnconfirmedTransactionsWriter = mapper.writerFor(UnconfirmedTransactions.class);
    }

    private static ObjectReader getUnconfirmedTransactionsObjectReader() {
        if (UnconfirmedTransactionsReader == null) instantiateMapper();
        return UnconfirmedTransactionsReader;
    }

    private static ObjectWriter getUnconfirmedTransactionsObjectWriter() {
        if (UnconfirmedTransactionsWriter == null) instantiateMapper();
        return UnconfirmedTransactionsWriter;
    }
}
