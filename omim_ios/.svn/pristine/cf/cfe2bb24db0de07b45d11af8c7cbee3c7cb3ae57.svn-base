//
//  LocalPeopleCell.m
//  omim
//
//  Created by wow on 14-3-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "LocalPeopleVCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "LocationHelper.h"

@implementation LocalPeopleVCell
@synthesize iconImageView;
@synthesize genderImageView;
@synthesize nameLabel;
@synthesize statusLabel;
@synthesize ageLabel;
@synthesize distanceLabel;
@synthesize timeLabel;
@synthesize buddy;

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
    [self.distanceLabel setTextAlignment:NSTextAlignmentCenter];
    
    if (self.buddy.sexFlag == 0) {
        [self.genderImageView setImage:[UIImage imageNamed:MALE_AGE_BG_IMAGE]];
    } else if (self.buddy.sexFlag == 1){
        [self.genderImageView setImage:[UIImage imageNamed:FEMALE_AGE_BG_IMAGE]];
    } else if (self.buddy.sexFlag == 2){
        [self.genderImageView setImage:[UIImage imageNamed:FEMALE_AGE_BG_IMAGE]];
    }
    
    //TODO: change here.
    self.nameLabel.text = [self.buddy nickName];
    self.statusLabel.text = [self.buddy status];
    
  //  self.ageLabel.text = [NSString stringWithFormat:@"%d",11];
    
 //   self.distanceLabel.text = [NSString stringWithFormat:@"%d %@",12,@"km"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger diff = interval - self.buddy.lastLoginTimestamp;
    if (diff < 60) {
         self.timeLabel.text = [NSString stringWithFormat:@"%zi %@",diff,NSLocalizedString(@"second", nil)];
    }
    else if (diff > 59 && diff< 3600){
         self.timeLabel.text = [NSString stringWithFormat:@"%zi %@",diff/60,NSLocalizedString(@"minute", nil)];
    }
    else if (diff>3599 && diff < 3600*24){
         self.timeLabel.text = [NSString stringWithFormat:@"%zi %@",diff/3600,NSLocalizedString(@"hour", nil)];
    }
    else if (diff > 3660*24 -1 ){
        self.timeLabel.text = [NSString stringWithFormat:@"%zi %@",diff/(24*3600),NSLocalizedString(@"day", nil)];
    }
    
    // self.timeLabel.text = [NSString stringWithFormat:@"%d %@",13,@"分钟前"];
    self.distanceLabel.text = [NSString stringWithFormat:@"%02.2f %@", [[LocationHelper defaultLocaltionHelper] distanceBetweenMyLocationAndPlaceWithLatitude:self.buddy.lastLatitude Longitude:self.buddy.lastLongitude],NSLocalizedString(@"km", nil)];
    
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    if (data)
        self.iconImageView.image = [UIImage imageWithData:data];
    else{
        [self.iconImageView setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        
    
    }
    if (self.buddy.needToDownloadThumbnail){
            [WowTalkWebServerIF getThumbnailForUserID:self.buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
        }
}

- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    if (data)
        self.iconImageView.image = [UIImage imageWithData:data];
}

- (void)dealloc
{
    [buddy release];
    [iconImageView release];
    [genderImageView release];
    [distanceLabel release];
    [timeLabel release];
    [nameLabel release];
    [statusLabel release];
    [ageLabel release];
    [super dealloc];
}
@end
