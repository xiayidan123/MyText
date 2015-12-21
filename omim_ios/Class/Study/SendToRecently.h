//
//  SendToRecently.h
//  dev01
//
//  Created by Huan on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Buddy;
@class ChatMessage;
@protocol RecentlytableViewCellDelegate <NSObject>

//- (void)getBuddyFromRecentCell:(Buddy *)buddy;
//- (void)getChatMessageFromCell:(ChatMessage *)chatMessage;
//- (void)getBuddysFromCell:(NSMutableArray *)buddys;
@end


@interface SendToRecently : UICollectionViewCell
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) id<RecentlytableViewCellDelegate> delegate;
@end
