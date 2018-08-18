// To parse this JSON data, add NuGet 'Newtonsoft.Json' then do one of these:
//
//    using QuickType;
//
//    var latestBlock = LatestBlock.FromJson(jsonString);
//    var unconfirmedTransactions = UnconfirmedTransactions.FromJson(jsonString);

namespace QuickType
{
    using System;
    using System.Collections.Generic;

    using System.Globalization;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;

    public partial class LatestBlock
    {
        [JsonProperty("hash")]
        public string Hash { get; set; }

        [JsonProperty("time")]
        public long Time { get; set; }

        [JsonProperty("block_index")]
        public long BlockIndex { get; set; }

        [JsonProperty("height")]
        public long Height { get; set; }

        [JsonProperty("txIndexes")]
        public long[] TxIndexes { get; set; }
    }

    public partial class UnconfirmedTransactions
    {
        [JsonProperty("txs")]
        public Tx[] Txs { get; set; }
    }

    public partial class Tx
    {
        [JsonProperty("ver")]
        public long Ver { get; set; }

        [JsonProperty("inputs")]
        public Input[] Inputs { get; set; }

        [JsonProperty("weight")]
        public long Weight { get; set; }

        [JsonProperty("relayed_by")]
        public RelayedBy RelayedBy { get; set; }

        [JsonProperty("out")]
        public Out[] Out { get; set; }

        [JsonProperty("lock_time")]
        public long LockTime { get; set; }

        [JsonProperty("size")]
        public long Size { get; set; }

        [JsonProperty("double_spend")]
        public bool DoubleSpend { get; set; }

        [JsonProperty("time")]
        public long Time { get; set; }

        [JsonProperty("tx_index")]
        public long TxIndex { get; set; }

        [JsonProperty("vin_sz")]
        public long VinSz { get; set; }

        [JsonProperty("hash")]
        public string Hash { get; set; }

        [JsonProperty("vout_sz")]
        public long VoutSz { get; set; }
    }

    public partial class Input
    {
        [JsonProperty("sequence")]
        public long Sequence { get; set; }

        [JsonProperty("witness")]
        public string Witness { get; set; }

        [JsonProperty("prev_out")]
        public Out PrevOut { get; set; }

        [JsonProperty("script")]
        public string Script { get; set; }
    }

    public partial class Out
    {
        [JsonProperty("spent")]
        public bool Spent { get; set; }

        [JsonProperty("tx_index")]
        public long TxIndex { get; set; }

        [JsonProperty("type")]
        public long Type { get; set; }

        [JsonProperty("addr", NullValueHandling = NullValueHandling.Ignore)]
        public string Addr { get; set; }

        [JsonProperty("value")]
        public long Value { get; set; }

        [JsonProperty("n")]
        public long N { get; set; }

        [JsonProperty("script")]
        public string Script { get; set; }
    }

    public enum RelayedBy { The0000, The127001 };

    public partial class LatestBlock
    {
        public static LatestBlock FromJson(string json) => JsonConvert.DeserializeObject<LatestBlock>(json, QuickType.Converter.Settings);
    }

    public partial class UnconfirmedTransactions
    {
        public static UnconfirmedTransactions FromJson(string json) => JsonConvert.DeserializeObject<UnconfirmedTransactions>(json, QuickType.Converter.Settings);
    }

    public static class Serialize
    {
        public static string ToJson(this LatestBlock self) => JsonConvert.SerializeObject(self, QuickType.Converter.Settings);
        public static string ToJson(this UnconfirmedTransactions self) => JsonConvert.SerializeObject(self, QuickType.Converter.Settings);
    }

    internal static class Converter
    {
        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            Converters = {
                RelayedByConverter.Singleton,
                new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.AssumeUniversal }
            },
        };
    }

    internal class RelayedByConverter : JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(RelayedBy) || t == typeof(RelayedBy?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null) return null;
            var value = serializer.Deserialize<string>(reader);
            switch (value)
            {
                case "0.0.0.0":
                    return RelayedBy.The0000;
                case "127.0.0.1":
                    return RelayedBy.The127001;
            }
            throw new Exception("Cannot unmarshal type RelayedBy");
        }

        public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
        {
            if (untypedValue == null)
            {
                serializer.Serialize(writer, null);
                return;
            }
            var value = (RelayedBy)untypedValue;
            switch (value)
            {
                case RelayedBy.The0000:
                    serializer.Serialize(writer, "0.0.0.0");
                    return;
                case RelayedBy.The127001:
                    serializer.Serialize(writer, "127.0.0.1");
                    return;
            }
            throw new Exception("Cannot marshal type RelayedBy");
        }

        public static readonly RelayedByConverter Singleton = new RelayedByConverter();
    }
}
