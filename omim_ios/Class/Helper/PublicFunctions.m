//
//  PublicFunctions.m
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "PublicFunctions.h"
#import "Constants.h"
#import "AddressBookManager.h"
#import "AddressBook.h"

#import "CustomNavButton.h"
#import <mach/mach_time.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "TabBarViewController.h"

#import "GlobalSetting.h"

#import "WTHeader.h"

#import <QuartzCore/QuartzCore.h>
@implementation PublicFunctions

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝reload the whole photo lib＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
        
    });
    
    return library;
}



+ (UIBarButtonItem *)getCustomNavButtonOnLeftSide:(BOOL)leftSide target:(id)tar image:(UIImage *)image selector:(SEL)selector
{
    
    CustomNavButton *navButton = [[CustomNavButton alloc] initWithFrame:CGRectMake(0, 0, NAV_BUTTON_WIDTH, NAV_BUTTON_WIDTH) isOnLeft:leftSide];

    [navButton setImage:image forState:UIControlStateNormal];

    [navButton addTarget:tar action:selector forControlEvents:UIControlEventTouchUpInside];

#warning 内存问题。。。 修改完需要彻查 这个方法创建的UIBarButtonItem，暂不修改
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    [navButton release];
    return barButton;
}

+ (UIBarButtonItem *)getCustomNavButtonOnLeftSide:(BOOL)leftSide target:(id)tar image:(UIImage *)image title:(NSString *)title selector:(SEL)selector
{
    
    CustomNavButton *navButton = [[CustomNavButton alloc] initWithFrame:CGRectMake(0, 0, NAV_BUTTON_WIDTH, NAV_BUTTON_WIDTH) isOnLeft:leftSide];
    
    [navButton setImage:image forState:UIControlStateNormal];
    [navButton setTitle:title forState:UIControlStateNormal];
    navButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15];
    [navButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [navButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    navButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [navButton addTarget:tar action:selector forControlEvents:UIControlEventTouchUpInside];
    
#warning 内存问题。。。 修改完需要彻查 这个方法创建的UIBarButtonItem，暂不修改
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    [navButton release];
    return barButton;
}

+ (UIBarButtonItem *)getCustomNavDoneButtonWithTarget:(id)target selector:(SEL)selector
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAV_BUTTON_WIDTH, NAV_BUTTON_HEIGHT)];
    [button setTitle:NSLocalizedString(@"nav done", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (UIBarButtonItem *)getCustomNavButtonWithText:(NSString *)title target:(id)tar selection:(SEL)selector
{
    float textSize=16.0;
//    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:textSize] constrainedToSize:CGSizeMake(1000, NAV_BUTTON_HEIGHT)];
    
    CGSize size=CGSizeMake(1000, NAV_BUTTON_HEIGHT);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:textSize];
    NSDictionary *atttibutes=@{NSFontAttributeName:font};
    CGSize titleSize = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width , NAV_BUTTON_HEIGHT)];
    
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15];;
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:tar action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    
    return barButton;
}

+ (UIBarButtonItem *)getCustomNavButtonWithText:(NSString *)title withTextColor:(UIColor*) textcolor target:(id)tar selection:(SEL)selector
{
    float textSize=16.0;
//    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:textSize] constrainedToSize:CGSizeMake(1000, NAV_BUTTON_HEIGHT)];
    
    CGSize size=CGSizeMake(1000, NAV_BUTTON_HEIGHT);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:textSize];
    NSDictionary *atttibutes=@{NSFontAttributeName:font};
    CGSize titleSize = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width , NAV_BUTTON_HEIGHT)];
    
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [button setTitleColor:textcolor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:tar action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    
    return barButton;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(UIImage*) strecthableImage:(NSString*)imagename
{
    //set a stretchable image as the background;
    UIImage *image = [UIImage imageNamed:imagename];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    
    return image;
}

+(BOOL)hasAnyBuddyAssociateWithNumbers:(NSArray*)numbers
{
    for (NSString* number in numbers) {
        NSString* sanitizedNumber = [WTHelper translatePhoneNumberToGlobalNumber:number];
        Buddy* buddy = [Database buddyWithPhoneNumber:sanitizedNumber];
        if (buddy!= nil) {
            return TRUE;
        }
    }
    return FALSE;
}

+ (void)logout
{
    if ([WowTalkVoipIF fIsSetupCompleted] && [WowTalkVoipIF fIsWowTalkServiceReady])
        [WowTalkVoipIF fWowTalkServiceEnterBackgroundMode];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults dictionaryRepresentation];
    for (id key in dict) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
    
//    [Database dropAllTables:YES];
//    [Database teardown];
//    [Database initializeDatabase];
    
}

