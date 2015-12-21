//
//  LocalGroupCell.m
//  omim
//
//  Created by wow on 14-3-12.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "LocalGroupCell.h"
#import <QuartzCore/QuartzCore.h>

#import "Constants.h"
#import "WTHeader.h"

@implementation LocalGroupCell

@synthesize group;
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize statusLabel;
@synthesize memberLabel;

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

- (void)loadView
{
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5.0f;
    
    self.titleLabel.text = self.group.groupNameOriginal;
    self.statusLabel.text = self.group.groupStatus;
    
    self.memberLabel.text = [NSString stringWithFormat:@"群成员 %ld 人", (long)self.group.memberCount];
    
    NSData *data = [AvatarHelper getThumbnailForGroup:self.group.groupID];
    
    if (data)
        self.iconImageView.image = [UIImage imageWithData:data];
    else
    {
        [self.iconImageView setImage:[UIImage imageNamed:DEFAULT_GROUP_AVATAR]];
        
        if (self.group.needToDownloadThumbnail)
        {
            [WowTalkWebServerIF getGroupAvatarThumbnail:self.group.groupID withCallback:@selector(didGetGroupThumbnail:) withObserver:self];
        }
    }
}

- (void)didGetGroupThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForGroup:self.group.groupID];
    if (data)
        self.iconImageView.image = [UIImage imageWithData:data];
}

- (void)dealloc
{
    [group release];
    [iconImageView release];
    [titleLabel release];
    [statusLabel release];
    [memberLabel release];
    [super dealloc];
}
@end
