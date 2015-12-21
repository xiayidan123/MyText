//
//  StatusBar.h
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusBar : UIWindow


+(id)sharedStatusBar;


-(void)showMsgInStatusBar:(NSString*)strMsg;

@end
