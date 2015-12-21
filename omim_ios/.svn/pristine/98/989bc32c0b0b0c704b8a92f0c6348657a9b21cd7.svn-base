//
//  OMBuddyDetailActionFootView.m
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailActionFootView.h"


@interface OMBuddyDetailActionFootView ()

@property (retain, nonatomic) IBOutlet UIButton *send_message_button;

@property (retain, nonatomic) IBOutlet UIButton *voice_button;

@property (retain, nonatomic) IBOutlet UIButton *video_button;

@end


@implementation OMBuddyDetailActionFootView

- (void)dealloc {
    [_send_message_button release];
    [_voice_button release];
    [_video_button release];
    [super dealloc];
}



+ (instancetype)buddyDetailActionFootView{
    return [[[NSBundle mainBundle]loadNibNamed:@"OMBuddyDetailActionFootView" owner:self options:nil] lastObject];
}

-(void)awakeFromNib{
    self.send_message_button.adjustsImageWhenHighlighted = NO;
    [self.send_message_button setBackgroundImage:[[UIImage imageNamed:@"btn_bule_light_grey"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [self.send_message_button setBackgroundImage:[[UIImage imageNamed:@"btn_white"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.send_message_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.send_message_button setTitleColor:[UIColor colorWithRed:0.4 green:0.63 blue:0.76 alpha:1] forState:UIControlStateHighlighted];
    
    self.voice_button.adjustsImageWhenHighlighted = NO;
    [self.voice_button setBackgroundImage:[[UIImage imageNamed:@"btn_bule_light_grey"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [self.voice_button setBackgroundImage:[[UIImage imageNamed:@"btn_white"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.voice_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.voice_button setTitleColor:[UIColor colorWithRed:0.4 green:0.63 blue:0.76 alpha:1] forState:UIControlStateHighlighted];
    
    self.video_button.adjustsImageWhenHighlighted = NO;
    [self.video_button setBackgroundImage:[[UIImage imageNamed:@"btn_bule_light_grey"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [self.video_button setBackgroundImage:[[UIImage imageNamed:@"btn_white"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.video_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.video_button setTitleColor:[UIColor colorWithRed:0.4 green:0.63 blue:0.76 alpha:1] forState:UIControlStateHighlighted];
}


#pragma mark - Button Action
- (IBAction)send_message_Action:(UIButton *)sender {
    self.voice_button.selected = NO;
    self.video_button.selected = NO;
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(didClickSendMessageButtonWithFootView:)]){
        [self.delegate didClickSendMessageButtonWithFootView:self];
    }
}

- (IBAction)voice_button_action:(id)sender {
    self.send_message_button.selected = NO;
    self.video_button.selected = NO;
    self.voice_button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(didClickVoiceButtonWithFootView:)]){
        [self.delegate didClickVoiceButtonWithFootView:self];
    }
}

- (IBAction)video_button_action:(id)sender {
    self.send_message_button.selected = NO;
    self.voice_button.selected = NO;
    self.video_button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(didClickVideoButtonWithFootView:)]){
        [self.delegate didClickVideoButtonWithFootView:self];
    }
}


@end
