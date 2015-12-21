//
//  SharedAlertView.h
//  wowcity
//
//  Created by elvis on 2013/06/08.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningView : UIView
{
    BOOL isShown;
    
}

@property (nonatomic,retain) NSError* error;

@property BOOL autoDismiss;
@property int lastTime;

+(WarningView*)sharedView;
+(WarningView*)sharedViewWithString:(NSString *) info;

-(void)showAlert:(NSError*)error;

//-(void)hideAlert;

@end