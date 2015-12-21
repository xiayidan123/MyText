//
//  PublicFunctions.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumType.h"
#import "TextFieldAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSURL+uriEquivalence.h"
#import "MediaUploader.h"
#import "UIView+FindAndResignFirstResponder.h"
#import "QuickNotice.h"
#import "UIImage+StackBlur.h"
#import "SpeakerHelper.h"
#import "UINavigationItem+SpaceHandler.h"
#import "CustomIOS7AlertView.h"

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

@class ChatMessage;
@class GroupChatRoom;

@interface PublicFunctions : NSObject

+ (ALAssetsLibrary *)defaultAssetsLibrary;

+ (NSString *)md5:(NSString *)str;

+ (UIBarButtonItem *)getCustomNavButtonOnLeftSide:(BOOL)leftSide target:(id)tar image:(UIImage *)image selector:(SEL)selector;
+ (UIBarButtonItem *)getCustomNavButtonOnLeftSide:(BOOL)leftSide target:(id)tar image:(UIImage *)image title:(NSString *)title selector:(SEL)selector;

+ (UIBarButtonItem *)getCustomNavDoneButtonWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)getCustomNavButtonWithText:(NSString *)title target:(id)tar selection:(SEL)selector;
+ (UIBarButtonItem *)getCustomNavButtonWithText:(NSString *)title withTextColor:(UIColor*) textcolor target:(id)tar selection:(SEL)selector;

+ (void)logout;


+(UIImage*) imageNamedWithNoPngExtension:(NSString*) str;

+(UIImage*) strecthableImage:(NSString*)imagename;

+(BOOL)hasAnyBuddyAssociateWithNumbers:(NSArray*)numbers;
+(BOOL)isEmailValid:(NSString*)email;

+(UIView*)combinedGroupChatRoomAvatar:(GroupChatRoom*)chatroom;

+(NSString*)compositeNameOfMessage:(ChatMessage*)msg;


+(NSString*)departmentName:(NSMutableArray*)departments;
+(BOOL)isTmpChatRoomNameChanged:(GroupChatRoom *)chatRoom;

+(NSTimeInterval) timeIntervalTillEndOfDateSince1970:(NSDate*)date;

+(void) unreadMsgCountIncrease:(int)num;
+(void) unreadMsgCountDecrease:(int)num;
+(void) unreadMsgCountSetToZero;
+(int) unreadMsgCount;
@end
