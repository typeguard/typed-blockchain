// To parse this JSON:
//
//   NSError *error;
//   QTLatestBlock *latestBlock = [QTLatestBlock fromJSON:json encoding:NSUTF8Encoding error:&error]
//   QTUnconfirmedTransactions *unconfirmedTransactions = [QTUnconfirmedTransactions fromJSON:json encoding:NSUTF8Encoding error:&error]

#import <Foundation/Foundation.h>

@class QTLatestBlock;
@class QTUnconfirmedTransactions;
@class QTTx;
@class QTInput;
@class QTOut;
@class QTRelayedBy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface QTRelayedBy : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (QTRelayedBy *)the0000;
+ (QTRelayedBy *)the127001;
@end

#pragma mark - Object interfaces

@interface QTLatestBlock : NSObject
@property (nonatomic, copy)   NSString *theHash;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger blockIndex;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy)   NSArray<NSNumber *> *txIndexes;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTUnconfirmedTransactions : NSObject
@property (nonatomic, copy) NSArray<QTTx *> *txs;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTTx : NSObject
@property (nonatomic, assign)           NSInteger ver;
@property (nonatomic, copy)             NSArray<QTInput *> *inputs;
@property (nonatomic, assign)           NSInteger weight;
@property (nonatomic, assign)           QTRelayedBy *relayedBy;
@property (nonatomic, copy)             NSArray<QTOut *> *out;
@property (nonatomic, assign)           NSInteger lockTime;
@property (nonatomic, assign)           NSInteger size;
@property (nonatomic, nullable, strong) NSNumber *rbf;
@property (nonatomic, assign)           BOOL isDoubleSpend;
@property (nonatomic, assign)           NSInteger time;
@property (nonatomic, assign)           NSInteger txIndex;
@property (nonatomic, assign)           NSInteger vinSz;
@property (nonatomic, copy)             NSString *theHash;
@property (nonatomic, assign)           NSInteger voutSz;
@end

@interface QTInput : NSObject
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, copy)   NSString *witness;
@property (nonatomic, strong) QTOut *prevOut;
@property (nonatomic, copy)   NSString *script;
@end

@interface QTOut : NSObject
@property (nonatomic, assign) BOOL isSpent;
@property (nonatomic, assign) NSInteger txIndex;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString *addr;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, copy)   NSString *script;
@end

NS_ASSUME_NONNULL_END
