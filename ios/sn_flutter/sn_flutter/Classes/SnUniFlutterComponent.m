//
//  SnUniFlutterComponent.m
//  sn-flutter
//
//  Created by itfenbao on 2021/2/25.
//

#import "SnUniFlutterConstants.h"
#import "SnUniFlutterComponent.h"
#import "SnUniFlutterProxy.h"
#import "SnUniFlutterProxy_Internal.h"
#import "SnUniMsgDispatcher.h"
#import "weexHeader/WXSDKEngine.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@implementation SnUniFlutterComponent {
    NSString *instanceId;
    NSString *cacheId;
    NSString *entryPoint;
    NSString *initialRoute;
    NSDictionary *initParams;
    BOOL destroyAfterBack;
    FlutterViewController *vc;
    FlutterEngine *engine;
    FlutterMethodChannel *channel;
}

- (UIView *)loadView {
    return vc.view;
}

- (void)viewDidLoad {
    [GeneratedPluginRegistrant registerWithRegistry:vc];
    [self goToApplicationLifecycle:@"AppLifecycleState.resumed"];
}

- (void)viewWillUnload {
    vc = NULL;
    if (instanceId) {
        [[SnUniMsgDispatcher share] removeMsgProtol:instanceId];
    }
    [channel setMethodCallHandler:nil];
    channel = nil;
    if (destroyAfterBack) {
        [[SnUniFlutterProxy proxy] remove:cacheId];
    }
    [super viewWillUnload];
}

- (void)dealloc {
    NSLog(@"Component dealloc");
}

UNI_EXPORT_METHOD(@selector(hide))
- (void)hide {}

UNI_EXPORT_METHOD(@selector(show))
- (void)show {}

- (void)onCreateComponentWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events uniInstance:(DCUniSDKInstance *)uniInstance {
    if (attributes[@"instanceId"]) {
        instanceId = attributes[@"instanceId"];
    }
    if (attributes[@"initialRoute"]) {
        initialRoute = attributes[@"initialRoute"];
    }
    if (attributes[@"cacheId"]) {
        cacheId = attributes[@"cacheId"];
    }
    if (attributes[@"entryPoint"]) {
        entryPoint = attributes[@"entryPoint"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setEntryPoint:entryPoint];
            vc = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
        });
    }
    if (attributes[@"destroyAfterBack"]) {
        destroyAfterBack = attributes[@"destroyAfterBack"];
    } else {
        destroyAfterBack = YES;
    }
    if (attributes[@"params"]) {
        initParams = attributes[@"params"];
    }
    if (instanceId) {
        [[SnUniMsgDispatcher share] addMsgProtocol:instanceId protocol:self];
    }
}

- (void)setEntryPoint:(NSString *)entryPoint {
    engine = [[SnUniFlutterProxy proxy] get:cacheId];
    if (engine == nil) {
        engine = [[SnUniFlutterProxy proxy] createEngine:entryPoint withInitialRoute:initialRoute];
        if(cacheId) {
            [[SnUniFlutterProxy proxy] put:cacheId engine:engine];
        }
    }
    channel = [FlutterMethodChannel methodChannelWithName:CHANNEL binaryMessenger:engine.binaryMessenger];

    __weak typeof(self) weakself = self;
    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSLog([[NSString alloc] initWithFormat:@"component:%@, %@", call.method, call.arguments]);
        if ([CAN_POP isEqualToString:call.method]) {
            BOOL pop = [call.arguments boolValue];
            [weakself fireEvent:POP_CHANGE params:@{@"detail": @{@"pop": @(pop)}}];
            result(@(YES));
        } else if ([POP isEqualToString:call.method]) {
            [weakself fireEvent:POP params:nil];
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

- (void)postMessage:(NSString *)methodName params:(NSDictionary *)params {
    [channel invokeMethod:methodName arguments:params];
}

// Make this transition only while this current view controller is visible.
- (void)goToApplicationLifecycle:(nonnull NSString *)state {
    if (engine) {
        [engine.lifecycleChannel sendMessage:state];
    }
}

// 获取当前显示的 UIViewController
- (UIViewController *)dc_findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc {
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *) vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *) vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }

    return currentShowingVC;
}

@end
