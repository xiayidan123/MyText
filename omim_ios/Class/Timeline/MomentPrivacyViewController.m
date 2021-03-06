//
//  MomentPrivacyViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/10/02.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "MomentPrivacyViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"

#import "GroupList.h"
#import "GroupButton.h"

@interface MomentPrivacyViewController ()<GroupButtonDelegate,GroupListDelegate>
{
    CGFloat departmentRowHeight;
    int selected;
}

@end

@implementation MomentPrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.sv_bg setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    
    [self.tb_options setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    [self.tb_options setScrollEnabled:FALSE];
    
    [self configNav];
    
    if (self.selectedDepartments!=nil&&[self.selectedDepartments count]>0) {
        selected = 1;
    }
    else
        selected = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - navigation bar
-(void)configNav
{
    NSString* title = NSLocalizedString(@"Who can see this?", nil);
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
          [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
}


-(void)goBack
{
    if (selected == 0) {
        [self.selectedDepartments removeAllObjects];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetShareRange:)]) {
            [self.delegate didSetShareRange:self];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)comfirmSelection{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];

    [self.navigationItem removeRightBarButtonItem];
    
    GroupList* grouplist = (GroupList*)[self.view viewWithTag:1000];
    
    if (grouplist!=nil) {
        self.selectedDepartments = grouplist.selectedDepartments;
        grouplist.hidden = TRUE;
    }
 
    [self.tb_options reloadData];
  
    [self.tb_options setFrame:CGRectMake(self.tb_options.frame.origin.x, self.tb_options.frame.origin.y, self.tb_options.frame.size.width, departmentRowHeight + 44 )];
    [self.sv_bg setContentSize:CGSizeMake(320, departmentRowHeight + 44+ 20)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSetShareRange:)]) {
        [self.delegate didSetShareRange:self];
    }
}

-(void)dismissGrouplist{
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_CLOSE_IMAGE] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    [self.navigationItem removeRightBarButtonItem];
    
    GroupList* grouplist = (GroupList*)[self.view viewWithTag:1000];
    if (grouplist!=nil) {
        grouplist.hidden = TRUE;
    }
    
}


#pragma mark - tableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
    if (cell == Nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    for (UIView* subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    UIImageView* iv_selected = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 14, 14)];
    [cell.contentView addSubview:iv_selected];
    [iv_selected release];
    
    UILabel* lbl_desc = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 270, 44)];
    lbl_desc.font = [UIFont systemFontOfSize:17];
    lbl_desc.textColor = [UIColor blackColor];
    lbl_desc.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lbl_desc];
    [lbl_desc release];
    
    if (indexPath.row == 0) {
        lbl_desc.text = NSLocalizedString(@"Public(Everyone can see)",nil);
        if (selected == 0) {
            [iv_selected setImage:[UIImage imageNamed:@"table_checkmark.png"]];
        }
        else
            [iv_selected setImage:nil];
    }
    else{
        lbl_desc.text = NSLocalizedString(@"Limited to below", nil);
        if (selected == 1) {
            [iv_selected setImage:[UIImage imageNamed:@"table_checkmark.png"]];
        }
        else
            [iv_selected setImage:nil];
        
        if ([self.selectedDepartments count] > 0) {
            [self titleGroups:cell];
        }
        else{
            if (!self.isNotEditable) {
                NSString* text = NSLocalizedString(@"Add departments", Nil);
                CGFloat width = [UILabel labelWidth:text FontType:17 withInMaxWidth:260];
                UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(30, 44 , width+20 , 30)];
                [button setBackgroundColor:[Colors wowtalkbiz_inactive_text_gray]];
                [button setTitle:text forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addDepartment) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                [cell.contentView setFrame:CGRectMake(0, 0, 320, button.frame.origin.y + 30 + 10)];
                [button release];
            }
        }
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNotEditable) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if (indexPath.row == 0) {
        selected = 0;
    }
    else
        selected = 1;
    
    [tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 44;
    }
    else if(indexPath.row == 1){
        if ([self.selectedDepartments count] > 0) {
            int origin_x = 30;
            int origin_y = 44;
            
            for (Department* department in self.selectedDepartments) {
                CGFloat width = [UILabel labelWidth:department.groupNameLocal FontType:17 withInMaxWidth:250];
                CGFloat neworigin = origin_x + width+30 + 15;
                if (neworigin > 270) {
                    origin_x =  30+ width+30 + 15;
                    origin_y += 40;
                }
                else{
                    origin_x = neworigin;
                }
            }
            
            if (self.isNotEditable) {
                origin_y += 40;
                departmentRowHeight = origin_y + 5;
                return origin_y + 5;
            }
            else{
                origin_y += 40;
                departmentRowHeight = origin_y+45;
                return origin_y + 45;
            }
        }
        else{
            if (self.isNotEditable) {
                 departmentRowHeight = 44;
                return 44;
            }
            else{
                departmentRowHeight = 88;
                return 88;
            }
        }
    }
    else return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark -- change groups button
