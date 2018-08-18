// To parse the JSON, install Klaxon and do:
//
//   val latestBlock = LatestBlock.fromJson(jsonString)
//   val unconfirmedTransactions = UnconfirmedTransactions.fromJson(jsonString)

package quicktype

import com.beust.klaxon.*

private fun <T> Klaxon.convert(k: kotlin.reflect.KClass<*>, fromJson: (JsonValue) -> T, toJson: (T) -> String, isUnion: Boolean = false) =
    this.converter(object: Converter {
        @Suppress("UNCHECKED_CAST")
        override fun toJson(value: Any)        = toJson(value as T)
        override fun fromJson(jv: JsonValue)   = fromJson(jv) as Any
        override fun canConvert(cls: Class<*>) = cls == k.java || (isUnion && cls.superclass == k.java)
    })

private val klaxon = Klaxon()
    .convert(RelayedBy::class, { RelayedBy.fromValue(it.string!!) }, { "\"${it.value}\"" })

data class LatestBlock (
    val hash: String,
    val time: Long,

    @Json(name = "block_index")
    val blockIndex: Long,

    val height: Long,
    val txIndexes: List<Long>
) {
    public fun toJson() = klaxon.toJsonString(this)

    companion object {
        public fun fromJson(json: String) = klaxon.parse<LatestBlock>(json)
    }
}

data class UnconfirmedTransactions (
    val txs: List<Tx>
) {
    public fun toJson() = klaxon.toJsonString(this)

    companion object {
        public fun fromJson(json: String) = klaxon.parse<UnconfirmedTransactions>(json)
    }
}

data class Tx (
    val ver: Long,
    val inputs: List<Input>,
    val weight: Long,

    @Json(name = "relayed_by")
    val relayedBy: RelayedBy,

    val out: List<Out>,

    @Json(name = "lock_time")
    val lockTime: Long,

    val size: Long,

    @Json(name = "double_spend")
    val doubleSpend: Boolean,

    val time: Long,

    @Json(name = "tx_index")
    val txIndex: Long,

    @Json(name = "vin_sz")
    val vinSz: Long,

    val hash: String,

    @Json(name = "vout_sz")
    val voutSz: Long
)

data class Input (
    val sequence: Long,
    val witness: String,

    @Json(name = "prev_out")
    val prevOut: Out,

    val script: String
)

data class Out (
    val spent: Boolean,

    @Json(name = "tx_index")
    val txIndex: Long,

    val type: Long,
    val addr: String? = null,
    val value: Long,
    val n: Long,
    val script: String
)

enum class RelayedBy(val value: String) {
    The0000("0.0.0.0"),
    The127001("127.0.0.1");

    companion object {
        public fun fromValue(value: String): RelayedBy = when (value) {
            "0.0.0.0"   -> The0000
            "127.0.0.1" -> The127001
            else        -> throw IllegalArgumentException()
        }
    }
}
