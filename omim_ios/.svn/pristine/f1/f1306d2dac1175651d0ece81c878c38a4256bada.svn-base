//
//  OMSearchBuddyResultCell.m
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSearchBuddyResultCell.h"

#import "WTUserDefaults.h"

#import "Buddy.h"

#import "OMHeadImgeView.h"



@interface OMSearchBuddyResultCell ()

/** 头像view */
@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

/** 账号标题label */
@property (retain, nonatomic) IBOutlet UILabel *account_title_label;

/** 昵称标题label */
@property (retain, nonatomic) IBOutlet UILabel *nickname_title_label;

/** 账号 lable */
@property (retain, nonatomic) IBOutlet UILabel *account_content_label;

/** 昵称label */
@property (retain, nonatomic) IBOutlet UILabel *nickname_content_label;

/** 添加按钮 */
@property (retain, nonatomic) IBOutlet UIButton *add_button;

/** account_content_label 的宽度约束 */
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *account_width;

/** nickname_content_label 的宽度约束 */
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *nickname_width;

@end


@implementation OMSearchBuddyResultCell

-(void)dealloc{
    self.buddy = nil;
    [_head_view release];
    [_account_title_label release];
    [_nickname_title_label release];
    [_account_content_label release];
    [_nickname_content_label release];
    [_add_button release];
    [_account_width release];
    [_nickname_width release];
    [super dealloc];
}

/** 点击添加按钮 */
- (IBAction)addAction:(UIButton *)sender {
//    _buddy.relationship_type = Buddy_Relationship_type_ADDING;
//    self.buddy = _buddy;
    
    if ([self.delegate respondsToSelector:@selector(searchBuddyResultCell:addBuddy:)]){
        [self.delegate searchBuddyResultCell:self addBuddy:self.buddy];
    }
}



#pragma mark - Set and Get

-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    
    self.head_view.buddy = _buddy;
    self.account_content_label.text = _buddy.wowtalkID;
    self.nickname_content_label.text = _buddy.nickName;
    
    switch (_buddy.relationship_type) {
        case Buddy_Relationship_Type_UNADD:{
            self.add_button.enabled = YES;
            self.add_button.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:1.0f alpha:1.0f];
            [self.add_button setTitle:NSLocalizedString(@"Add",nil) forState:UIControlStateNormal];
        }break;
        case Buddy_Relationship_type_ADDED:{
            self.add_button.enabled = NO;
            self.add_button.backgroundColor = [UIColor lightGrayColor];
            [self.add_button setTitle:NSLocalizedString(@"Already Added",nil) forState:UIControlStateNormal];
        }break;
        case Buddy_Relationship_type_ADDING:{
            self.add_button.enabled = NO;
            [self.add_button setTitle:NSLocalizedString(@"Adding",nil) forState:UIControlStateNormal];
            self.add_button.backgroundColor = [UIColor lightGrayColor];
        }break;
        case Buddy_Relationship_type_ISSELF:{
            self.add_button.enabled = NO;
            [self.add_button setTitle:NSLocalizedString(@"Is Self",nil) forState:UIControlStateNormal];
            self.add_button.backgroundColor = [UIColor lightGrayColor];
        }break;
        default:
            break;
    }
}




+ (instancetype )cellWithTableview:(UITableView *)tableView{
    static NSString *cellID = @"OMSearchBuddyResultCellID";
    OMSearchBuddyResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMSearchBuddyResultCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    self.account_title_label.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"Account",nil)];
    self.nickname_title_label.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"Nickname",nil)];
    
    self.account_width.constant = self.add_button.x - self.account_content_label.x;
    self.nickname_width.constant = self.add_button.x - self.nickname_content_label.x;
    
    self.add_button.layer.masksToBounds = YES;
    self.add_button.layer.cornerRadius = 3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
        
}

@end
