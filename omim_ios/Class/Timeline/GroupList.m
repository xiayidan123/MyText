//
//  GroupList.m
//  wowtalkbiz
//
//  Created by elvis on 2013/08/19.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "GroupList.h"
#import "WTHeader.h"
#import "GroupListCell.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import "FavoriteGroupCell.h"


@interface GroupList ()
{
    int depth;
    BOOL parallel;
    BOOL isShowFavorite;
    int favoritePartHeight;
    
    BOOL isSelectAllFavorite;  //TODO: 
    
}
@property (nonatomic,retain) NSMutableArray* visibileGroupCells;
@property (nonatomic,retain) UIScrollView* groupContainerView;
@property (nonatomic,retain) NSMutableDictionary* celldict;

@end

static int tilingpos = 0;

@implementation GroupList
@synthesize selectionMode = _selectionMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        
        // Initialization code
        _visibileGroupCells = [[NSMutableArray alloc] init];
        
        NSMutableArray* parents = [Database getFirstLevelDepartments];
        
        _groups = [[NSMutableDictionary alloc] init];
        _sortedKeys = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [parents count]; i++) {
            Department* department = [parents objectAtIndex:i];
            department.level = 0;
            [_groups setValue:department forKey:department.groupID];
            [_sortedKeys addObject:department];
        }
        
        depth = 0;
        self.isWithStarAndChat=true;
        _groupContainerView = [[UIScrollView alloc] init];
        _groupContainerView.frame = self.frame;
        
        [self addSubview:_groupContainerView];
        [_groupContainerView release];
        
      //  [self tile];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



#pragma mark -- Group Tile
-(void)setSelectionMode:(BOOL)selectionMode
{
    _selectionMode = selectionMode;
    [self tile];
}

-(void)tile
{
    [self titleFavorite];
    tilingpos = 0;
    [self tileGroups:self.groups withIndex:0];
    self.groupContainerView.contentSize = CGSizeMake(320, favoritePartHeight+[self.sortedKeys count]*44);
    
}

