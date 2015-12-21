///* UICallButton.m
// *
// *  wowtalk
// *
// *  Created by eki-chin on 11/03/19.
// *  Copyright 2011 WowTech Inc.. All rights reserved.
// * 
// */        
//
//#import "UICallButton.h"
//#import "WowTalkVoipIF.h"
//#import "WowtalkAppDelegate.h"
//#import "ABUtil.h"
//#import "PhonePadVC.h"
//#import "WowTalkWebServerIF.h"
//#import "TagHandler.h"
//#import "NetworkSingleton.h"
//
//@implementation UICallButton
//
//@synthesize mCalleeNumber;
//@synthesize mAddress;
//
//-(void) touchUp:(id) sender {
//    
////    [self setBackgroundColor:[Theme sharedInstance].currentTileColor];
////    self.titleLabel.textColor = [Colors whiteColor];
//    
//    self.mCalleeNumber = [ABUtil fTranslatePhoneNumberToUserName:self.mAddress.text];
//    
//    if(self.mCalleeNumber==nil) return;
//    
//   // [self setBackgroundColor:[Theme sharedInstance].currentTileColor];
//
//	
//	if ( ![WowTalkVoipIF fIsConnectedToServer]  )
//    {
//        [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] PopUpForRegularCall];
//        return;
//	}
//    
//    // if call from the dialpad, have to hide the pad first!
//    [[wowtalkAppDelegate sharedAppDelegate] setIsCallFromDialPad:YES];
//  
//    Buddy* buddy = [[ABUtil sharedInstance] WowTalkUserWithNumber:self.mCalleeNumber];
//    
//    if (buddy == nil)
//    {
//        
//        int tag = [TagHandler tagForScanPhoneNumber];
//        NSString* name = [TagHandler notificationNameForTag:tag WithPrefix:SCANPHONENUMBER];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScanPhoneNumber:) name:name object:nil];
//        
//        [[NetworkSingleton sharedManager] scanPhoneNumbersForBuddy:[NSArray arrayWithObject:self.mCalleeNumber] withTag:tag];
//        
//    }
//    else
//    {
//        [WowTalkVoipIF fNewOutgoingCall:buddy.userID withDisplayName:self.mAddress.text];
//        [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] dismissThePad:nil];
//    
//    }
// 
//
//}
//
//#pragma mark -- network callback
//-(void)didScanPhoneNumber:(NSNotification*) notif
//{
//    BOOL result = [[notif.userInfo valueForKey:RESULT] boolValue];
//    
//    if (result)
//    {
//        if(self.mCalleeNumber ==nil) return;
//        
//        Buddy* buddy = [Database buddyWithPhoneNumber: [WowTalkWebServerIF fEncriptedPhoneNumber:self.mCalleeNumber]];
//        
//        if (buddy == nil)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mAddress.text]]];
//         
//            [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] dismissThePad:nil];
//            return;
//        }
//        
//        if(![WowTalkVoipIF fNewOutgoingCall:buddy.userID withDisplayName:self.mAddress.text])
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mAddress.text]]];
//         
//            [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] dismissThePad:nil];
//            return;
//        }
//        else
//        {
//            [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] dismissThePad:nil];
//            return;
//            
//        }
//        
//        
//    }
//    
//    else
//    {
//        //MAy have problem
//        BOOL networkfailed = [[notif.userInfo valueForKey:NETWORKFAILED] boolValue];
//        if (networkfailed)
//        {
//            [[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] PopUpForRegularCall];  
//        }
//    
//    }
//    
//    
//    NSString* name = [notif.userInfo valueForKey:NAME];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
//    
//}
//
//
//
//-(void) touchDown:(id) sender {
////    [self setBackgroundColor:[Theme sharedInstance].currentNormalWidgetBackgroundColor];
////    self.titleLabel.textColor = [Theme sharedInstance].currentNormalTextColor;
//    if (![self.mAddress.text isEqualToString:@""]) {
//        [self setTitle:@"" forState:UIControlStateNormal];
//    }
//}
//
//
//#pragma mark -
//#pragma mark - UIAlertViewDelegate
//
//
//-(void) initWithAddress:(UILabel*) address{
//   // mAddress=[address retain];
//    self.mAddress = address;
//    
//    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
////	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
//
//	[self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//	[self setTitle:NSLocalizedString(@"Call",nil) forState:UIControlStateNormal];
//  //  [self setBackgroundImage:[[Theme sharedInstance]pngImageWithName:CALLBUTTON_BG] forState:UIControlStateNormal];
////    [self setBackgroundColor:[Theme sharedInstance].currentTileColor];
//}
//
//
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.mAddress = nil;
//    self.mCalleeNumber =nil;
//    [super dealloc];
//	
//}
//
//
//
//
//
//@end
