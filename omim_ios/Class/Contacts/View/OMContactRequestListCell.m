//
//  OMContactRequestListCell.m
//  dev01
//
//  Created by Starmoon on 15/7/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMContactRequestListCell.h"

#import "OMHeadImgeView.h"
#import "PendingRequest.h"
#import "Buddy.h"

@interface OMContactRequestListCell ()

@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_View;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

@property (retain, nonatomic) IBOutlet UILabel *intro_label;

@property (retain, nonatomic) IBOutlet UIButton *reject_button;

@property (retain, nonatomic) IBOutlet UIButton *accept_button;


@end


@implementation OMContactRequestListCell


- (void)dealloc {
    self.request = nil;
    [_head_View release];
    [_name_label release];
    [_intro_label release];
    [_reject_button release];
    [_accept_button release];
    [super dealloc];
}


#pragma mark - Action 

- (IBAction)acceptAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestListCell:didDealRequestWithAccept:withRequest:)]){
        [self.delegate contactRequestListCell:self didDealRequestWithAccept:YES withRequest:self.request];
    }
}
- (IBAction)rejectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestListCell:didDealRequestWithAccept: withRequest:)]){
        [self.delegate contactRequestListCell:self didDealRequestWithAccept:NO withRequest:self.request];
    }
}


-(void)setRequest:(PendingRequest *)request{
    [_request release];_request = nil;
    _request = [request retain];
    
    self.name_label.text = _request.nickname;
    self.intro_label.text = _request.msg;
    Buddy *buddy = [[Buddy alloc]init];
    buddy.userID = _request.buddyid;
    self.head_View.buddy = buddy;
    [buddy release];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OMContactRequestListCellID";
    OMContactRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMContactRequestListCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    self.head_View.headImageCornerRadius = 3;
    self.accept_button.layer.masksToBounds = YES;
    self.accept_button.layer.cornerRadius = 3;
    self.reject_button.layer.masksToBounds = YES;
    self.reject_button.layer.cornerRadius = 3;
    
    [self.accept_button setTitle:NSLocalizedString(@"Accecpt", nil) forState:UIControlStateNormal];
    [self.reject_button setTitle:NSLocalizedString(@"Reject", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
