//
//  SnUniMsgDispatcher.m
//  FBSDKCoreKit
//
//  Created by itfenbao on 2021/3/15.
//

#import "SnUniMsgDispatcher.h"

@interface SnUniMsgDispatcher ()
@property(nonatomic, strong) NSMutableDictionary<NSString *, id <SnUniFlutterMsgProtocol>> *messageMap;
@property(nonatomic, strong) NSMutableDictionary<NSString *, UniModuleKeepAliveCallback> *callbackMap;
@property(nonatomic, strong) NSMutableDictionary<NSString *, FlutterResult> *resultMap;
@end

@implementation SnUniMsgDispatcher

static SnUniMsgDispatcher *instance = nil;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SnUniMsgDispatcher alloc] init];
        instance.messageMap = [NSMutableDictionary dictionary];
        instance.callbackMap = [NSMutableDictionary dictionary];
        instance.resultMap = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (void)addMsgProtocol:(NSString *)instanceId protocol:(id <SnUniFlutterMsgProtocol>)protocol {
    [self.messageMap setValue:protocol forKey:instanceId];
}

- (void)removeMsgProtol:(NSString *)instanceId {
    [self.messageMap removeObjectForKey:instanceId];
}

- (void)addUniCallback:(NSString *)callbackId callback:(UniModuleKeepAliveCallback)callback {
    [self.callbackMap setObject:callback forKey:callbackId];
}

- (void)addFlutterCallback:(NSString *)callbackId callback:(FlutterResult)callback {
    [self.resultMap setObject:callback forKey:callbackId];
}

- (void)postMessage:(NSString *)instanceId method:(NSString *)method params:(NSDictionary *)params {
    [[self.messageMap objectForKey:instanceId] postMessage:method params:params];
}

- (void)invokeUniCallback:(NSString *)callbackId params:(NSDictionary *)params {
    UniModuleKeepAliveCallback callback = [self.callbackMap objectForKey:callbackId];
    if (callback) {
        callback(params, NO);
        [self.callbackMap removeObjectForKey:callbackId];
    }
}

- (void)invokeKeepAliveUniCallback:(NSString *)callbackId params:(NSDictionary *)params {
    UniModuleKeepAliveCallback callback = [self.callbackMap objectForKey:callbackId];
    if (callback) {
        callback(params, YES);
    }
}

- (void)invokeFlutterCallback:(NSString *)callbackId params:(NSDictionary *)params {
    FlutterResult result = [self.resultMap objectForKey:callbackId];
    if (result) {
        result(params);
        [self.resultMap removeObjectForKey:callbackId];
    }
}

@end
