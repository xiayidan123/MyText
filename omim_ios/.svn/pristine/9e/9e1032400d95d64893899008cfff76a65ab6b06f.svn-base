//
//  SearchUserResultCell.h
//  dev01
//
//  Created by 杨彬 on 15/2/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buddy.h"
#import "OMHeadImgeView.h"

typedef NS_ENUM(NSInteger, SearchUserResultCellStatus) {
    NOTADD,
    ADDING,
    DIDADD,
    ISSELF
};


@protocol SearchUserResultCellDelegate <NSObject>

- (void)addFriendWithBuddy:(Buddy *)buddy;


- (void)addMySelf;

@end



@interface SearchUserResultCell : UITableViewCell

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

@property (nonatomic,assign) SearchUserResultCellStatus status;
@property (nonatomic,assign) id <SearchUserResultCellDelegate>delegate;
@property (nonatomic,retain) Buddy *buddy;
@property (nonatomic,assign) NSInteger searchLenght;
@property (nonatomic,copy) NSString *inputSearchContent;
@property (nonatomic,assign) NSInteger selectedIndex;
@end
