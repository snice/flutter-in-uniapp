//
//  SnUniFlutterProxy.m
//  sn-flutter
//
//  Created by itfenbao on 2021/2/25.
//

#import "SnUniFlutterProxy.h"
#import "SnUniFlutterProxy_Internal.h"
#import "SnUniMsgDispatcher.h"
#import "Flutter/Flutter.h"

@interface SnUniFlutterProxy ()
@property(nonatomic, strong) NSMutableDictionary *cacheEngineDic;
@property(nonatomic, strong) FlutterEngineGroup *engineGroup;
@end

@implementation SnUniFlutterProxy {
    FlutterPluginAppLifeCycleDelegate *_lifeCycleDelegate;
}

static SnUniFlutterProxy *proxyInstance = nil;

+ (instancetype)proxy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxyInstance = [[SnUniFlutterProxy alloc] init];
        proxyInstance.cacheEngineDic = [NSMutableDictionary dictionary];
        proxyInstance.engineGroup = [[FlutterEngineGroup alloc] initWithName:@"uniapp-flutter-engine-group" project:nil];
        // default engine
//        [proxyInstance.engineGroup makeEngineWithEntrypoint:@"main" libraryURI:nil];
    });
    return proxyInstance;
}

- (FlutterEngine *)createEngine:(NSString *)entryPoint withInitialRoute:(NSString *)initialRoute {
    return [_engineGroup makeEngineWithEntrypoint:entryPoint libraryURI:nil initialRoute:initialRoute];
}

- (void)put:(NSString *)engineId engine:(FlutterEngine *)engine {
//    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
//      [center addObserver:self
//                 selector:@selector(onEngineWillBeDealloced:)
//                     name:@"FlutterEngineWillDealloc"
//                   object:engine];
    if(engineId == nil || engine == nil) {
        return;
    }
    [self.cacheEngineDic setValue:engine forKey:engineId];
}

- (FlutterEngine *)get:(NSString *)engineId {
    if(engineId == nil) {
        return nil;
    }
    return [self.cacheEngineDic objectForKey:engineId];
}

- (void)remove:(NSString *)engineId {
    if(engineId == nil) {
        return;
    }
    [self.cacheEngineDic removeObjectForKey:engineId];
}

- (void)invokeUniCallback:(id)args {
    NSDictionary *json = args;
    if (json && json[@"callbackId"]) {
        NSString *callbackId = json[@"callbackId"];
        BOOL keepAlive = json[@"keepAlive"];
        NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:json];
        [newParams removeObjectForKey:@"callbackId"];
        if (keepAlive == YES) {
            [[SnUniMsgDispatcher share] invokeKeepAliveUniCallback:callbackId params:newParams];
        } else {
            [[SnUniMsgDispatcher share] invokeUniCallback:callbackId params:newParams];
        }
    }
}

- (void)onCreateUniPlugin {
    // 初始化
    [SnUniFlutterProxy proxy];
    _lifeCycleDelegate = [[FlutterPluginAppLifeCycleDelegate alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [_lifeCycleDelegate application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [_lifeCycleDelegate application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [_lifeCycleDelegate application:application didReceiveLocalNotification:notification];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [_lifeCycleDelegate application:application handleOpenURL:url];
    return YES;
}

@end