-(void)titleGroups:(UITableViewCell*)cell
{
    int origin_x = 30;
    int origin_y = 44;
    
    for (Department* department in self.selectedDepartments) {
        GroupButton* gbutton = [[GroupButton alloc] initWithFrame:CGRectMake(origin_x, origin_y, 100, 30)];
        gbutton.delegate = self;
        gbutton.isNotEditable = self.isNotEditable;
        [cell.contentView addSubview:gbutton];
        [gbutton release];
        
        gbutton.buttontext = department.groupNameLocal;
        CGFloat neworigin = origin_x + gbutton.frame.size.width + 15;
        
        if (neworigin > 270) {
            origin_x = 30;
            origin_y += 40;
            [gbutton setFrame:CGRectMake(origin_x, origin_y, gbutton.frame.size.width, gbutton.frame.size.height)];
             origin_x = origin_x + gbutton.frame.size.width + 15;
        }
        else{
            [gbutton setFrame:CGRectMake(origin_x, origin_y, gbutton.frame.size.width, gbutton.frame.size.height)];
             origin_x = neworigin;
        }
    }
    
    origin_y += 40;
    
    if (!self.isNotEditable){
        NSString* text = NSLocalizedString(@"Add departments", Nil);
        CGFloat width = [UILabel labelWidth:text FontType:17 withInMaxWidth:260];
    
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(30, origin_y, width+20 , 30)];
    
        [button setBackgroundColor:[Colors wowtalkbiz_inactive_text_gray]];
        [button setTitle:text forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addDepartment) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button release];
        [cell.contentView setFrame:CGRectMake(0, 0, 320, button.frame.origin.y + 30 + 10)];
    }
    else{
        [cell.contentView setFrame:CGRectMake(0, 0, 320, origin_y)];
    }
    
}

-(void)addDepartment
{
    selected = 1;
    [self.tb_options reloadData];
    
    UIBarButtonItem *dismissButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_CLOSE_IMAGE] selector:@selector(dismissGrouplist)];
    [self.navigationItem addLeftBarButtonItem:dismissButton];
    [dismissButton release];
    
//    UIBarButtonItem *confirmButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(comfirmSelection)];
    UIBarButtonItem *confirmButton = [PublicFunctions getCustomNavButtonWithText:NSLocalizedString(@"Moment Done", nil) target:self selection:@selector(comfirmSelection)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    [confirmButton release];

    GroupList* grouplist = (GroupList*)[self.view viewWithTag:1000];
    if (grouplist == nil) {
        grouplist = [[GroupList alloc] initWithFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        grouplist.selectedDepartments = self.selectedDepartments;
        grouplist.isWithStarAndChat=false;
        grouplist.selectionMode = TRUE;  // title here.        
        grouplist.tag = 1000;
        grouplist.delegate = self;
        [self.view addSubview:grouplist];
        [grouplist release];
    }
    else{
        grouplist.selectedDepartments = self.selectedDepartments;
        grouplist.hidden = FALSE;
        [grouplist tile];
    }
    
   
}

#pragma mark - groupbutton delegate
-(void)deleteThisGroup:(GroupButton *)button{
    for (int i = 0; i< [self.selectedDepartments count]; i ++) {
        Department* department = [self.selectedDepartments objectAtIndex:i];
        if ([department.groupNameLocal isEqualToString:button.buttontext]) {
            [self.selectedDepartments removeObject:department];
        }
    }
    
    [self.tb_options reloadData];
    [self.tb_options setFrame:CGRectMake(self.tb_options.frame.origin.x, self.tb_options.frame.origin.y, self.tb_options.frame.size.width, departmentRowHeight + 44 )];
    [self.sv_bg setContentSize:CGSizeMake(320, departmentRowHeight + 44+ 20)];
}


@end
