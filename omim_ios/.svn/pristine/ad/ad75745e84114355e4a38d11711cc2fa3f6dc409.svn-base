//
//  FavoriteGroupCell.h
//  dev01
//
//  Created by elvis on 2013/08/26.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoriteGroupCell;

@class  Department;

@protocol FavoriteGroupCellDelegate <NSObject>
@optional

-(void)favoriteInStarredGroups:(FavoriteGroupCell*)request;
-(void)toggleInStarredGroups:(FavoriteGroupCell*)request;
-(void)messageInStarredGroups:(FavoriteGroupCell*)request;
-(void)selectInStarredGroups:(FavoriteGroupCell*)request;
-(void)changeGroupOrderInStarredGroups:(FavoriteGroupCell*)request;
-(void)pickTheGroupInStarredGroup:(FavoriteGroupCell*)request;
-(void)unpickTheGroupInStarredGroup:(FavoriteGroupCell*)request;
@end

@interface FavoriteGroupCell : UIView{
    BOOL isOpen;
    BOOL isPicked;
}

@property  BOOL isSelectionMode;
@property  BOOL isOpen;

@property BOOL isPickedCell;

@property (assign) id<FavoriteGroupCellDelegate> delegate;

@property (nonatomic,retain) UIButton* arrow;
@property (nonatomic,retain) UIButton* selectToView;
@property (nonatomic,retain) UILabel* groupname;
@property (nonatomic,retain) UIButton* favirate;
@property (nonatomic,retain) UIButton* changeOrder;
@property (nonatomic,retain) UIButton* groupchat;
@property (nonatomic,retain) UIButton* selectionButton;

@property (nonatomic,retain) NSString* group_id;
@property (nonatomic,retain) Department* department;

@property int level;

@property BOOL isfoldable;

//-(void)setLevel:(int)level withStatus:(BOOL)open;

@end