-(void)titleFavorite
{
    for (UIView* view in [self.groupContainerView subviews]) {
        if ([view isKindOfClass:[FavoriteGroupCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (isShowFavorite) {
        FavoriteGroupCell* cell = [[FavoriteGroupCell alloc] initWithFrame:CGRectMake(0, 2, 320, 44)];
        cell.isSelectionMode  = _selectionMode;
        
        [cell.favirate setHidden:TRUE];
        [cell.groupchat setHidden:TRUE];
        
        cell.arrow.alpha = 1;
        cell.selectToView.alpha = 1;
        cell.groupname.alpha = 1;
        cell.selectToView.enabled = FALSE;
        
        [cell.arrow setImage:[UIImage imageNamed:GROUP_ARROW_DOWN] forState:UIControlStateNormal];
        cell.groupname.text = NSLocalizedString(@"Starred Groups", nil);
        cell.delegate = self;
        
        [self.groupContainerView addSubview:cell];
        [cell release];
        favoritePartHeight = 46;
        
        NSMutableArray* arr_departments = [Database favoritedDepartments];
        
        if (cell.isSelectionMode) {
            cell.changeOrder.alpha = 0;
            cell.selectionButton.alpha = 1;
            [cell.selectionButton setImage:nil forState:UIControlStateNormal];
                [cell.selectionButton setEnabled:FALSE];
        }
        if(!self.isWithStarAndChat){
            [cell.favirate setHidden:TRUE];
            [cell.groupchat setHidden:TRUE];
            [cell.changeOrder setHidden:TRUE];
            if (!cell.isSelectionMode) {
                cell.selectToView.frame=CGRectMake(cell.selectToView.frame.origin.x,
                                                   cell.selectToView.frame.origin.y,
                                                   320-cell.frame.origin.x-cell.selectToView.frame.origin.x-5,
                                                   cell.selectToView.frame.size.height);
            }
        }
        for (NSString* departmentid in arr_departments){
            FavoriteGroupCell* cell = [[FavoriteGroupCell alloc] initWithFrame:CGRectMake(0, favoritePartHeight, 0, 44)];
            cell.isSelectionMode  = _selectionMode;
            cell.delegate = self;
            cell.department = [Database getDepartement:departmentid];
            [cell.department retain];
            
            [cell.changeOrder setHidden:TRUE];
            cell.level = 1;
            
            [self.groupContainerView addSubview:cell];
            [cell release];
            
            favoritePartHeight += 44;
            
            if (![Database isMember:[WTUserDefaults getUid] inDepartment:departmentid]) {
                [cell.groupchat setEnabled:FALSE];
                [cell.groupchat setImage:nil forState:UIControlStateNormal];
            }
            else{
                [cell.groupchat setEnabled:TRUE];
                [cell.groupchat setImage:[UIImage imageNamed:GROUP_SEND] forState:UIControlStateNormal];
            }
            
            if(!self.isWithStarAndChat){
                [cell.favirate setHidden:TRUE];
                [cell.groupchat setHidden:TRUE];
                [cell.changeOrder setHidden:TRUE];
                if (!cell.isSelectionMode) {
                    cell.selectToView.frame=CGRectMake(cell.selectToView.frame.origin.x,
                                                       cell.selectToView.frame.origin.y,
                                                       320-cell.frame.origin.x-cell.selectToView.frame.origin.x-5,
                                                       cell.selectToView.frame.size.height);
                }
            }
            
            if ([self isDepartmentSelected:cell.department.groupID]==nil) {
                cell.isPickedCell = FALSE;
            }
            else{
                cell.isPickedCell = TRUE;
            }
        }
    }
    else{
        FavoriteGroupCell* cell = [[FavoriteGroupCell alloc] initWithFrame:CGRectMake(0, 2, 320, 44)];
        cell.isSelectionMode  = _selectionMode;
        [cell.favirate setHidden:TRUE];
        [cell.groupchat setHidden:TRUE];
        cell.selectToView.enabled = FALSE;
        cell.arrow.alpha = 1;
        cell.selectToView.alpha = 1;
        cell.groupname.alpha = 1;
    
        cell.groupname.text = NSLocalizedString(@"Starred Groups", nil);
        if (cell.isSelectionMode) {
            cell.changeOrder.alpha = 0;
            cell.selectionButton.alpha = 1;
            [cell.selectionButton setImage:nil forState:UIControlStateNormal];
            [cell.selectionButton setEnabled:FALSE];
        }
    
        if(!self.isWithStarAndChat){
            [cell.favirate setHidden:TRUE];
            [cell.groupchat setHidden:TRUE];
            [cell.changeOrder setHidden:TRUE];
            if (!cell.isSelectionMode) {
                cell.selectToView.frame=CGRectMake(cell.selectToView.frame.origin.x,
                                                   cell.selectToView.frame.origin.y,
                                                   320-cell.frame.origin.x-cell.selectToView.frame.origin.x-5,
                                                   cell.selectToView.frame.size.height);
            }
        }
        
        cell.delegate = self;
        [self.groupContainerView addSubview:cell];
        [cell release];
        favoritePartHeight = 46;
    }
}

-(void)tileGroups:(NSMutableDictionary*)groups withIndex:(int)startpos
{
    if (startpos == 0) {
        for (UIView* view in [self.groupContainerView subviews]) {
            if ([view isKindOfClass:[GroupListCell class]]) {
                [view removeFromSuperview];
            }
        }
    }
    for (; tilingpos< [self.sortedKeys count];) {
        Department* department = [self.sortedKeys objectAtIndex:tilingpos];
        if ([[self.groups valueForKey:department.groupID] isKindOfClass:[NSMutableDictionary class]]) {
            [self tileGroup:department withIndex:tilingpos];
            NSMutableDictionary* subgroups = [self.groups valueForKey:department.groupID];
            [self tileGroups:subgroups withIndex: ++ tilingpos];
        }
        else{
            [self tileGroup:department withIndex:tilingpos];
            tilingpos++;
        }
    }
}


-(void)tileGroup:(Department*)department withIndex:(int)tilepos
{
    GroupListCell* groupcell;
    
    if (_celldict) {
        if ([_celldict objectForKey:department.groupID]) {
            groupcell = [_celldict objectForKey:department.groupID];
            [groupcell setFrame:CGRectMake(groupcell.frame.origin.x, tilepos*44 + favoritePartHeight, groupcell.frame.size.width, 44)];
            
            if (depth%3 == 0) {
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth -1) {
                        groupcell.level = 0;
                    }
                    else if(department.level == depth -1) {
                        groupcell.level = 1;
                    }
                    else if(department.level == depth) {
                        groupcell.level = 2;
                    }
                }
            }
            else if (depth%3 == 1){
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth-1) {
                        groupcell.level = 0;
                    }
                    else if (department.level == depth - 1){
                        groupcell.level = 1;
                    }
                    else if(department.level == depth){
                        groupcell.level = 2;
                    }
                }
            }
            else if (depth%3 == 2){
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth-1) {
                        groupcell.level = 0;
                    }
                    else if (department.level == depth - 1){
                        groupcell.level = 1;
                    }
                    else if(department.level == depth){
                        groupcell.level = 2;
                    }
                }
            }
            
            if([Database isDepartmentFavorited:department.groupID]){
                [groupcell.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK_P] forState:UIControlStateNormal];
            }
            else
                [groupcell.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
            
            //  groupcell.level = depth< 3? department.level:;
            [self.groupContainerView addSubview:groupcell];
        }
        else{
            groupcell = [[GroupListCell alloc] initWithFrame:CGRectMake(0, tilepos*44 + favoritePartHeight, 0, 0)];
            groupcell.isSelectionMode  = _selectionMode;
            groupcell.delegate = self;
            groupcell.department = department;
            [self.groupContainerView addSubview:groupcell];
            
            if (depth%3 == 0) {
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth -1) {
                        groupcell.level = 0;
                    }
                    else if(department.level == depth -1) {
                        groupcell.level = 1;
                    }
                    else if(department.level == depth) {
                        groupcell.level = 2;
                    }
                }
            }
            else if (depth%3 == 1){
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth-1) {
                        groupcell.level = 0;
                    }
                    else if (department.level == depth - 1){
                        groupcell.level = 1;
                    }
                    else if(department.level == depth){
                        groupcell.level = 2;
                    }
                }
            }
            else if (depth%3 == 2){
                if (depth/3 == 0) {
                    groupcell.level = department.level;
                }
                else{
                    if (department.level < depth-1) {
                        groupcell.level = 0;
                    }
                    else if (department.level == depth - 1){
                        groupcell.level = 1;
                    }
                    else if(department.level == depth){
                        groupcell.level = 2;
                    }
                }
            }
            
            [_celldict setValue:groupcell forKey:department.groupID];
            
            [groupcell release];
        }
    }
    else{
        groupcell = [[GroupListCell alloc] initWithFrame:CGRectMake(0, tilepos*44 + favoritePartHeight, 0, 0)];
        groupcell.isSelectionMode  = _selectionMode;
        groupcell.delegate = self;
        groupcell.department = department;
        [self.groupContainerView addSubview:groupcell];
        
        if (depth%3 == 0) {
            if (depth/3 == 0) {
                groupcell.level = department.level;
            }
            else{
                if (department.level < depth -1) {
                    groupcell.level = 0;
                }
                else if(department.level == depth -1) {
                    groupcell.level = 1;
                }
                else if(department.level == depth) {
                    groupcell.level = 2;
                }
            }
        }
        else if (depth%3 == 1){
            if (depth/3 == 0) {
                groupcell.level = department.level;
            }
            else{
                if (department.level < depth-1) {
                    groupcell.level = 0;
                }
                else if (department.level == depth - 1){
                    groupcell.level = 1;
                }
                else if(department.level == depth){
                    groupcell.level = 2;
                }
            }
        }
        else if (depth%3 == 2){
            if (depth/3 == 0) {
                groupcell.level = department.level;
            }
            else{
                if (department.level < depth-1) {
                    groupcell.level = 0;
                }
                else if (department.level == depth - 1){
                    groupcell.level = 1;
                }
                else if(department.level == depth){
                    groupcell.level = 2;
                }
            }
        }
        
        if (!_celldict) {
            _celldict = [[NSMutableDictionary alloc] init];
        }
        [_celldict setValue:groupcell forKey:department.groupID];
        
        [groupcell release];
    }
    
    
    if (![Database isMember:[WTUserDefaults getUid] inDepartment:department.groupID]) {
        [groupcell.groupchat setEnabled:FALSE];
        [groupcell.groupchat setImage:nil forState:UIControlStateNormal];
    }
    else{
        [groupcell.groupchat setEnabled:TRUE];
        [groupcell.groupchat setImage:[UIImage imageNamed:GROUP_SEND] forState:UIControlStateNormal];
    }
    
    if(!self.isWithStarAndChat){
        [groupcell.favirate setHidden:TRUE];
        [groupcell.groupchat setHidden:TRUE];
        if (!groupcell.isSelectionMode) {
            groupcell.selectToView.frame=CGRectMake(groupcell.selectToView.frame.origin.x,
                                               groupcell.selectToView.frame.origin.y,
                                               320-groupcell.frame.origin.x-groupcell.selectToView.frame.origin.x-5,
                                               groupcell.selectToView.frame.size.height);
        }
    }
    
    if ([self isDepartmentSelected:groupcell.department.groupID] == nil) {
        groupcell.isPickedCell = FALSE;
    }
    else{
        groupcell.isPickedCell = TRUE;
    }
    
}

