//
//  LocationIncomingCell.m
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "LocationIncomingCell.h"
#import <MapKit/MapKit.h>

#import "WTHeader.h"

#import "CustomAnnotation.h"
#import "ViewDetailedLocationVC.h"


#import "Constants.h"

#import "MsgComposerVC.h"

#import "ContactInfoViewController.h"
//#import "BizContactViewController.h"

@implementation LocationIncomingCell

@synthesize iv_bg = _iv_bg;
@synthesize lbl_senttime = _lbl_senttime;
@synthesize parent = _parent;
@synthesize msg = _msg;
@synthesize iv_content = _iv_content;
@synthesize btn_view = _btn_view;
@synthesize lbl_address = _lbl_address;
@synthesize lbl_name = _lbl_name;

@synthesize vdl = _vdl;


-(IBAction)viewTheDetailMap:(id)sender
{
  //  NSLog(@"view large map");
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    CLLocationDegrees latitude = [[(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:LONGITUDE] doubleValue];

    self.vdl = [[[ViewDetailedLocationVC alloc] initWithNibName:@"ViewDetailedLocationVC" bundle:nil] autorelease];
    
    self.vdl.mode = VIEW_DATA;
    self.vdl.delegate = self.parent;
    self.vdl.parent = self.parent;
    self.vdl.fixOrigin = TRUE;
    self.vdl.latitude = latitude;
    self.vdl.longitude = longitude;
    self.vdl.address = [[jp fragmentWithString:self.msg.messageContent] objectForKey:@"address"];
    
    [self.parent.navigationController pushViewController:self.vdl animated:YES];
    
  //  [self.parent.uv_barcontainer setHidden:YES];
    
    
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

-(void)dealloc
{
    self.iv_bg=nil;
    self.lbl_senttime = nil;
    
    self.lbl_name = nil;
    self.lbl_address = nil;
    
    self.iv_content = nil;
    
   self.btn_view = nil;
    
    self.vdl = nil;
    
    self.btn_viewbuddy = nil;
    
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}

@end
