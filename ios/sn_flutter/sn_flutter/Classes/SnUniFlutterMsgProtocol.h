//
//  SnUniFlutterMsgProtocol.h
//  Pods
//
//  Created by itfenbao on 2021/3/15.
//
#import <Foundation/Foundation.h>

@protocol SnUniFlutterMsgProtocol <NSObject>

-(void)postMessage:(NSString*)methodName params:(NSDictionary*)params;

@end
