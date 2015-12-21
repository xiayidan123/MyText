/* wowtalkAppDelegate.m
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */                                                                         
#import "WowtalkAppDelegate.h"
#import "CallProcessVC.h"
#import "Database.h"
#import "WowTalkVoipIF.h"
#import "ViewController.h"
#import "tutorialVC2.h"
#define TAB_LOADING_SPLASH 100

@implementation wowtalkAppDelegate

@synthesize window;
@synthesize myTabBarController;
@synthesize myCallProcessVC;
@synthesize _unreadedMessageNumber;
@synthesize _missedCallNumber;
@synthesize _appDidEnterBackground;
@synthesize _isMyCallProcessVCShown;
+ (wowtalkAppDelegate *)sharedAppDelegate
{
    return (wowtalkAppDelegate *) [UIApplication sharedApplication].delegate;
}


#pragma mark -
#pragma mark ApplicationDelegate

-(BOOL)fIsFirstTimeStart{
	return _isFirstTimeStart;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
	_appDidEnterBackground = YES;

    [WowTalkVoipIF fWowTalkServiceEnterBackgroundMode];
   	
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [WowTalkVoipIF fWowTalkServiceEnterActiveMode];

    //});
	if (!_isFirstTimeStart) {
        //option if we want to do sth here
	}
	_isFirstTimeStart = NO;
	_appDidEnterBackground = NO;

}
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{    

	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"atraapp.wowtalkapi.com" forKey:@"domain_preference"];

    [defaults setObject:@"" forKey:@"uid_preference"];
    [defaults setObject:@"" forKey:@"password_preference"];
    
    
    [defaults synchronize];

    

    
    ///////////
    
    

	
    _unreadedMessageNumber = [defaults integerForKey:@"unreaded_message_number"] ;
    if (_unreadedMessageNumber<0) {
        _unreadedMessageNumber =0;
    }
    _missedCallNumber = [defaults integerForKey:@"missed_call_number"] ;
    if (_missedCallNumber<0) {
        _missedCallNumber=0;
    }
    
    
    [self fSetupApplication];
    
    
    
    if (launchOptions && _isFirstTimeStart) {
        [self fHandleRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey ]];
    }

	
	
	return YES;
}

- (void)fSetupApplication{
	_isFirstTimeStart = YES;
	[Database initializeDatabase];
	
	myCallProcessVC = [[CallProcessVC alloc] 
					   initWithNibName:@"CallProcessVC" 
					   bundle:nil];
		

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController* vc = [[ViewController alloc]init];
    tutorialVC2* tv = [[tutorialVC2 alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc];
    myTabBarController = [[UITabBarController alloc] init];

    myTabBarController.viewControllers = [NSArray arrayWithObjects:nav1,tv,nil];
    self.window.rootViewController = myTabBarController;
    [self.window makeKeyAndVisible];
    


    
	[WowTalkVoipIF fSetMakeCallDelegate:self];
    [WowTalkVoipIF fSetCallProcessDelegate:myCallProcessVC];
    
	
    [WowTalkVoipIF fStartWowTalkService];
    
 }


- (void)applicationWillTerminate:(UIApplication *)application {
	[Database teardown];

}

- (void)dealloc {
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Local Notification delegate
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification called");
}



#pragma mark -
#pragma mark APNS registrationDelegate

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken called");
	
}


#pragma mark -
#pragma mark Remote Notification delegate
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError called");
    

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	if (!_appDidEnterBackground) {
		return;
	}
	
	NSLog(@"didReceiveRemoteNotification called");
	
	
	
	[self fHandleRemoteNotification:userInfo];
	_appDidEnterBackground = NO;
}


-(void)fHandleRemoteNotification:(NSDictionary *)userInfo{
	if (userInfo==nil) {
		return;
	}

	NSDictionary* apsDict = [userInfo objectForKey:@"aps"];
	if (!apsDict) {
		NSLog(@"apsDict is null. sth is wrong. ");
		return;
	}
	NSDictionary* alertDict = [apsDict objectForKey:@"alert"];
	if (!alertDict) {
		NSLog(@"alertDict is null. sth is wrong. ");
		return;
	}
	NSLog(@"%@",alertDict);

	NSString* strType =(NSString*) [alertDict objectForKey:@"loc-key"];
	
	if ([strType isEqualToString:@"apns_call"] ) {
		if ([[alertDict objectForKey:@"loc-args"] count]==0) {
			return;
		}
		NSString* strToUser;
		if ([[alertDict objectForKey:@"loc-args"] count]==1) {
			strToUser=[[alertDict objectForKey:@"loc-args"] objectAtIndex:0];
		}
		else {
			strToUser=[[alertDict objectForKey:@"loc-args"] objectAtIndex:1];
		}
		NSLog(@"we need to tell strToUser=%@",strToUser);
		[self displayIncomeCallWaitForCallerCallAgain:strToUser];
		[self performSelector:@selector(fInformWhoJustCallMe:) withObject:strToUser afterDelay:0.5];

	}

	
}

-(void) fInformWhoJustCallMe:(NSString*)strToUser{
    if (![WowTalkVoipIF fNotifyCallerIGetOnline:strToUser]) {
        [self performSelector:@selector(fInformWhoJustCallMe:) withObject:strToUser afterDelay:0.1];
        return;
    }
}




#pragma mark -
#pragma mark WowTalkUIMakeCallDelegate
-(void)displayIncomeCallWaitForCallerCallAgain:(NSString*) username{
    if (_isMyCallProcessVCShown) {
        return;
    }
	[myTabBarController presentViewController:myCallProcessVC animated:NO completion:nil];
	[myCallProcessVC fdisplayIncomeCallWaitForCallerCallAgain:username];
//    [myCallProcessVC performSelector:@selector(fdisplayIncomeCallWaitForCallerCallAgain:)withObject:username];
}


-(void) displayOutgoingCallForUser:(NSString*) username withDisplayName:(NSString *)displayname withVideo:(BOOL)videoFlag{
    if (_isMyCallProcessVCShown) 
    {
        return;
    }
	[myTabBarController presentViewController:myCallProcessVC animated:NO completion:nil];
	[myCallProcessVC fDisplayCallOutgoingViewforUser:username withVideo:videoFlag];
//    [myCallProcessVC performSelector:@selector(fdisplayIncomeCallWaitForCallerCallAgain:)withObject:videoFlag];

	
}
-(void) displayIncomingCallForUser:(NSString*) username withDisplayName:(NSString *)displayname withVideo:(BOOL)videoFlag {
    
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] 
		&& [UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground) {
		// Create a new notification
		UILocalNotification* notif = [[[UILocalNotification alloc] init] autorelease];
		if (notif)
		{
			notif.repeatInterval = 0;
			notif.alertBody =[NSString  stringWithFormat:NSLocalizedString(@" %@ is calling you",nil),username];
			notif.alertAction = NSLocalizedString(@"Answer",nil);
			notif.soundName = @"JakeFive.aif";
			
			[[UIApplication sharedApplication]  presentLocalNotificationNow:notif];
		}
	} else 	{
        if (_isMyCallProcessVCShown){
            if(![myCallProcessVC fIsWaitingForCallerCallAgain]) {
                return;
            }       
        }
        else{
            [myTabBarController presentViewController:myCallProcessVC animated:NO completion:nil];
        }
		[myCallProcessVC fDisplayCallIncomingViewforUser:username withVideo:videoFlag];

	}
	
    
    
}

-(void)getBuddyListUpdateNotification{
    NSLog(@"getBuddyListUpdateNotification");
}




@end