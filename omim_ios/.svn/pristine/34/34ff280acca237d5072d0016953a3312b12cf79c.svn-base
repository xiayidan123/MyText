//
//  MemberGridView.m
//  omim
//
//  Created by coca on 2013/04/24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "MemberGridView.h"
#import "GroupMember.h"
#import "GroupInfoBuddyCell.h"
#import "Colors.h"
#import "Constants.h"
#import "WTHeader.h"

@implementation MemberGridView
@synthesize members = _members;
@synthesize visibleMembers = _visibleMembers;

@synthesize isCreator = _isCreator;
@synthesize isManager = _isManager;
@synthesize inDeleteMode = _inDeleteMode;

@synthesize ableToAdd = _ableToAdd;
@synthesize ableToDelete = _ableToDelete;

@synthesize caller = _caller;

#define CELL_HEIGHT  79
#define CELL_WIDTH   58
- (id)initWithFrame:(CGRect)frame withMembers:(NSMutableArray *)members showingAllMembers:(BOOL)flag ableToAdd:(BOOL)ableToAdd ableToDelete:(BOOL)ableToDelete isCreator:(BOOL)isCreator isManager:(BOOL)isManager isDeleteMode:(BOOL)isDeleteMode{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        cellnumoffset = 0;
        
        self.uiGridViewDelegate = self;
        self.members = [self orderMemebers:members];
        
        self.isManager  = isManager;
        self.isCreator  = isCreator;
        
        _ableToDelete = ableToDelete;
        _ableToAdd = ableToAdd;
        
        if (self.ableToAdd) {
            cellnumoffset ++ ;
        }
        if (self.ableToDelete) {
            cellnumoffset ++;
        }
        
        self.inDeleteMode = isDeleteMode;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if (self.members == nil) {
            self.members = [[[NSMutableArray alloc] init] autorelease];
        }
        showingAll = flag;
        
        // if it is in delete mode, forcely showing all the members.
        if (self.inDeleteMode) {
            showingAll = TRUE;
            cellnumoffset = 0;
        }
        
        [self adjustFrame];
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame withTempGroupMembers:(NSMutableArray*) members showingAllMembers:(BOOL)flag isDeleteMode:(BOOL)isDeleteMode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        cellnumoffset = 0;
        
        self.uiGridViewDelegate = self;
        self.members = [GroupMember normalGroupMembersFromBuddys: members];  // no order here. turn the buddy array to groupmember array.
        
        self.ableToAdd = TRUE;
        self.ableToDelete = FALSE;
        
        if (self.ableToAdd) {
            cellnumoffset ++ ;
        }
        if (self.ableToDelete) {
            cellnumoffset ++;
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if (self.members == nil) {
            self.members = [[[NSMutableArray alloc] init] autorelease];
        }
        showingAll = flag;
        
        _inDeleteMode = isDeleteMode;
        
        [self adjustFrame];
        
    }
    return self;
    
    
}

