//
//  TextIncomingCell.m
//  omim
//
//  Created by coca on 2012/10/07.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "TextIncomingCell.h"

#import "WTHeader.h"
#import "UITextView+Size.h"

#import "Constants.h"
#import "ChatMessage.h"

#import "ContactInfoViewController.h"
//#import "BizContactViewController.h"

@implementation TextIncomingCell
@synthesize lbl_msg,lbl_senttime,lbl_name;
@synthesize iv_bg;
@synthesize parent=_parent ,msg=_msg;

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





+(float)getCellHeight:(NSString*)text forGroupMsg:(BOOL)isGroupMsg{
    float txtWidth = [UITextView txtWidth:text fontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
    float txtHeight = [UITextView txtHeight:text fontSize:TEXTCELL_CACULATED_FONT andWidth:txtWidth];
    
    
    if (isGroupMsg) {
        return INCOMINGCELL_BG_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y + txtHeight + CHATCELL_CONTENT_THIN_OFFSET_Y + INCOMINGCELL_OFFSET_Y ;
    }
    return txtHeight + INCOMINGCELL_BG_Y +CHATCELL_CONTENT_THIN_OFFSET_Y*2 +INCOMINGCELL_OFFSET_Y ;

}

-(void)layoutSubviews
{
    /*int labelHeight = [UILabel labelHeight:self.msg.messageContent FontType:17 withInMaxWidth:TEXTCELL_MAX_WIDTH];
    int labelWidth = [UILabel labelWidth:self.msg.messageContent FontType:17 withInMaxWidth:TEXTCELL_MAX_WIDTH];
    */
    
    float labelWidth = [UITextView txtWidth:self.msg.messageContent fontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
    

    
    int nameLabelWidth = [UILabel labelWidth:self.lbl_name.text FontType:10 withInMaxWidth:TEXTCELL_MAX_WIDTH];
    if (nameLabelWidth > labelWidth) {
        labelWidth = nameLabelWidth;
    }
    
    
    float labelHeight = [UITextView txtHeight:self.msg.messageContent fontSize:TEXTCELL_CACULATED_FONT andWidth:labelWidth];

    
    
    if (self.msg.isGroupChatMessage) {
        labelWidth = labelWidth > 50 ? labelWidth : 50;
        self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y , labelWidth + CHATCELL_CONTENT_LARGE_OFFSET_X*2 + BG_TAIL_WIDTH, INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y + labelHeight + CHATCELL_CONTENT_LARGE_OFFSET_Y +BG_TAIL_HEIGHT );
        
        self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y , labelWidth + CHATCELL_CONTENT_THIN_OFFSET_X*2 + BG_TAIL_WIDTH, INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y + labelHeight + CHATCELL_CONTENT_THIN_OFFSET_Y +BG_TAIL_HEIGHT );
        
        self.lbl_msg.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X+BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+ INCOMINGCELL_NAME_MSG_GAP_Y + INCOMINGCELL_NAME_H , labelWidth, labelHeight);
        self.lbl_msg.hidden = YES;
        
        _lblText.font = [UIFont systemFontOfSize:16.0];
       
        _lblText.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X+BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+ INCOMINGCELL_NAME_MSG_GAP_Y + INCOMINGCELL_NAME_H , labelWidth, labelHeight);
        
        _lblText.backgroundColor = [UIColor clearColor];
        _lblText.textColor = [Colors chatTextColor_L];
        _lblText.textAlignment = NSTextAlignmentLeft;
        _lblText.editable = NO;
        _lblText.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress;
        _lblText.scrollEnabled = NO;
        
        self.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
        
        self.lbl_senttime.frame = CGRectMake(INCOMINGCELL_BG_X +self.iv_bg.frame.size.width +INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X , INCOMINGCELL_BG_Y+self.iv_bg.frame.size.height -INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y- SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
        
        self.headImageView.frame = CGRectMake(INCOMINGCELL_PROFILE_X, INCOMINGCELL_PROFILE_Y, INCOMINGCELL_PROFILE_W, INCOMINGCELL_PROFILE_H);
    }
    else{
        
        labelWidth = labelWidth > 50 ? labelWidth : 50;
        
        //self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y , labelWidth + CHATCELL_CONTENT_LARGE_OFFSET_X*2 + BG_TAIL_WIDTH, labelHeight+CHATCELL_CONTENT_LARGE_OFFSET_Y*2+BG_TAIL_HEIGHT );
          self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y , labelWidth + CHATCELL_CONTENT_THIN_OFFSET_X*2 + BG_TAIL_WIDTH, labelHeight+CHATCELL_CONTENT_THIN_OFFSET_Y*2+BG_TAIL_HEIGHT );
    
        
        
        self.lbl_msg.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X+ BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+CHATCELL_CONTENT_THIN_OFFSET_Y, labelWidth, labelHeight);
        self.lbl_msg.hidden = YES;
        
        _lblText.font = [UIFont systemFontOfSize:16.0];
    
        _lblText.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X+ BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+CHATCELL_CONTENT_THIN_OFFSET_Y, labelWidth, labelHeight);
        
        _lblText.backgroundColor = [UIColor clearColor];
        _lblText.textColor = [Colors chatTextColor_L];
        _lblText.textAlignment = NSTextAlignmentLeft;
        _lblText.editable = NO;
        _lblText.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress;
        _lblText.scrollEnabled = NO;
    
        self.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
        
        self.lbl_senttime.frame = CGRectMake(INCOMINGCELL_BG_X +self.iv_bg.frame.size.width +INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X , INCOMINGCELL_BG_Y+self.iv_bg.frame.size.height -INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y- SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
    
        self.headImageView.frame = CGRectMake(INCOMINGCELL_PROFILE_X, INCOMINGCELL_PROFILE_Y, INCOMINGCELL_PROFILE_W, INCOMINGCELL_PROFILE_H);
    }
    
    self.btn_viewbuddy.frame = self.headImageView.frame;
 
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
    singleTap.numberOfTapsRequired = 1;
    [self bringSubviewToFront:_lblText];
    [singleTap release];
    
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
    self.iv_bg = nil;
    self.lbl_name = nil;
    self.lbl_msg = nil;
    self.lbl_senttime = nil;
    
    self.btn_viewbuddy = nil;
    [_lblText release];
//    [self setMsgText:nil];
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}
@end
