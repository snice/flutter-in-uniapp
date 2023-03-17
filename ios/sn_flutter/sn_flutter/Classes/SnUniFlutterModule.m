//
//  SnUniFlutterModule.m
//  sn_flutter
//
//  Created by itfenbao on 2023/3/17.
//

#import "SnUniFlutterModule.h"
#import "PDRCoreApp.h"
#import "PDRCoreAppManager.h"
#import "PDRCoreAppInfo.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@implementation SnUniFlutterModule

UNI_EXPORT_METHOD(@selector(openFlutter))
- (void)openFlutter {
    NSLog(@"openFlutter==");
    NSString* route = [[NSString alloc] initWithFormat:@"file://%@", [self getRealPath:@"/static/webf.html"]];
    FlutterViewController *flutterViewController =
    [[FlutterViewController alloc] initWithProject:nil initialRoute:route nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController.engine];
    [[self dc_findCurrentShowingViewController] presentViewController:flutterViewController animated:YES completion:nil];
}

// 获取当前显示的 UIViewController
- (UIViewController *)dc_findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}
- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
}

- (NSString*)getRealPath:(NSString*)path {
    if([path hasPrefix:@"file://"]) {
        return [path substringFromIndex:7];
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
    return realPath;
}


@end
