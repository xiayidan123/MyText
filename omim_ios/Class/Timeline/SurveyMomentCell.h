//
//  SurveyMomentCell.h
//  wowtalkbiz
//
//  Created by elvis on 2013/10/02.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceMessagePlayer.h"

// basic tag: above 100;   images tag : above 5000;

#define TAG_BG_CARD         101
#define TAG_BG_CARD1         1011
#define TAG_BG_CARD2         1012
#define TAG_AVATAR          102
#define TAG_LABEL_NAME      103
#define TAG_LABEL_TIME      104
#define TAG_BG_CATEGORY     105
#define TAG_LABEL_CATEGORY  106
#define TAG_IMAGE_CATEGORY  100

#define TAG_MOMENT_AREA     107
#define TAG_BUTTON_AREA     108

#define TAG_COLOR_CATEGORY  109
#define TAG_AVATAR_BUTTON   110

#define TAG_MOMENT_TEXT             111
#define TAG_MOMENT_LOCATION         112
#define TAG_MOMENT_RECORD           113
#define TAG_MOMENT_LOCATION_ICON    114
#define TAG_MOMENT_LOCATION_BUTTON  115

#define TAG_MOMENT_RECORD_ICON      116
#define TAG_MOMENT_RECORD_LABEL     117
#define TAG_MOMENT_RECORD_BUTTON    118

#define TAG_MOMENT_IMAGES           119


#define TAG_BUTTON_LIKE             121
#define TAG_BUTTON_COMMENT          122
#define TAG_BUTTON_SEPARATOR        1220
#define TAG_BUTTON_SEPARATOR_1      1221
#define TAG_BUTTON_RESTRICTION      123
#define TAG_BUTTON_FAVORITE         124

#define TAG_ICON_LIKE               125
#define TAG_ICON_COMMENT            126
#define TAG_ICON_RESTICTION         127
#define TAG_ICON_FAVORITE           128

#define TAG_LABEL_LIKE              129
#define TAG_LABEL_COMMENT           130
#define TAG_LABEL_RESTICTION        131

#define TAG_TABLE_COMMENT           132

#define TAG_LABEL_VOTE_DESC         133
#define TAG_TABLE_VOTE              134


#define TAG_SELECTION_BOX           135


@protocol RTLabelDelegate;

@class Moment;
@class WTFile;

@interface SurveyMomentCell : UITableViewCell<VoiceMessagePlayerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property BOOL hasCommentPart;   // set before setting moment;

@property (nonatomic,retain) Moment* moment;

@property (nonatomic,assign) UIViewController* parent;

@property (nonatomic,retain) NSIndexPath* indexPath;

@property  BOOL isPlaying;
@property (nonatomic,retain) WTFile* voiceclip;

@property BOOL isInSpace;

+(CGFloat)heightForMoment:(Moment*)tmpmoment;
+(CGFloat)heightForMomentWithComment:(Moment*)tmpmoment;

@end
