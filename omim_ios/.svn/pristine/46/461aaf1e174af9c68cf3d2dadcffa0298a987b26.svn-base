//
//  MemberGridView.h
//  omim
//
//  Created by coca on 2013/04/24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UIGridView.h"
#import "UIGridViewDelegate.h"
@class MemberGridView;
@class GroupMember;

@protocol MemberGridViewDelegate <NSObject>

@optional

- (void) becomeDeleteMode:(MemberGridView*)requstor;
- (void) didDeleteMember:(GroupMember*)member inGridView:(MemberGridView*)requestor;
- (void) didSelectMember:(GroupMember*)member inGridView:(MemberGridView*)member;
- (void) becomeAddMode:(MemberGridView*) requestor;

@end


@interface MemberGridView : UIGridView<UIGridViewDelegate>
{
    NSInteger cellnum;
    int adminnum;
    int creatornum;
    BOOL showingAll;
    
    int cellnumoffset;
}

@property (nonatomic,assign) id<MemberGridViewDelegate> caller;

@property (nonatomic) BOOL ableToAdd;

@property (nonatomic) BOOL ableToDelete;

@property (nonatomic) BOOL inDeleteMode;

@property (nonatomic) BOOL isCreator;

@property (nonatomic) BOOL isManager;

@property (nonatomic,retain) NSMutableArray* members;

@property (nonatomic,retain) NSMutableArray* visibleMembers;

-(id)initWithFrame:(CGRect)frame withMembers:(NSMutableArray*) members showingAllMembers:(BOOL)flag ableToAdd:(BOOL)ableToAdd ableToDelete:(BOOL)ableToDelete isCreator:(BOOL)isCreator isManager:(BOOL)isManager isDeleteMode:(BOOL)isDeleteMode;

-(id)initWithFrame:(CGRect)frame withTempGroupMembers:(NSMutableArray*) members showingAllMembers:(BOOL)flag isDeleteMode:(BOOL)isDeleteMode;

+(CGFloat) heightForViewWithMembers:(int)membercount showingAll:(BOOL)flag ableToAdd:(BOOL)ableToAdd ableToDelete:(BOOL)ableToDelete isDeleteMode:(BOOL)isDeleteMode;

+(CGFloat) heightForViewWithTempGroupMembers:(int)membercount showingAll:(BOOL)flag;

+ (CGFloat)heightForViewWithTempGroupMembers:(int)membercount showingAll:(BOOL)flag ableToAdd:(BOOL)mAdd ableToDelete:(BOOL)mDelete deleteMode:(BOOL)deleteMode;

@end