#pragma mark -- helper
-(NSMutableArray*)findThePathToDepartment:(Department*)department
{
    NSMutableArray* path = [[NSMutableArray alloc] init];
    
    [path addObject:department.groupID];  // add itself.
    
    Department* tempdepart = [[Department alloc] init];
    tempdepart.parent_id = department.parent_id;
    
    while (tempdepart.parent_id) {
        Department* parent = [Database getDepartement:tempdepart.parent_id];
        [path insertObject:parent.groupID atIndex:0];
        tempdepart.parent_id = parent.parent_id;
    }
    
    return [path autorelease];
}


-(NSMutableDictionary*)dictFromarray:(NSMutableArray*)arrays withParent:(Department*)department
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [arrays count]; i++) {
        NSString* departmentid = [(Department*)[arrays objectAtIndex:i] groupID];
        Department* childdepartment = [Database getDepartement:departmentid];
        childdepartment.level = department.level + 1;
        
        if (depth < childdepartment.level) {
            depth = childdepartment.level;
        }
        [dict setObject:childdepartment forKey:departmentid];
    }
    
    return [dict autorelease];
    
}

#pragma mark - favoritecell delegate

-(void)toggleInStarredGroups:(FavoriteGroupCell *)request
{
    if (isShowFavorite) {
        isShowFavorite = FALSE;
    }
    else{
        isShowFavorite = TRUE;
    }
    [self tile];
}


