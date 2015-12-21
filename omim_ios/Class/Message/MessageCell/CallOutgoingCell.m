//
//  CallOutgoingCell.m
//  omim
//
//  Created by coca on 2013/02/22.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "CallOutgoingCell.h"
#import "WowTalkVoipIF.h"
#import "MsgComposerVC.h"
@implementation CallOutgoingCell
@synthesize iv_bg,iv_call,btn_call,lbl_msg,lbl_senttime,lbl_status,parent;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)readyToCall:(id)sender{
    NSString *title=[NSString stringWithFormat: NSLocalizedString(@"Make a call?", nil), self.parent._displayname];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Nil message:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!= alertView.cancelButtonIndex) {
        [WowTalkVoipIF fNewOutgoingCall:self.parent._userName withDisplayName:self.parent._displayname withVideo:NO];
    }
}


@end
