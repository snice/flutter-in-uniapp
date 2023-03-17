//
//  ViewController.h
//  Pandora
//
//  Created by Mac Pro_C on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDRCore.h"

@interface ViewController : UIViewController<PDRCoreDelegate>
{
    BOOL _isFullScreen;
    UIStatusBarStyle _statusBarStyle;
}
@property(assign, nonatomic)BOOL showLoadingView;
-(BOOL)getStatusBarHidden;
@end
