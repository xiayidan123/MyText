//
//  CallIncomingCell.m
//  omim
//
//  Created by coca on 2013/02/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "CallIncomingCell.h"
#import "WowTalkVoipIF.h"
#import "MsgComposerVC.h"
#import "ContactInfoViewController.h"


@implementation CallIncomingCell

@synthesize parent,iv_call,iv_bg,iv_profile,lbl_senttime,lbl_msg,btn_call;
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


-(IBAction)readyTocall:(id)sender{
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


-(void)viewBuddy
{

    Buddy* buddy;
    if (self.msg.isGroupChatMessage) {
        buddy = [Database buddyWithUserID:self.msg.groupChatSenderID]; 
    }
    else{
        buddy = [Database buddyWithUserID:self.msg.chatUserName];
    }

    
        ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        contactInfoViewController.buddy = buddy;
        
        if (buddy.isFriend) {
            contactInfoViewController.contact_type = CONTACT_FRIEND;
        }
        else
            contactInfoViewController.contact_type = CONTACT_STRANGER;
        
        [[(MsgComposerVC*)self.parent navigationController] pushViewController:contactInfoViewController animated:YES];
        [contactInfoViewController release];
    
}


-(void)dealloc
{
    self.parent = nil;
    self.msg = nil;
    self.iv_profile = nil;
    self.iv_call = nil;
    self.iv_bg = nil;
    self.lbl_msg = nil;
    self.lbl_senttime = nil;
    self.btn_viewbuddy = nil;
    self.btn_call = nil;
    
    [super dealloc];
}

@end