-(void)favoriteInStarredGroups:(FavoriteGroupCell *)request
{
    if ([Database isDepartmentFavorited:request.department.groupID]) {
        [Database deFavoriteDepartment:request.department.groupID];
        [WowTalkWebServerIF defavoriteGroup:request.department.groupID withCallback:nil withObserver:nil];
        [request.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
        [self tile];
    }
}


-(void)messageInStarredGroups:(FavoriteGroupCell *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageTheGroup:)]) {
        [self.delegate messageTheGroup:request.department.groupID];
    }
}


-(void)selectInStarredGroups:(FavoriteGroupCell *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTheGroup:)]) {
        [self.delegate selectTheGroup:request.department.groupID];
    }
}

-(void)changeGroupOrderInStarredGroups:(FavoriteGroupCell *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGroupOrder:)]) {
        [self.delegate changeGroupOrder:self];
    }
}

-(void)pickTheGroupInStarredGroup:(FavoriteGroupCell *)request{
    
    if (self.selectedDepartments == Nil) {
        self.selectedDepartments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    Department* department =[self isDepartmentSelected:request.department.groupID];
    if (department ==nil) {
        [self.selectedDepartments addObject:request.department];
    }
    
    [self tile];
}

-(void)unpickTheGroupInStarredGroup:(FavoriteGroupCell *)request{
    if (self.selectedDepartments == Nil) {
        self.selectedDepartments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    Department* department =[self isDepartmentSelected:request.department.groupID];
    if (department!=nil) {
        [self.selectedDepartments removeObject:department];
    }
    [self tile];
}

#pragma mark - grouplistcell delegate

-(void)pickTheGroup:(GroupListCell *)request{
    if (self.selectedDepartments == Nil) {
        self.selectedDepartments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    Department* department =[self isDepartmentSelected:request.department.groupID];
    if (department ==nil) {
        [self.selectedDepartments addObject:request.department];
    }
    
      [self tile];
}

-(void)unpickTheGroup:(GroupListCell *)request
{
    if (self.selectedDepartments == Nil) {
        self.selectedDepartments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    Department* department =[self isDepartmentSelected:request.department.groupID];
    if (department!=nil) {
        [self.selectedDepartments removeObject:department];
    }
    
    [self tile];
}

-(void)removeColsedCellData:(NSMutableDictionary*)dict
{
    NSArray* keys = [dict allKeys];
    
    for (int i = 0; i < [keys count]; i ++) {
        NSString* key = [keys objectAtIndex:i];
        if ([[dict valueForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            
            [self removeColsedCellData:[dict valueForKey:key]];
            Department* department = [self departmentInSortedKeys:key];
            GroupListCell* cell = [_celldict valueForKey:department.groupID];
            [cell removeFromSuperview];
            [_celldict removeObjectForKey:department.groupID];
            [self.sortedKeys removeObject:department];
        }
        else{
            Department* department = [dict valueForKey:key];
            GroupListCell* cell = [_celldict valueForKey:department.groupID];
            [cell removeFromSuperview];
            [_celldict removeObjectForKey:department.groupID];
            [self.sortedKeys removeObject:department];
        }
        
    }
}

-(Department*)departmentInSortedKeys:(NSString*)departmentid
{
    for (Department* department in self.sortedKeys) {
        if ([department.groupID isEqualToString:departmentid]) {
            return department;
        }
    }
    return nil;
}


-(void)messageTheGroup:(GroupListCell *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageTheGroup:)]) {
        [self.delegate messageTheGroup:request.department.groupID];
    }
}


-(void)favirateTheGroup:(GroupListCell *)request
{
    /*
     if (self.delegate && [self.delegate respondsToSelector:@selector(favirateTheGroup:)]) {
     [self.delegate favirateTheGroup:request.department.groupID];
     }
     */
    if ([Database isDepartmentFavorited:request.department.groupID]) {
        [Database deFavoriteDepartment:request.department.groupID];
        [WowTalkWebServerIF defavoriteGroup:request.department.groupID withCallback:nil withObserver:nil];
        [request.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
        
    }
    else{
        [Database favoriteDepartment:request.department.groupID];
        [WowTalkWebServerIF favoriteGroup:request.department.groupID withCallback:nil withObserver:nil];
        [request.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK_P] forState:UIControlStateNormal];
    }
    
    [self tile];
    
    
}
-(void)selectTheGroup:(GroupListCell *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTheGroup:)]) {
        [self.delegate selectTheGroup:request.department.groupID];
    }
}

