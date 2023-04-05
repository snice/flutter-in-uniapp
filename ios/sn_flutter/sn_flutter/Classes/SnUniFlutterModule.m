//
//  SnUniFlutterModule.m
//  sn-flutter
//
//  Created by itfenbao on 2021/2/25.
//
#import "PDRCoreApp.h"
#import "PDRCoreAppManager.h"
#import "PDRCoreAppInfo.h"
#import "SnUniFlutterModule.h"
#import "SnUniFlutterViewController.h"
#import "SnUniMsgDispatcher.h"
#import "SnUniFlutterProxy.h"
#import "SnUniFlutterProxy_Internal.h"

@implementation SnUniFlutterModule

UNI_EXPORT_METHOD(@selector(cachePages:))

- (void)cachePages:(NSDictionary *)json {
//    if (json[@"pages"]) {
//        NSArray<NSString *> *pages = json[@"pages"];
//        for (NSString *key in pages) {
//            FlutterEngine *engine = [[SnUniFlutterProxy proxy] createEngine:key];
//            [[SnUniFlutterProxy proxy] put:key engine:engine];
//        }
//    }
}

UNI_EXPORT_METHOD(@selector(cacheEntryPoints:))

- (void)cacheEntryPoints:(NSDictionary *)json {
//    for (NSString *key in json.allKeys) {
//        FlutterEngine *engine = [[SnUniFlutterProxy proxy] createEngine:json[key]];
//        [[SnUniFlutterProxy proxy] put:key engine:engine];
//    }
}

UNI_EXPORT_METHOD(@selector(openWebf:))

- (void)openWebf:(NSDictionary *)json {
    NSMutableDictionary *newJson = [NSMutableDictionary dictionaryWithDictionary:json];
    if(json[@"url"]) {
        NSString *fullPath = [self getRealPath:json[@"url"]];
        [newJson setObject:fullPath forKey:@"initialRoute"];
    }
    [self openFlutter:newJson];
}

UNI_EXPORT_METHOD(@selector(openFlutter:))

- (void)openFlutter:(NSDictionary *)json {
    SnUniFlutterViewController *page = [[SnUniFlutterViewController alloc] initWithParams:json];
    [[self dc_findCurrentShowingViewController].navigationController pushViewController:page animated:YES];
}

UNI_EXPORT_METHOD(@selector(postMessage:))

- (void)postMessage:(NSDictionary *)json {
    NSString *instanceId = json[@"instanceId"];
    NSDictionary *params = json[@"params"];
    NSString *method = params[@"method"];
    [[SnUniMsgDispatcher share] postMessage:instanceId method:method params:params[@"params"]];
}

UNI_EXPORT_METHOD(@selector(postMessageWithCallback:callback:))

- (void)postMessageWithCallback:(NSDictionary *)json callback:(UniModuleKeepAliveCallback)callback {
    NSString *instanceId = json[@"instanceId"];
    NSDictionary *params = json[@"params"];
    NSString *method = params[@"method"];

    NSDictionary *innerParams = params[@"params"];
    NSMutableDictionary *cParams = [NSMutableDictionary dictionaryWithDictionary:innerParams];
    NSString *callbackId = [NSString stringWithFormat:@"%@-%@-%@", instanceId, method, [self getRandomString]];
    [cParams setObject:callbackId forKey:@"callbackId"];
    [[SnUniMsgDispatcher share] postMessage:instanceId method:method params:cParams];
}

UNI_EXPORT_METHOD(@selector(invokeMethodCallback:))

- (void)invokeMethodCallback:(NSDictionary *)json {
    NSString *callbackId = json[@"callbackId"];
    [[SnUniMsgDispatcher share] invokeFlutterCallback:callbackId params:json[@"params"]];
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

- (NSString *)getRandomString {
    static int kNumber = 15;

    NSString *sourceStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (NSString*)getRealPath:(NSString*)path {
    if([path hasPrefix:@"file://"] || [path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        return path;
    }
    PDRCoreAppInfo *appinfo = [PDRCore Instance].appManager.getMainAppInfo;
    BOOL isDoc = [path hasPrefix:@"_doc/"];
    NSString *basePath = isDoc ? appinfo.documentPath : appinfo.wwwPath;
    NSString *realPath;
    if(isDoc) {
        realPath = [basePath stringByAppendingPathComponent:[path substringFromIndex:4]];
    } else {
        realPath = [basePath stringByAppendingPathComponent:path];
    }
    return [[NSString alloc] initWithFormat:@"file://%@", realPath];
}

@end