+(UIImage*) imageNamedWithNoPngExtension:(NSString*) str;
{
    return [UIImage imageNamed:[str stringByAppendingPathExtension:PNG]];
}

+(BOOL)isEmailValid:(NSString*)email
{
    if (email == nil || [email isEqualToString:@""]) {
        return FALSE;
    }
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:email]) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}

+(UIView*)combinedGroupChatRoomAvatar:(GroupChatRoom*)chatroom
{
    NSMutableArray* arrays = [Database fetchAllBuddysInGroupChatRoom:chatroom.groupID];
    if ([arrays count] == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
        UIImageView* aiv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        [aiv setImage:[UIImage imageNamed:DEFAULT_GROUP_AVATAR]];
        [view addSubview:aiv];
        [aiv release];
        return [view autorelease];
    }
    else if ([arrays count] == 1) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
        Buddy* buddy = [arrays objectAtIndex:0];
        UIImageView* aiv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        
        [aiv setImage:[PublicFunctions thumbnailForUser:buddy.userID]];
        [view addSubview:aiv];
        [aiv release];
        return [view autorelease];
    }
    else if ([arrays count] == 2){
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
        Buddy* buddy1 = [arrays objectAtIndex:0];
        UIImageView* aiv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 22, 22)];
        
        [aiv1 setImage:[PublicFunctions thumbnailForUser:buddy1.userID]];
        [view addSubview:aiv1];
        [aiv1 release];
        
        Buddy* buddy2 = [arrays objectAtIndex:1];
        UIImageView* aiv2 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 12, 22, 22)];
        
        [aiv2 setImage:[PublicFunctions thumbnailForUser:buddy2.userID]];
        [view addSubview:aiv2];
        [aiv2 release];
        
        return [view autorelease];
    }
    else if ([arrays count] == 3){
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
        Buddy* buddy1 = [arrays objectAtIndex:0];
        UIImageView* aiv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        
        [aiv1 setImage:[PublicFunctions thumbnailForUser:buddy1.userID]];
        [view addSubview:aiv1];
        [aiv1 release];
        
        Buddy* buddy2 = [arrays objectAtIndex:1];
        UIImageView* aiv2 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 22, 22)];
        
        [aiv2 setImage:[PublicFunctions thumbnailForUser:buddy2.userID]];
        [view addSubview:aiv2];
        [aiv2 release];
        
        Buddy* buddy3 = [arrays objectAtIndex:2];
        UIImageView* aiv3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 22, 22)];
        
        [aiv3 setImage:[PublicFunctions thumbnailForUser:buddy3.userID]];
        [view addSubview:aiv3];
        [aiv3 release];
        
        return [view autorelease];
        
    }
    else{
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
        Buddy* buddy1 = [arrays objectAtIndex:0];
        UIImageView* aiv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        
        [aiv1 setImage:[PublicFunctions thumbnailForUser:buddy1.userID]];
        [view addSubview:aiv1];
        [aiv1 release];
        
        Buddy* buddy2 = [arrays objectAtIndex:1];
        UIImageView* aiv2 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 22, 22)];
        
        [aiv2 setImage:[PublicFunctions thumbnailForUser:buddy2.userID]];
        [view addSubview:aiv2];
        [aiv2 release];
        
        Buddy* buddy3 = [arrays objectAtIndex:2];
        UIImageView* aiv3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 22, 22)];
        
        [aiv3 setImage:[PublicFunctions thumbnailForUser:buddy3.userID]];
        [view addSubview:aiv3];
        [aiv3 release];
        
        Buddy* buddy4 = [arrays objectAtIndex:3];
        UIImageView* aiv4= [[UIImageView alloc] initWithFrame:CGRectMake(23, 23, 22, 22)];
        
        [aiv4 setImage:[PublicFunctions thumbnailForUser:buddy4.userID]];
        [view addSubview:aiv4];
        [aiv4 release];
        
        return [view autorelease];
        
    }
    
}


+(UIImage*)thumbnailForUser:(NSString*)buddyid
{
    NSData* data = [AvatarHelper getThumbnailForUser:buddyid];
    if (data) {
        return [UIImage imageWithData:data];
    }
    else
        return [UIImage imageNamed:DEFAULT_AVATAR];
}

