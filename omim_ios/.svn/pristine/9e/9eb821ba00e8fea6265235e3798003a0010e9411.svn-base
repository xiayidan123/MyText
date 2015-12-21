//
//  GroupListCell.h
//  wowtalkbiz
//
//  Created by elvis on 2013/08/19.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupListCell;

@class  Department;

@protocol GroupListCellDelegate <NSObject>
@optional

-(void)favirateTheGroup:(GroupListCell*)request;
-(void)toggleTheGroup:(GroupListCell*)request;
-(void)messageTheGroup:(GroupListCell*)request;
-(void)selectTheGroup:(GroupListCell*)request;
-(void)pickTheGroup:(GroupListCell*)request;
-(void)unpickTheGroup:(GroupListCell*)request;

@end

@interface GroupListCell : UIView{
    BOOL isOpen;
    BOOL isPicked;
}

@property  BOOL isOpen;

@property  BOOL isSelectionMode;

@property BOOL isPickedCell;

@property (assign) id<GroupListCellDelegate> delegate;

@property (nonatomic,retain) UIButton* arrow;
@property (nonatomic,retain) UIButton* selectToView;
@property (nonatomic,retain) UILabel* groupname;
@property (nonatomic,retain) UIButton* favirate;
@property (nonatomic,retain) UIButton* groupchat;

@property (nonatomic,retain) UIButton* selectionButton;

@property (nonatomic,retain) NSString* group_id;
@property (nonatomic,retain) Department* department;

@property int level;

@property BOOL isfoldable;



@end
