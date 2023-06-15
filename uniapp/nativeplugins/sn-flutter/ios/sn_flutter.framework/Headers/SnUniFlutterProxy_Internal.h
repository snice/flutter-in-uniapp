//
//  SnUniFlutterProxy_Internal.h
//  Pods
//
//  Created by itfenbao on 2021/3/15.
//

#import "Flutter/Flutter.h"

@interface SnUniFlutterProxy ()

+ (instancetype)proxy;

- (FlutterEngine *)createEngine:(NSString *)entryPoint withInitialRoute:(NSString*)initialRoute;

- (void)put:(NSString *)engineId engine:(FlutterEngine *)engine;

- (FlutterEngine *)get:(NSString *)engineId;

- (void)remove:(NSString *)engineId;

- (void)invokeUniCallback:(id)args;

@end
