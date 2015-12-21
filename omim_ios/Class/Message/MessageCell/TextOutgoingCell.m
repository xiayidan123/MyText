//
//  TextOutgoingCell.m
//  omim
//
//  Created by coca on 2012/10/08.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "TextOutgoingCell.h"

#import "WowTalkVoipIF.h"

#import "Constants.h"
#import "WTHeader.h"

#import "UITextView+Size.h"
#import "MsgComposerVC.h"

@implementation TextOutgoingCell
@synthesize lbl_msg,lbl_senttime,lbl_status;
@synthesize btn_resend;
@synthesize iv_bg;
@synthesize parent = _parent;
@synthesize msg = _msg;
@synthesize ua_indicator = _ua_indicator;


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



-(void)ResendTextMessage
{
    if ([self.parent isKindOfClass:[MsgComposerVC class]]) {
        MsgComposerVC *vc = (MsgComposerVC *)self.parent;
        [vc.txtView_Input resignFirstResponder];
        
        if(![WowTalkVoipIF fIsConnectedToServer])
        {
            // TODO : pop up a alert to say that the server is not ready
            
        }
        
        if (vc.isGroupMode) {
            self.msg.isGroupChatMessage = TRUE;
            self.msg.groupChatSenderID = [WTUserDefaults getUid];
            [WowTalkWebServerIF groupChat_SendMessage:self.msg toGroup:vc._userName  withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
            
        }
        else{
            [WowTalkWebServerIF sendBuddyMessage:self.msg];
        }
        
    }
    
    
    [self setNeedsLayout];
    
}

+(float)getCellHeight:(NSString*)text{
    float txtWidth = [UITextView txtWidth:text fontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
    float txtHeight = [UITextView txtHeight:text fontSize:TEXTCELL_CACULATED_FONT andWidth:txtWidth];
    
    return txtHeight + CHATCELL_CONTENT_THIN_OFFSET_Y*2  + OUTGOINGCELL_OFFSET_Y;
}


-(void)layoutSubviews
{
    
    /* int txtHeight = [UILabel txtHeight:self.msg.messageContent FontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
     int txtWidth = [UILabel txtWidth:self.msg.messageContent FontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH]+16.0;
     */
    
    float txtWidth = [UITextView txtWidth:self.msg.messageContent fontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
    float txtHeight = [UITextView txtHeight:self.msg.messageContent fontSize:TEXTCELL_CACULATED_FONT andWidth:txtWidth];
    
    txtWidth = txtWidth > 50 ? txtWidth : 50;
    
    
    CGFloat screenwidth = [UISize screenWidth];
    
    self.contentView.frame = CGRectMake(0, 0, screenwidth, txtHeight+ CHATCELL_CONTENT_THIN_OFFSET_Y*2+ OUTGOINGCELL_OFFSET_Y);
    self.iv_bg.frame = CGRectMake([UISize screenWidth] - OUTGOINGCELL_BG_DIST_R - txtWidth-CHATCELL_CONTENT_THIN_OFFSET_X*2 , 3 , txtWidth +CHATCELL_CONTENT_THIN_OFFSET_X*2 + BG_TAIL_WIDTH, txtHeight + CHATCELL_CONTENT_THIN_OFFSET_Y*2);
    
    self.lbl_msg.frame = CGRectMake(self.iv_bg.frame.origin.x+CHATCELL_CONTENT_THIN_OFFSET_X , CHATCELL_CONTENT_THIN_OFFSET_Y , txtWidth, txtHeight);
    self.lbl_msg.hidden = YES;
    
    
    _lblText.font = [UIFont systemFontOfSize:16.0];
    _lblText.frame =  CGRectMake(self.iv_bg.frame.origin.x+CHATCELL_CONTENT_THIN_OFFSET_X , CHATCELL_CONTENT_THIN_OFFSET_Y , txtWidth, txtHeight);
    
    _lblText.backgroundColor = [UIColor clearColor];
    _lblText.textColor = [Colors chatTextColor_R];
    _lblText.textAlignment = NSTextAlignmentLeft;
    _lblText.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress;
    _lblText.editable = NO;
    _lblText.scrollEnabled = NO;
    
    self.lbl_status.frame = CGRectMake(self.iv_bg.frame.origin.x-OUTGOINGCELL_STATUS_BG_OFFSET_X -OUTGOINGCELL_STATUS_W, OUTGOINGCELL_STATUS_Y , OUTGOINGCELL_STATUS_W, OUTGOINGCELL_STATUS_H);
    self.lbl_senttime.frame = CGRectMake(self.iv_bg.frame.origin.x-OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X-SENTTIMELABEL_W , OUTGOINGCELL_SENTTIMELABEL_Y , SENTTIMELABEL_W, SENTTIMELABEL_H);
    
    self.btn_resend.frame = CGRectMake(self.iv_bg.frame.origin.x-OUTGOINGCELL_FAILMARK_BG_OFFSET_X - OUTGOINGCELL_FAILMARK_W, (self.iv_bg.frame.size.height-OUTGOINGCELL_FAILMARK_H)/2 , OUTGOINGCELL_FAILMARK_W, OUTGOINGCELL_FAILMARK_H);
    
    [self.ua_indicator stopAnimating];
    [self.ua_indicator setHidden:TRUE];
    
    
    self.lbl_status.text = @"";
    
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
        
        if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_SENT]])
        {
            self.lbl_status.text = NSLocalizedString(@"Sent", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_REACHED_CONTACT]])
        {
            self.lbl_status.text = NSLocalizedString(@"Reached", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_READED_BY_CONTACT]])
        {
            self.lbl_status.text = NSLocalizedString(@"Read", nil);
            
        }
        
        
        if (self.msg.isGroupChatMessage) {
            NSInteger readCount = self.msg.readCount;
            if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_READED_BY_CONTACT]] && readCount > 0) {
                NSString *readString = [NSString stringWithFormat:@"%@%ld", NSLocalizedString(@"Read", nil), (long)readCount];
                self.lbl_status.text = readString;
            }
        }
        
        
    }
    
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    [self bringSubviewToFront:_lblText];
    
}


-(void)dealloc
{
    self.iv_bg = nil;
    self.btn_resend = nil;
    self.lbl_senttime = nil;
    self.lbl_msg = nil;
    self.lbl_status = nil;
    
    [_lblText release];
    [super dealloc];
    
}

@end