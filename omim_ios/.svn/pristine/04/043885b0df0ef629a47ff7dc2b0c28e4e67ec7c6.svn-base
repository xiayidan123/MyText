//
//  LocalPeopleHCell.m
//  omim
//
//  Created by wow on 14-3-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "LocalPeopleHCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Buddy.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "LocationHelper.h"
@implementation LocalPeopleHCell

@synthesize buddy;
@synthesize iconImageView;
@synthesize genderImageView;
@synthesize distance;

- (id)init {
	
    if (self = [super init]) {
		
        self.frame = CGRectMake(0, 0, 80, 100);
		
		[[NSBundle mainBundle] loadNibNamed:@"LocalPeopleHCell" owner:self options:nil];
        [self addSubview:self.view];
	}
	
    return self;
}

- (void)loadView
{
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5.0f;
    
    if (self.buddy.sexFlag == 0) {
        [self.genderImageView setImage:[UIImage imageNamed:MALE_ONLY_IMAGE]];
    } else if (self.buddy.sexFlag == 1){
        [self.genderImageView setImage:[UIImage imageNamed:FEMALE_ONLY_IMAGE]];
    } else if (self.buddy.sexFlag == 2){
        [self.genderImageView setImage:[UIImage imageNamed:FEMALE_ONLY_IMAGE]];
    }
    
    self.buddyName.text = [self.buddy nickName];
    
    self.distance.text = [NSString stringWithFormat:@"%02.2f %@", [[LocationHelper defaultLocaltionHelper] distanceBetweenMyLocationAndPlaceWithLatitude:self.buddy.lastLatitude Longitude:self.buddy.lastLongitude],NSLocalizedString(@"km", nil)];
    
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    if (data)
        self.iconImageView.image = [UIImage imageWithData:data];
    else
    {
        [self.iconImageView setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }
    
    if (self.buddy.needToDownloadThumbnail)
        {
            self.buddy.needToDownloadThumbnail = NO;

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
    [distance release];
    [iconImageView release];
    [genderImageView release];
    [_buddyName release];
    [super dealloc];
}
@end
