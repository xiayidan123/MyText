//
//  LocationOutgoingCell.m
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "LocationOutgoingCell.h"
#import <MapKit/MapKit.h>

#import "WowTalkVoipIF.h"
#import "CustomAnnotation.h"
#import "ViewDetailedLocationVC.h"

#import "Constants.h"
#import "WTHeader.h"
#import "PublicFunctions.h"

#import "MsgComposerVC.h"



@implementation LocationOutgoingCell

@synthesize iv_bg = _iv_bg;
@synthesize lbl_senttime = _lbl_senttime;
@synthesize lbl_status = _lbl_status;
@synthesize parent = _parent;
@synthesize msg = _msg;
@synthesize btn_resend = _btn_resend;
@synthesize iv_content = _iv_content;
@synthesize btn_view = _btn_view;
@synthesize lbl_address = _lbl_address;

@synthesize vdl = _vdl;
@synthesize ua_indicator = _ua_indicator;

-(IBAction)viewDetailedMap:(id)sender
{
  //  NSLog(@"view large map");
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    CLLocationDegrees latitude = [[(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:LONGITUDE] doubleValue];
    
    self.vdl = [[[ViewDetailedLocationVC alloc] initWithNibName:@"ViewDetailedLocationVC" bundle:nil] autorelease];
    
    self.vdl.address = [[jp fragmentWithString: self.msg.messageContent] objectForKey:@"address"];
    self.vdl.mode = VIEW_DATA;
    self.vdl.delegate = self.parent;
    self.vdl.parent = self.parent;
    
    self.vdl.latitude = latitude;
    self.vdl.longitude = longitude;
    self.vdl.fixOrigin = TRUE;
    
    [self.parent.navigationController pushViewController:self.vdl animated:YES];
    
   // [self.parent.uv_barcontainer setHidden:YES];


}

-(void)resendLocationMessage
{
    if (self.parent.isGroupMode) {
        self.msg.isGroupChatMessage = TRUE;
        self.msg.groupChatSenderID = [WTUserDefaults getUid];
        [WowTalkWebServerIF groupChat_SendMessage:self.msg toGroup:self.parent._userName withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
    }
    else{
        [WowTalkWebServerIF sendBuddyMessage:self.msg];
    }
}

-(void)layoutSubviews
{
    // content view frame.
    [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.iv_bg.frame.origin.y +self.iv_bg.frame.size.height+ OUTGOINGCELL_OFFSET_Y)];
    
    [self.ua_indicator stopAnimating];
    [self.ua_indicator setHidden:TRUE];
    
    if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_NOTSENT]])
    {
        self.btn_resend.hidden = NO;
        self.lbl_senttime.hidden = YES;
        self.lbl_status.hidden = YES;
        
        self.lbl_status.text = @"";
        self.lbl_senttime.text = @"";
        
    }
    else if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_IN_PROCESS]]){
        self.btn_resend.hidden = YES;
        self.lbl_senttime.hidden = YES;
        self.lbl_status.hidden = YES;
        
        self.lbl_status.text = @"";
        self.lbl_senttime.text = @"";
        
        [self.ua_indicator setFrame:CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_INDICATOR_OFFSET_X-OUTGOINGCELL_INDICATOR_W, (self.iv_bg.frame.origin.y + self.iv_bg.frame.size.height - OUTGOINGCELL_INDICATOR_H)/2.0, OUTGOINGCELL_INDICATOR_W, OUTGOINGCELL_INDICATOR_H)];
        [self.ua_indicator setHidden:false];
        [self.ua_indicator startAnimating];
    }
    else
    {
        self.btn_resend.hidden = YES;
        self.lbl_senttime.hidden = NO;
        self.lbl_status.hidden = NO;
        
        if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_SENT]]){
            self.lbl_status.text = NSLocalizedString(@"Sent", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_REACHED_CONTACT]]){
            self.lbl_status.text = NSLocalizedString(@"Reached", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_READED_BY_CONTACT]]){
            self.lbl_status.text = NSLocalizedString(@"Read", nil);
        }
        
    }
    
    
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    
    
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
    self.vdl = nil;
    
    self.iv_bg = nil;
    self.iv_content = nil;
    
    self.lbl_address = nil;
    
    self.lbl_senttime = nil;
    self.btn_resend = nil;
    self.lbl_status =nil;
    
    self.btn_view = nil;
    
    [super dealloc];
    
}

@end
