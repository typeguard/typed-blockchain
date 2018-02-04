#import "blockchain.h"

#define λ(decl, expr) (^(decl) { return (expr); })

static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

@interface QTLatestBlock (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTUnconfirmedTransactions (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTTx (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTInput (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTOut (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@implementation QTWitness
+ (NSDictionary<NSString *, QTWitness *> *)values
{
    static NSDictionary<NSString *, QTWitness *> *values;
    return values = values ? values : @{
        @"": [[QTWitness alloc] initWithValue:@""],
    };
}

+ (QTWitness *)empty { return QTWitness.values[@""]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTWitness.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation QTRelayedBy
+ (NSDictionary<NSString *, QTRelayedBy *> *)values
{
    static NSDictionary<NSString *, QTRelayedBy *> *values;
    return values = values ? values : @{
        @"0.0.0.0": [[QTRelayedBy alloc] initWithValue:@"0.0.0.0"],
        @"127.0.0.1": [[QTRelayedBy alloc] initWithValue:@"127.0.0.1"],
    };
}

+ (QTRelayedBy *)the0000 { return QTRelayedBy.values[@"0.0.0.0"]; }
+ (QTRelayedBy *)the127001 { return QTRelayedBy.values[@"127.0.0.1"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTRelayedBy.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

QTLatestBlock *_Nullable QTLatestBlockFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [QTLatestBlock fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

QTLatestBlock *_Nullable QTLatestBlockFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return QTLatestBlockFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable QTLatestBlockToData(QTLatestBlock *latestBlock, NSError **error)
{
    @try {
        id json = [latestBlock JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable QTLatestBlockToJSON(QTLatestBlock *latestBlock, NSStringEncoding encoding, NSError **error)
{
    NSData *data = QTLatestBlockToData(latestBlock, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

QTUnconfirmedTransactions *_Nullable QTUnconfirmedTransactionsFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [QTUnconfirmedTransactions fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

QTUnconfirmedTransactions *_Nullable QTUnconfirmedTransactionsFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return QTUnconfirmedTransactionsFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable QTUnconfirmedTransactionsToData(QTUnconfirmedTransactions *unconfirmedTransactions, NSError **error)
{
    @try {
        id json = [unconfirmedTransactions JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable QTUnconfirmedTransactionsToJSON(QTUnconfirmedTransactions *unconfirmedTransactions, NSStringEncoding encoding, NSError **error)
{
    NSData *data = QTUnconfirmedTransactionsToData(unconfirmedTransactions, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation QTLatestBlock
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"hash": @"theHash",
        @"time": @"time",
        @"block_index": @"blockIndex",
        @"height": @"height",
        @"txIndexes": @"txIndexes",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return QTLatestBlockFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTLatestBlockFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTLatestBlock alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:QTLatestBlock.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTLatestBlock.properties.allValues] mutableCopy];

    for (id jsonName in QTLatestBlock.properties) {
        id propertyName = QTLatestBlock.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return QTLatestBlockToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTLatestBlockToJSON(self, encoding, error);
}
@end

@implementation QTUnconfirmedTransactions
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"txs": @"txs",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return QTUnconfirmedTransactionsFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTUnconfirmedTransactionsFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTUnconfirmedTransactions alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _txs = map(_txs, λ(id x, [QTTx fromJSONDictionary:x]));
    }
    return self;
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTUnconfirmedTransactions.properties.allValues] mutableCopy];

    [dict addEntriesFromDictionary:@{
        @"txs": map(_txs, λ(id x, [x JSONDictionary])),
    }];

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return QTUnconfirmedTransactionsToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTUnconfirmedTransactionsToJSON(self, encoding, error);
}
@end

@implementation QTTx
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"ver": @"ver",
        @"inputs": @"inputs",
        @"weight": @"weight",
        @"relayed_by": @"relayedBy",
        @"out": @"out",
        @"lock_time": @"lockTime",
        @"size": @"size",
        @"rbf": @"rbf",
        @"double_spend": @"isDoubleSpend",
        @"time": @"time",
        @"tx_index": @"txIndex",
        @"vin_sz": @"vinSz",
        @"hash": @"theHash",
        @"vout_sz": @"voutSz",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTTx alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _inputs = map(_inputs, λ(id x, [QTInput fromJSONDictionary:x]));
        _relayedBy = [QTRelayedBy withValue:(id)_relayedBy];
        _out = map(_out, λ(id x, [QTOut fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:QTTx.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTTx.properties.allValues] mutableCopy];

    for (id jsonName in QTTx.properties) {
        id propertyName = QTTx.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    [dict addEntriesFromDictionary:@{
        @"inputs": map(_inputs, λ(id x, [x JSONDictionary])),
        @"relayed_by": [_relayedBy value],
        @"out": map(_out, λ(id x, [x JSONDictionary])),
        @"double_spend": _isDoubleSpend ? @YES : @NO,
    }];

    return dict;
}
@end

@implementation QTInput
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"sequence": @"sequence",
        @"witness": @"witness",
        @"prev_out": @"prevOut",
        @"script": @"script",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTInput alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _witness = [QTWitness withValue:(id)_witness];
        _prevOut = [QTOut fromJSONDictionary:(id)_prevOut];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:QTInput.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTInput.properties.allValues] mutableCopy];

    for (id jsonName in QTInput.properties) {
        id propertyName = QTInput.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    [dict addEntriesFromDictionary:@{
        @"witness": [_witness value],
        @"prev_out": [_prevOut JSONDictionary],
    }];

    return dict;
}
@end

@implementation QTOut
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"spent": @"isSpent",
        @"tx_index": @"txIndex",
        @"type": @"type",
        @"addr": @"addr",
        @"value": @"value",
        @"n": @"n",
        @"script": @"script",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTOut alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:QTOut.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTOut.properties.allValues] mutableCopy];

    for (id jsonName in QTOut.properties) {
        id propertyName = QTOut.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    [dict addEntriesFromDictionary:@{
        @"spent": _isSpent ? @YES : @NO,
    }];

    return dict;
}
@end

NS_ASSUME_NONNULL_END
