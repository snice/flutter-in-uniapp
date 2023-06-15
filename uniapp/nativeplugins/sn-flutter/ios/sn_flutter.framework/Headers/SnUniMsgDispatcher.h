//
//  SnUniMsgDispatcher.h
//  FBSDKCoreKit
//
//  Created by itfenbao on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import "SnUniFlutterMsgProtocol.h"
#import "DCUniModule.h"
#import "Flutter/Flutter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SnUniMsgDispatcher : NSObject

+ (instancetype)share;

- (void)addMsgProtocol:(NSString *)instanceId protocol:(id<SnUniFlutterMsgProtocol>)protocol;

- (void)removeMsgProtol:(NSString *)instanceId;

- (void)addUniCallback:(NSString *)callbackId callback:(UniModuleKeepAliveCallback)callback;

- (void)addFlutterCallback:(NSString *)callbackId callback:(FlutterResult)callback;

- (void)postMessage:(NSString *)instanceId method:(NSString *)method params:(NSDictionary *)params;

- (void)invokeUniCallback:(NSString *)callbackId params:(NSDictionary *)params;

- (void)invokeKeepAliveUniCallback:(NSString *)callbackId params:(NSDictionary *)params;

- (void)invokeFlutterCallback:(NSString *)callbackId params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