-(void)toggleTheGroup:(GroupListCell *)request
{
    // find the group
    Department* department = request.department;
    
    if (request.isOpen) {
        
        depth = department.level;
        
        request.isOpen = FALSE;
        [request.arrow setImage:[UIImage imageNamed:GROUP_ARROW_RIGHT] forState:UIControlStateNormal];
        
        NSMutableArray* path = [self findThePathToDepartment:department];
        int i = 0;
        NSMutableDictionary* dict = self.groups;
        
        while (i < [path count]-1) {
            dict = [dict objectForKey:[path objectAtIndex:i]];
            i ++;
        }
        NSMutableDictionary* childrendict = [dict objectForKey:[path lastObject]];
        
        // remove the department recursively
        [self removeColsedCellData:childrendict];
        [dict setValue:department forKey:department.groupID];
        
        tilingpos = 0;
        
        [self tileGroups:self.groups withIndex:0];
        self.groupContainerView.contentSize = CGSizeMake(320, favoritePartHeight+[self.sortedKeys count]*44);
    }
    else{
        
        depth = department.level;
        
        [request.arrow setImage:[UIImage imageNamed:GROUP_ARROW_DOWN] forState:UIControlStateNormal];
        
        NSMutableArray* children = [Database getChildrenDepartmentsForDeparment:department.groupID];
        
        NSMutableDictionary* childrendict = [self dictFromarray:children withParent:department];
        
        request.isOpen = TRUE;
        NSMutableArray* path = [self findThePathToDepartment:department];
        int i = 0;
        NSDictionary* dict = self.groups;
        
        while (i < [path count]) {
            if (![[dict objectForKey:[path objectAtIndex:i]] isKindOfClass:[NSMutableDictionary class]]) break;
            dict = [dict objectForKey:[path objectAtIndex:i]];
            i ++;
        }
        
        [dict setValue:childrendict forKey:[path lastObject]];
        
        [self resetSiblings:path];
        
        int index = [self.sortedKeys indexOfObject:department];
        for (Department* department in children) {
            [self.sortedKeys insertObject:[childrendict valueForKey:department.groupID] atIndex:++index];
        }
        
        tilingpos = 0;
        [self tileGroups:self.groups withIndex:0];
        self.groupContainerView.contentSize = CGSizeMake(320, favoritePartHeight+[self.sortedKeys count]*44);
        
        
    }
}

