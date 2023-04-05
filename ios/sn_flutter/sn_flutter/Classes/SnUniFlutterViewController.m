//
//  SnUniFlutterPage.m
//  sn-flutter
//
//  Created by itfenbao on 2021/3/15.
//

#import "SnUniFlutterViewController.h"
#import "SnUniFlutterConstants.h"
#import "SnUniFlutterProxy.h"
#import "SnUniFlutterProxy_Internal.h"
#import "SnUniMsgDispatcher.h"
#import "weexHeader/WXSDKEngine.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@implementation SnUniFlutterViewController {
    NSString *instanceId;
    NSString *cacheId;
    NSString *entryPoint;
    NSString *initialRoute;
    FlutterMethodChannel *channel;
    NSDictionary *initParams;
    BOOL canPop;
    BOOL destroyAfterBack;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    instanceId = params[@"instanceId"];
    initialRoute = params[@"initialRoute"];
    entryPoint = params[@"entryPoint"];
    cacheId = params[@"cacheId"];
    if (params[@"destroyAfterBack"]) {
        destroyAfterBack = [params[@"destroyAfterBack"] boolValue];
    } else {
        destroyAfterBack = YES;
    }
    initParams = params[@"params"];
    FlutterEngine *engine = [[SnUniFlutterProxy proxy] get:cacheId];
    if (engine == nil) {
        engine = [[SnUniFlutterProxy proxy] createEngine:entryPoint withInitialRoute:initialRoute];
        if(cacheId) {
            [[SnUniFlutterProxy proxy] put:cacheId engine:engine];
        }
    }
    return [super initWithEngine:engine nibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [GeneratedPluginRegistrant registerWithRegistry:self];
    self.view.backgroundColor = UIColor.whiteColor;
    if (instanceId) {
        [[SnUniMsgDispatcher share] addMsgProtocol:instanceId protocol:self];
    }
    channel = [FlutterMethodChannel methodChannelWithName:CHANNEL binaryMessenger:self.engine.binaryMessenger];
    __weak typeof(self) weakself = self;
    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSLog([[NSString alloc] initWithFormat:@"vc:%@, %@", call.method, call.arguments]);
        if ([CAN_POP isEqualToString:call.method]) {
            BOOL pop = [call.arguments boolValue];
            canPop = pop;
            weakself.navigationController.interactivePopGestureRecognizer.enabled = !pop;
            result(@(YES));
        } else if ([POP isEqualToString:call.method]) {
            if (canPop == NO) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            result(@(YES));
        } else if ([GET_PARAMS isEqualToString:call.method]) {
            result(initParams);
        } else if ([CALL_BACK_METHOD isEqualToString:call.method]) {
            if (call.arguments) {
                [[SnUniFlutterProxy proxy] invokeUniCallback:call.arguments];
            }
        } else {
            NSString *eventName = [NSString stringWithFormat:@"%@&%@", FLUTTER_MESSAGE, instanceId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:call.method forKey:@"method"];
            if (call.arguments) {
                NSDictionary *args = call.arguments;
                if (args[@"callbackId"]) {
                    [[SnUniMsgDispatcher share] addFlutterCallback:args[@"callbackId"] callback:result];
                }
                [params setValue:args forKey:@"params"];
            }
            [[WXSDKEngine topInstance] fireGlobalEvent:eventName params:params];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (instanceId) {
        [[SnUniMsgDispatcher share] removeMsgProtol:instanceId];
    }
    [channel setMethodCallHandler:nil];
    channel = nil;
    if (destroyAfterBack) {
        [[SnUniFlutterProxy proxy] remove:cacheId];
    }
}

//- (void)dealloc {
//    NSLog(@"page dealloc");
//}

- (void)postMessage:(NSString *)methodName params:(NSDictionary *)params {
    [channel invokeMethod:methodName arguments:params];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return !canPop;
}

@end