- (void)setAbleToDelete:(BOOL)able
{
    _ableToDelete = able;
    cellnumoffset = 0;
    if (_ableToAdd) {
        cellnumoffset++;
    }
    if (_ableToDelete) {
        cellnumoffset++;
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


#pragma mark - gridview delegate
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 58;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
	return 79;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 5;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if (_inDeleteMode) {
        return self.visibleMembers.count;
    }
    cellnum = [self.visibleMembers count] + cellnumoffset;
	return cellnum;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	GroupInfoBuddyCell *cell = (GroupInfoBuddyCell *)[grid dequeueReusableCell];
    cell.headImageView.buddy = nil;
	if (cell == nil) {
		cell = [[[GroupInfoBuddyCell alloc] init] autorelease];
        [cell.deleteicon addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
	}
    
    cell.lbl_role.hidden = FALSE;
    cell.lbl_role.font = [UIFont systemFontOfSize:12];
    cell.lbl_role.textAlignment = NSTextAlignmentCenter;
    cell.view.hidden = FALSE;
    cell.lbl_role.textColor = [UIColor whiteColor];
//    cell.thumbnail.layer.cornerRadius =cell.thumbnail.frame.size.height/2;
//    cell.thumbnail.layer.masksToBounds = YES;

    int index = rowIndex * 5 + columnIndex;
    if (!self.inDeleteMode) {
        [cell.deleteicon setHidden:TRUE];
        if (self.ableToAdd && index == cellnum - cellnumoffset) {
            cell.headImageView.headImage = [UIImage imageNamed:ADD_MEMBER_ICON];
            cell.lbl_role.hidden = TRUE;
        }
        else if (self.ableToDelete && index == cellnum - 1){
            cell.headImageView.headImage = [UIImage imageNamed:REMOVE_MEMBER_ICON];
            cell.lbl_role.hidden = TRUE;
        }
        else
        {
            GroupMember* member = [self.visibleMembers objectAtIndex:index];
            cell.label.text = member.nickName;
            
            if (member.isCreator) {
                cell.lbl_role.text = NSLocalizedString(@"Creator", nil);
                cell.lbl_role.backgroundColor = [Colors creatorLabelColor];
                
            }
            else if (member.isManager){
                cell.lbl_role.text = NSLocalizedString(@"Adminstrator", nil);
                cell.lbl_role.backgroundColor = [Colors adminLabelColor];
            }
            else{
                cell.lbl_role.hidden = TRUE;
            }
            NSData* data = [AvatarHelper getThumbnailForUser:member.userID];
            
            if (data) {
                cell.headImageView.headImage =  [UIImage imageWithData:data];
            }
            else{
                if ([member.buddy_flag isEqualToString:@"2"]) {
                    cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
                }
                else{
                    cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
                }
            }
            Buddy* temp = [Database buddyWithUserID:member.userID];
            cell.headImageView.buddy = temp;
            if (temp.needToDownloadThumbnail){
                [WowTalkWebServerIF getThumbnailForUserID:member.userID withCallback:@selector(didGetThumbnail:) withObserver:self];
            }
        }
    }
    else{
        GroupMember* member = [self.visibleMembers objectAtIndex:index];
        cell.label.text = member.nickName;
        
        if (member.isCreator) {
            cell.lbl_role.text = NSLocalizedString(@"Creator", nil);
            cell.lbl_role.backgroundColor = [Colors creatorLabelColor];
        }
        else if (member.isManager){
            cell.lbl_role.text = NSLocalizedString(@"Adminstrator", nil);
            cell.lbl_role.backgroundColor = [Colors adminLabelColor];
        }
        else{
            cell.lbl_role.hidden = TRUE;
        }
        
        
        NSData* data = [AvatarHelper getThumbnailForUser:member.userID];
        
        if (data) {
            cell.headImageView.headImage =  [UIImage imageWithData:data];
        }
        else{
            if ([member.buddy_flag isEqualToString:@"2"]) {
                cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
            }
            else{
                cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
            }
            
        }
        
        Buddy* temp = [Database buddyWithUserID:member.userID];
        if (temp.needToDownloadThumbnail){
            [WowTalkWebServerIF getThumbnailForUserID:member.userID withCallback:@selector(didGetThumbnail:) withObserver:self];
        }
        
        
        [cell.deleteicon setHidden:FALSE];
        cell.deleteicon.tag = index;
        if([cell.deleteicon superview]!=nil) [cell.deleteicon removeFromSuperview];
        [cell.deleteicon setFrame:CGRectMake(columnIndex*CELL_WIDTH, rowIndex*CELL_HEIGHT, 29, 29)];
        [cell.deleteicon addTarget:self action:@selector(didClickAtDeletionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell.deleteicon];
        
        if (self.isManager) {
            if (index < creatornum + adminnum) {
                cell.deleteicon.hidden = TRUE;
            }
        }
        else if (self.isCreator){
            if (index<creatornum) {
                cell.deleteicon.hidden = TRUE;
            }
        }
    }
    
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    //   NSLog(@"fuckcuck");
    // remove member
    int index = rowIndex * 5 + columnIndex;
    
    if (self.inDeleteMode) {
//        GroupMember* member = [self.visibleMembers objectAtIndex:index];
//        
//        if ([member.userID isEqualToString:[WTUserDefaults getUid]]) {
//            return;
//        }
//        
//        if (self.caller!=nil && [self.caller respondsToSelector:@selector(didSelectMember:inGridView:)]) {
//            [self.caller didSelectMember:member inGridView:self];
//        }
    }
    
    else{
        if (self.ableToDelete && index == cellnum - 1){
            if (self.caller!=nil && [self.caller respondsToSelector:@selector(becomeDeleteMode:)]) {
                [self.caller becomeDeleteMode:self];
            }
        }
        else if (self.ableToAdd && index == cellnum - cellnumoffset){
            // add member
            if (self.caller!=nil && [self.caller respondsToSelector:@selector(becomeAddMode:)]) {
                [self.caller becomeAddMode:self];
            }
        }
        else{
            GroupMember* member = [self.visibleMembers objectAtIndex:index];
            if ([member.userID isEqualToString:[WTUserDefaults getUid]]) {
                return;
            }
            if (self.caller!=nil && [self.caller respondsToSelector:@selector(didSelectMember:inGridView:)]) {
                [self.caller didSelectMember:member inGridView:self];
            }
        }
    }
}

- (void)didClickAtDeletionButton:(UIButton *)button
{
    NSInteger index = button.tag;
    [self.caller didSelectMember:[self.visibleMembers objectAtIndex:index] inGridView:self];
}

-(void)deleteMember:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    NSInteger index = btn.tag;
    GroupMember* member = [self.members objectAtIndex:index];
    
    if (self.caller && [self.caller respondsToSelector:@selector(didDeleteMember:inGridView:)]) {
        [self.caller didDeleteMember:member inGridView:self];
    }
    
}

-(NSMutableArray*)orderMemebers:(NSArray*)memberlist
{
    if (memberlist==nil || [memberlist count] == 0) {
        return nil;
    }
    NSMutableArray* orderedlist = [[NSMutableArray alloc] init];
    
    adminnum = 0;
    creatornum = 0;
    for (GroupMember* member in memberlist) {
        if (member.isCreator) {
            [orderedlist insertObject:member atIndex:0];
            creatornum ++ ;
        }
        else if (member.isManager){
            [orderedlist insertObject:member atIndex:adminnum + creatornum];
            adminnum++;
        }
        else{
            [orderedlist addObject:member];
        }
    }
    
    return [orderedlist autorelease];
}

-(void)adjustFrame
{
    
    if (showingAll) {
        self.visibleMembers = self.members;
        NSInteger count = [self.visibleMembers count] + cellnumoffset;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,CELL_WIDTH*5, CELL_HEIGHT* ((count + 4)/5));
    }
    
    else{
        NSInteger count;
        if ([self.members count] < 11 - cellnumoffset) {
            self.visibleMembers = self.members;
            count = [self.members count] + cellnumoffset;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,CELL_WIDTH*5, CELL_HEIGHT* ((count + 4)/5));
            
        }
        else{
            self.visibleMembers = [[[NSMutableArray alloc] init] autorelease];
            for (int i = 0; i< 10 - cellnumoffset; i++) {
                GroupMember* member = [self.members objectAtIndex:i];
                [self.visibleMembers addObject:member];
            }
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,CELL_WIDTH*5, CELL_HEIGHT*2);
        }
    }
    
    if (self.inDeleteMode) {
        NSInteger num = [self.members count];
        NSInteger lastrow = num / 5 + 1;
        NSInteger cellinlastrow = num % 5;
        NSInteger space = 5- cellinlastrow;
        
        
        UIButton* btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(self.frame.size.width -58*space, lastrow*79 -79 , 58*space, 79)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self.caller action:@selector(dismissDeleteMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

+(CGFloat) heightForViewWithMembers:(int)membercount showingAll:(BOOL)flag ableToAdd:(BOOL)ableToAdd ableToDelete:(BOOL)ableToDelete isDeleteMode:(BOOL)isDeleteMode
{
    int count = membercount;
    
    int offset = 0;
    
    if (ableToDelete) {
        offset ++;
    }
    if (ableToAdd) {
        offset ++;
    }
    
    if (isDeleteMode) {
        flag = TRUE;
    }
    else{
        count = count + offset;
    }
    
    if (!flag) {
        if (count>10) {
            count = 10;
        }
    }
    //    NSLog(@"grid view height: %d", CELL_HEIGHT* ((count + 4)/5));
    return  CELL_HEIGHT* ((count + 4)/5);
}

+(CGFloat) heightForViewWithTempGroupMembers:(int)membercount showingAll:(BOOL)flag
{
    int count = membercount;
    
    int offset = 0;
    offset ++; // for able to add.
    
//    count = count + offset;
    
    
    if (!flag) {
        if (count>10) {
            count = 10;
        }
    }
    //    NSLog(@"grid view height: %d", CELL_HEIGHT* ((count + 4)/5));
    return  CELL_HEIGHT* ((count + 4)/5);
    
}

+ (CGFloat)heightForViewWithTempGroupMembers:(int)membercount showingAll:(BOOL)flag ableToAdd:(BOOL)add ableToDelete:(BOOL)delete deleteMode:(BOOL)deleteMode
{
    NSInteger count = membercount;
    if (add && !deleteMode) {
        count++;
    }
    if (delete && !deleteMode) {
        count++;
    }
    
    if (!flag) {
        if (count > 10) {
            count = 10;
        }
    }
    return CELL_HEIGHT * ((count + 4) / 5);
}


-(void)didGetThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self reloadData];
    }
}


@end
