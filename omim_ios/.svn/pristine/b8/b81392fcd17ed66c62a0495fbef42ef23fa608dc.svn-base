//
//  AddChatMemberCell.m
//  omim
//
//  Created by Harry on 14-2-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "AddChatMemberCell.h"

#import <QuartzCore/QuartzCore.h>

#import "WTHeader.h"
#import "Constants.h"


@implementation AddChatMemberCell

@synthesize buddy;
@synthesize m_checked;
@synthesize selectedImageView;
@synthesize nameLabel;
@synthesize signatureLabel;
@synthesize dividerImageview;

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


- (void)loadContent:(Buddy *)aBuddy
{
    self.buddy = aBuddy;
    
    _headImageView = [[OMHeadImgeView alloc] initWithFrame:CGRectMake(40.0f, 5.0f, 40.0f, 40.0f)];
    _headImageView.buddy = self.buddy;
    
    
    selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 10.0f, 30.0f, 30.0f)];
    [selectedImageView setTag:999];
    
    dividerImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 49.0f, 320.0f, 2.0f)];
    [dividerImageview setImage:[UIImage imageNamed:DIVIDER_IMAGE_320]];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(88.0f, 5.0f, 212.0f, 21.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(88.0f, 28.0f, 212.0f, 18.0f)];
    signatureLabel.font = [UIFont systemFontOfSize:14.0f];
    signatureLabel.backgroundColor = [UIColor clearColor];
    signatureLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.selectedImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.signatureLabel];
    [self.contentView addSubview:self.dividerImageview];
    
    [_headImageView release];
    [selectedImageView release];
    [dividerImageview release];
    [nameLabel release];
    [signatureLabel release];
    
    [self.selectedImageView setImage:[UIImage imageNamed:CONTACT_SELECTED]];
    [self.nameLabel setText:self.buddy.nickName];
    [self.signatureLabel setText:self.buddy.status];
    

    
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    if (data)
        self.headImageView.headImage = [UIImage imageWithData:data];
    else
    {
        if ([self.buddy.buddy_flag isEqualToString:@"2"]) {
            self.headImageView.headImage = [UIImage imageNamed:@"default_avatar_offline_90.png"];
        }
        else
        {
            self.headImageView.headImage = [UIImage imageNamed:@"avatar_84.png"];
        }
    
    }
    
    if (self.buddy.needToDownloadThumbnail){
        [WowTalkWebServerIF getThumbnailForUserID:self.buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
    }
}

- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    if (data)
        self.headImageView.headImage = [UIImage imageWithData:data];
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		self.selectedImageView.image = [UIImage imageNamed:CONTACT_SELECTED];
	}
	else
	{
		self.selectedImageView.image = [UIImage imageNamed:CONTACT_UNSELECTED];
	}
}


@end