-(void)resetSiblings:(NSMutableArray*)path
{
    NSMutableDictionary* dict = self.groups;
    int i = 0;
    while (i < ([path count] -1)) {
        dict = [dict objectForKey:[path objectAtIndex:i]];
        i++;
    }
    NSString* ignorekey = [path lastObject];
    
    NSArray* keys = [dict allKeys];
    for(NSString* key in keys){
        if ([ignorekey isEqualToString:key]) {
            continue;
        }
        if ([[dict objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            
            [self removeColsedCellData:[dict objectForKey:key]];
            Department* department = [self departmentInSortedKeys:key];
            [dict setValue:department forKey:department.groupID];
            
            // make the cell close
            GroupListCell* cell = [_celldict valueForKey:department.groupID];
            cell.isOpen = FALSE;
            [cell.arrow setImage:[UIImage imageNamed:GROUP_ARROW_RIGHT] forState:UIControlStateNormal];
            
        }
        
    }
}

#pragma mark -- check exsiting
-(Department*)isDepartmentSelected:(NSString*)departmentid
{
    for (Department* department in self.selectedDepartments) {
        if ([department.groupID isEqualToString:departmentid]) {
            return department;
        }
    }
    return nil;
}



-(void)dealloc
{
    self.celldict = nil;
    self.visibileGroupCells = nil;
    [super dealloc];
}

@end