+(NSString*)compositeNameOfMessage:(ChatMessage*)msg
{
    NSString* name = @"";
    if (!msg.isGroupChatMessage) {
        if ([msg.chatUserName isEqualToString:@"10000"]) {
            name = NSLocalizedString(@"System messages", nil);
        }
        else{
            Buddy* buddy = [Database buddyWithUserID: msg.chatUserName];
            if (buddy){
                if ([buddy.buddy_flag isEqualToString:@"2"]) {
                    ABPerson* person  = [AddressBookManager personWithNumber:buddy.phoneNumber];
                    if (person) {
                        name = person.compositeName;
                    }
                    else{
                        name = buddy.phoneNumber;
                    }
                }
                else
                    name = buddy.nickName;
   
            }
            else
                [WowTalkWebServerIF getBuddyWithUID:msg.chatUserName withCallback:@selector(didGetBuddy:) withObserver:nil];
        }

        if ([NSString isEmptyString:name]) {
            name = NSLocalizedString(@"Unknown", nil);
        }
    }
    else{
        GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
        if (room == nil) {
            [WowTalkWebServerIF groupChat_GetGroupDetail:msg.chatUserName withCallback:@selector(didGetGroupInfo:) withObserver:nil];
            name = NSLocalizedString(@"Chatroom",nil);
        }
        else{
            if (room.isTemporaryGroup) {
                if (![PublicFunctions isTmpChatRoomNameChanged:room]) {
                    name = NSLocalizedString(@"fix_tmp_group_chat_title", nil);
                } else {
                    name = room.groupNameLocal;
                }
            } else {
//                name = NSLocalizedString(@"fix_group_chat_title", nil);
                name = room.groupNameLocal;
            }
//            if (room.isTemporaryGroup) {
//                name = [PublicFunctions roomName:room];
//            }
//            else{
//                name = room.groupNameLocal;
//            }
        }
    }
    
    return name;
}

+(BOOL)isTmpChatRoomNameChanged:(GroupChatRoom *)chatRoom
{
    BOOL changed=true;
    
    //    NSLocalizedString( @"Chatroom", nil)
    if (nil == chatRoom.groupNameLocal || 0 == chatRoom.groupNameLocal.length ||
        [chatRoom.groupNameLocal isEqualToString:@"グループ"] ||
        [chatRoom.groupNameLocal isEqualToString:@"Chatroom"] ||
        [chatRoom.groupNameLocal isEqualToString:@"多人对话"]) {
        changed=false;
    }
    
    return changed;
}

+(NSString*)roomName:(GroupChatRoom*)room
{
    if ([NSString isEmptyString:room.groupNameLocal]) {
        
        NSArray* buddys = [Database fetchAllBuddysInGroupChatRoom:room.groupID];
        NSMutableString* string = [[NSMutableString alloc] init];
        [string appendString:@""];
        
        for (Buddy* buddy in buddys) {
            [string appendString:buddy.nickName];
            [string appendString:@" "];
        }
        
        if ([string isEqual:@""]) {
            [string  appendString:NSLocalizedString(@"Chatroom",nil)];
        }
        
        return string;
    }
    else{
        return room.groupNameLocal;
    }
}


+(NSString*)departmentName:(NSMutableArray*)departments
{
    NSMutableArray* lowestChilds = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < [departments count]; i++) {
        Department* dept1 = [departments objectAtIndex:i];
        if ([NSString isEmptyString:dept1.parent_id]) {
            continue;
        }
        BOOL found = FALSE;
        
        for (int j = 0; j< [departments count]; j++) {
            if (j == i) {
                continue;
            }
            Department* dept2 = [departments objectAtIndex:j];
            if ([dept2.parent_id isEqualToString:dept1.groupID]) {
                found = TRUE;
            }
        }
        if (!found) {
            [lowestChilds addObject:dept1];
        }
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    for (Department* dept in lowestChilds) {
        [str appendString:dept.groupNameLocal];
        [str appendString:@" "];
    }
    
    [lowestChilds release];
    
    return [str autorelease];
    
}

+(NSTimeInterval) timeIntervalTillEndOfDateSince1970:(NSDate*)date{
    
    NSCalendar* cal =  [NSCalendar currentCalendar];
   
   NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setMinute:59];
    [components setSecond:59];
    [components setHour:23];
    
    NSDate * endDate = [cal dateFromComponents:components];
    return [endDate timeIntervalSince1970];
}

+(void) unreadMsgCountIncrease:(int)num{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int badgeValue = [defaults integerForKey:UNREAD_MESSAGE_NUMBER];
    badgeValue +=num;
    if (badgeValue<0) {
        badgeValue=0;
    }
    [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
    [defaults synchronize];
}
+(void) unreadMsgCountDecrease:(int)num{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int badgeValue = [defaults integerForKey:UNREAD_MESSAGE_NUMBER];
    badgeValue -= num;
    if (badgeValue<0) {
        badgeValue=0;
    }
    [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
    [defaults synchronize];

}
+(void) unreadMsgCountSetToZero{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:UNREAD_MESSAGE_NUMBER];
    [defaults synchronize];
    
}
+(int) unreadMsgCount{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int badgeValue = [defaults integerForKey:UNREAD_MESSAGE_NUMBER];
    return badgeValue;
}

@end
