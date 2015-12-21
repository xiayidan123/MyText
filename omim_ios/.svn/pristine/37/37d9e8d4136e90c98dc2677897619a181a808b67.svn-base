/* WowtalkAppDelegate.h
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */                                                                          


#import <UIKit/UIKit.h>
#import "WowtalkUIDelegates.h"

#define HISTORY_TAB_INDEX 0
#define CONTACTS_TAB_INDEX 1
#define DIALER_TAB_INDEX 2
#define MESSAGES_TAB_INDEX 3
#define MYPAGE_TAB_INDEX 4



@class ContactPickerDelegate;
@class CallProcessVC;

@interface wowtalkAppDelegate : NSObject <UIApplicationDelegate, WowTalkUIMakeCallDelegate> {
    UIWindow *window;
	UITabBarController*  myTabBarController;
	CallProcessVC* myCallProcessVC;
	

	NSString* callerToInform;
	
	BOOL _isFirstTimeStart;
	BOOL _appDidEnterBackground;
	
    BOOL _isMyCallProcessVCShown;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController*  myTabBarController;
@property (nonatomic, retain) CallProcessVC* myCallProcessVC;

@property (assign) NSInteger _unreadedMessageNumber;
@property (assign) NSInteger _missedCallNumber;
@property (assign) BOOL _appDidEnterBackground;
@property (assign) BOOL _isMyCallProcessVCShown;

-(void)fSetupApplication;
-(BOOL)fIsFirstTimeStart;

-(void)fHandleRemoteNotification:(NSDictionary *)userInfo;
-(void)displayIncomeCallWaitForCallerCallAgain:(NSString*) username;

+ (wowtalkAppDelegate *)sharedAppDelegate;

@end

