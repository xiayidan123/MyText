//
//  VideoMomentCell
//  wowtalkbiz
//
//  Created by elvis on 2013/10/02.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "VideoMomentCell.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "GalleryViewController.h"
#import "AppDelegate.h"

#import "RCLabel.h"
#import "RCViewCell.h"
#import "UITextView+Size.h"
#import "BizMomentDetailViewController.h"
#import "OMBuddySpaceViewController.h"
#import "OMTimelineViewController.h"
#import "MomentPrivacyViewController.h"
#import "OMHeadImgeView.h"
#import <MediaPlayer/MediaPlayer.h>


#define IMAGE_WIDTH  276
//#define IMAGE_HEIGHT  276
#define IMAGE_SPACE  5
#define IMAGE_COUNTER  50
static NSMutableDictionary* dicLoadedWebViewFittingSize;
static CGFloat IMAGE_HEIGHT;
static CGFloat IMAGE_HEIGHT_CURRENT;
@interface VideoMomentCell()
{
    CGFloat height;
    
    BOOL hasVideo;
    BOOL alreadyLiked;
    BOOL alreadyComment;
    
    NSMutableDictionary* dic_cellHeight;
    
    CGFloat commentTableHeight;

    NSString* currentSelectedReviewID;
    
    BOOL hasLikeRow;

    CGFloat infoHeight,MomentHeight, ButtonAreaHeight, MomentTextHeight;
    
    BOOL isMyMoment;
    BOOL hasLocation;
    
    int likeCount;
    int commentCount;
    
    BOOL isFavoriteMoment;
    
     UIImageView* likeIconInCommentTable;
    
    int momentType;
}


@property (nonatomic,retain) NSMutableArray* arr_videos;
@property (nonatomic,retain) NSMutableArray* arr_comments;
@property (nonatomic,retain) NSMutableArray* arr_likedBuddy;

@end

@implementation VideoMomentCell
@synthesize moment = _moment;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // add background card
        IMAGE_HEIGHT = 276;
        IMAGE_HEIGHT_CURRENT =276;
        infoHeight = [self getMomentInfoHeight];
        
        if(nil == dicLoadedWebViewFittingSize) {
            dicLoadedWebViewFittingSize = [[NSMutableDictionary alloc] init];
        }

        UIImageView* bg_card1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 314, 45)];
        bg_card1.tag = TAG_BG_CARD1;
        [bg_card1 setImage:[PublicFunctions strecthableImage:@"timeline_card_bg1.png"]];
        [self.contentView addSubview:bg_card1];
        [bg_card1 release];
        
        UIImageView* bg_card2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 314, 45)];
        bg_card2.tag = TAG_BG_CARD2;
        bg_card2.backgroundColor = [UIColor clearColor];
        [bg_card2 setImage:[PublicFunctions strecthableImage:@"timeline_card_bg2.png"]];
        [self.contentView addSubview:bg_card2];
        [bg_card2 release];
        
        // avatar
        OMHeadImgeView* avatar = [[OMHeadImgeView alloc] initWithFrame:CGRectMake(17, 12, 40, 40)];
        avatar.layer.masksToBounds = YES;
        avatar.buddy = self.moment.owner;
        avatar.tag = TAG_AVATAR;
        avatar.headImage = [PublicFunctions strecthableImage:DEFAULT_AVATAR];
        [self.contentView addSubview:avatar];
        [avatar release];
        
        //avatar button
        UIButton* btn_avatar = [[UIButton alloc] initWithFrame:avatar.frame];
        btn_avatar.tag = TAG_AVATAR_BUTTON;
        btn_avatar.backgroundColor = [UIColor clearColor];
        [btn_avatar addTarget:self action:@selector(viewUserMoments) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_avatar];
        [btn_avatar release];
        
        //name
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(67, 14, 120, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = TAG_LABEL_NAME;
        label.font = [UIFont systemFontOfSize:16];
        label.minimumScaleFactor = 7;
        label.adjustsFontSizeToFitWidth = TRUE;
        label.textColor = [Colors blueColor1];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        [label release];
        
        // time
        UILabel* timelabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 35, 90, 10)];
        timelabel.backgroundColor = [UIColor clearColor];
        timelabel.tag = TAG_LABEL_TIME;
        timelabel.font =  [UIFont systemFontOfSize:12];
        timelabel.minimumScaleFactor = 7;
        timelabel.adjustsFontSizeToFitWidth = TRUE;
        timelabel.textColor = [Colors grayColor7];
        timelabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timelabel];
        [timelabel release];
        
        // restriction area
        UIImageView* restrictionicons = [[UIImageView alloc] initWithFrame:CGRectMake(160, 35, 10, 10)];
        [restrictionicons setImage:[UIImage imageNamed:@"timeline_public.png"]];
        restrictionicons.tag = TAG_ICON_RESTICTION;
        //[self.contentView addSubview:restrictionicons];
        [restrictionicons release];
        
        UILabel* label_restrcition = [[UILabel alloc] initWithFrame:CGRectMake(172, 35, 20, 10)];
        label_restrcition.tag = TAG_LABEL_RESTICTION;
        label_restrcition.font =  [UIFont systemFontOfSize:10];
        label_restrcition.backgroundColor = [UIColor clearColor];
        label_restrcition.textColor = [Colors wowtalkbiz_inactive_text_gray];
        label_restrcition.textAlignment = NSTextAlignmentLeft;
        //[self.contentView addSubview:label_restrcition];
        [label_restrcition release];
        
        UIButton* btn_restriction = [[UIButton alloc] initWithFrame:CGRectMake(160, 35, 32, 15)];
        btn_restriction.tag = TAG_BUTTON_RESTRICTION;
        btn_restriction.backgroundColor = [UIColor clearColor];
        [btn_restriction addTarget:self action:@selector(checkRestriction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_restriction];
        [btn_restriction release];
        
        
        
           
        // category label
        UILabel* category_label = [[UILabel alloc] initWithFrame:CGRectMake(243, 17, 70,20)];
        //category_label.backgroundColor = [Colors wowtalkbiz_comment_section_gray];
        category_label.tag = TAG_LABEL_CATEGORY;
        category_label.font = [UIFont systemFontOfSize:11];
        category_label.minimumScaleFactor = 7;
        category_label.adjustsFontSizeToFitWidth = TRUE;
        category_label.textColor = [Colors wowtalkbiz_inactive_text_gray];
        category_label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:category_label];
        [category_label release];
        
        //share_point imageView
        UIImageView *share_point_imageView = [[UIImageView alloc]init];
        share_point_imageView.frame = CGRectMake(250, 25, 5, 5);
        share_point_imageView.tag = TAG_IMAGE_CATEGORY;
        //share_point_imageView.image = [UIImage imageNamed:@"share_point_class.png"];
        [self.contentView addSubview:share_point_imageView];
        [share_point_imageView release];
        
        
        
        
        //uiview color bar
        UIView* barview = [[UIView alloc] initWithFrame:CGRectMake(313, 17, 3, 20)];
        barview.backgroundColor = [Colors wowtalkbiz_blue];
        barview.tag = TAG_COLOR_CATEGORY;
        //[self.contentView addSubview:barview];
        [barview release];
        
        
        
        
        
        
        UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        [selectedBackgroundView setBackgroundColor:[Colors wowtalkbiz_searchbar_bg]]; // set color here
        [self setSelectedBackgroundView:selectedBackgroundView];
        

        // moment text
        UITextView* momenttext = [[UITextView alloc] initWithFrame:CGRectMake(11, 60, 291, 20)];
        momenttext.tag = TAG_MOMENT_TEXT;
        //momenttext.contentInset = UIEdgeInsetsMake(-8,-4,0,0);
        momenttext.font =  [UIFont systemFontOfSize:16];
        momenttext.backgroundColor = [UIColor clearColor];
        momenttext.textColor = [UIColor blackColor];
        momenttext.textAlignment = NSTextAlignmentLeft;
        //momenttext.editable = NO;
        momenttext.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
        momenttext.scrollEnabled=NO;
        [self.contentView addSubview:momenttext];
        
        
        //location icon
        UIImageView* iv_location = [[UIImageView alloc] initWithFrame:CGRectMake(17, momenttext.frame.size.height + momenttext.frame.origin.y , 16, 16)];
        [iv_location setImage:[UIImage imageNamed:@"timeline_location_a.png"]];
        iv_location.tag = TAG_MOMENT_LOCATION_ICON;
        [self.contentView addSubview:iv_location];
        [iv_location release];
        
        // location text
        UILabel* lbl_location = [[UILabel alloc] initWithFrame:CGRectMake(35, momenttext.frame.size.height + momenttext.frame.origin.y , 265, 20)];
        lbl_location.tag = TAG_MOMENT_LOCATION;
        lbl_location.font =  [UIFont systemFontOfSize:13];
        lbl_location.backgroundColor = [UIColor clearColor];
        lbl_location.textColor = [Colors wowtalkbiz_blue];
        lbl_location.minimumScaleFactor = 9;
        lbl_location.textAlignment = NSTextAlignmentLeft;
        lbl_location.adjustsFontSizeToFitWidth = TRUE;
        [self.contentView addSubview:lbl_location];
        [lbl_location release];
        
        //location button
        UIButton* btn_viewlocation = [[UIButton alloc] initWithFrame:CGRectMake(35, momenttext.frame.size.height + momenttext.frame.origin.y , 265, 20)];
        [btn_viewlocation setBackgroundColor:[UIColor clearColor]];
        [btn_viewlocation addTarget:self action:@selector(viewLocationInMapApp:) forControlEvents:UIControlEventTouchUpInside];
        btn_viewlocation.tag = TAG_MOMENT_LOCATION_BUTTON;
        [self.contentView addSubview:btn_viewlocation];
        [btn_viewlocation release];
        
        
        // photos
        UIScrollView* sv_images = [[UIScrollView alloc] initWithFrame:CGRectMake(17, 10, 286, 276)];
        sv_images.scrollsToTop = FALSE;
        sv_images.tag = TAG_MOMENT_IMAGES;
        sv_images.pagingEnabled = YES;
        [self.contentView addSubview:sv_images];
        [sv_images release];
        
        //like button area
        
        UILabel* label_like = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 20, 16)];
        label_like.tag = TAG_LABEL_LIKE;
        label_like.font = [UIFont systemFontOfSize:12];
        label_like.backgroundColor = [UIColor clearColor];
        label_like.textColor = [Colors wowtalkbiz_inactive_text_gray];
        label_like.textAlignment = NSTextAlignmentLeft;
        //[self.contentView addSubview:label_like];
        [label_like release];
        
        
        //  点赞的button
        
        UIButton* btn_like = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 140, 35)];
        [btn_like setImage:[UIImage imageNamed:@"timeline_like.png"] forState:UIControlStateNormal];
        //[btn_like setTitle:NSLocalizedString(@"Like", nil) forState:UIControlStateNormal];
        [btn_like setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
        [btn_like.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn_like setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-5)];
        btn_like.tag = TAG_BUTTON_LIKE;
        btn_like.backgroundColor = [UIColor clearColor];
        [btn_like addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_like];
        [btn_like release];

        
//        
       UILabel* label_comment = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 20, 16)];
       label_comment.tag = TAG_LABEL_COMMENT;
       label_comment.font =  [UIFont systemFontOfSize:12];
       label_comment.backgroundColor = [UIColor clearColor];
       label_comment.textColor = [Colors wowtalkbiz_inactive_text_gray];
       label_comment.textAlignment = NSTextAlignmentLeft;
       //[self.contentView addSubview:label_comment];
       [label_comment release];
        
        UIButton* btn_comment = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 18)];
        [btn_comment setImage:[UIImage imageNamed:@"timeline_comment.png"] forState:UIControlStateNormal];
        //[btn_comment setTitle:[NSString stringWithFormat:@"%d",commentCount] forState:UIControlStateNormal];
        //[btn_comment setTitle: NSLocalizedString(@"Comment", nil) forState:UIControlStateNormal];
       [btn_comment setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
        [btn_comment.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn_comment setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-5)];
        btn_comment.tag = TAG_BUTTON_COMMENT;
        btn_comment.backgroundColor = [UIColor clearColor];
        [btn_comment addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_comment];
        [btn_comment release];
        

        
        // comment table
        UITableView* tb_comment = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 306, 100) style:UITableViewStylePlain];
        tb_comment.tag = TAG_TABLE_COMMENT;
        tb_comment.scrollEnabled = FALSE;
        
        [self.contentView addSubview:tb_comment];
        [tb_comment release];
        
        
        [self.contentView setBackgroundColor:[Colors wowtalkbiz_background_gray]];
        
    }
    
    
    return self;
}

-(void) openDetail{
    if (![self.parent isKindOfClass:[BizMomentDetailViewController class]]) {
        BizMomentDetailViewController* bmdv = [[BizMomentDetailViewController alloc] init];
        bmdv.moment = self.moment;
        [self.parent.navigationController pushViewController:bmdv animated:TRUE];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

-(Moment *)moment{
    return _moment;
}

-(void)setMoment:(Moment *)moment{
    if (_moment == moment) {
        return;
    }
    //    [_moment release];
    _moment = moment;
    [_moment retain];
    momentType = moment.momentType;
    isFavoriteMoment = _moment.isFavorite;
    MomentHeight = 0;
    [self analyzeMoment];
    [self assignMomentMeta];
    [self buildRestrictionArea];
    [self buildMomentArea];
    [self buildLikeAndCommentArea];
    int currentHeight=MomentHeight;
    
    
    
    [self buildButtonArea];
    [self buildCommentArea];
    
    
    
    UIImageView* bg_card1 = (UIImageView*)[self.contentView viewWithTag:TAG_BG_CARD1];
    [bg_card1 setFrame:CGRectMake(0, 0, 320 , currentHeight)];
    UIImageView* bg_card2 = (UIImageView*)[self.contentView viewWithTag:TAG_BG_CARD2];
    
    [bg_card2 setFrame:CGRectMake(0, currentHeight, 320 , MomentHeight-currentHeight)];
    bg_card2.hidden=FALSE;
    UIImage* image1 =[PublicFunctions strecthableImage:@"timeline_card_bg1.png"];
    [bg_card1 setImage:image1];
    
    
    
    
}

-(void)analyzeMoment{
    hasVideo = FALSE;
    
    if (_moment.multimedias == nil || [_moment.multimedias count] == 0) {
        hasVideo = FALSE;
    }
    else{
        
        NSMutableArray* arrays = [[NSMutableArray alloc] init] ;
        self.arr_videos = arrays;
        [arrays release];
        
        for (WTFile* file in _moment.multimedias) {
            if ([file.ext isEqualToString:@"mp4"] || [file.ext isEqualToString:@"mov"]) {
                hasVideo = TRUE;
                [self.arr_videos addObject:file];
            }
        }
    }
    
    Buddy* buddy = _moment.owner;
    if ([buddy.userID isEqualToString:[WTUserDefaults getUid]]) {
        isMyMoment = TRUE;
    }
    else
        isMyMoment = FALSE;
    
    MomentTextHeight = [VideoMomentCell getMomentTextHeight:_moment];
    
    if (![NSString isEmptyString:_moment.placename]) {
        hasLocation = TRUE;
    }
    else
        hasLocation = FALSE;
    
    alreadyLiked = FALSE;
    alreadyComment = NO;
    likeCount = 0;
    commentCount = 0;
    
    for (Review* review in self.moment.reviews) {
        if (review.type == REVIEW_TYPE_LIKE) {
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]]) {
                alreadyLiked = TRUE;
            }
            likeCount ++;
        }
        else {
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]] && review.type == REVIEW_TYPE_TEXT) {
                alreadyComment = TRUE;
            }
            commentCount ++;
        }
        
    }
}


-(void)analyzeComment{
    
    if (self.arr_comments== Nil) {  
        self.arr_comments = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.arr_comments removeAllObjects];
    
    if (self.arr_likedBuddy== Nil) {
        self.arr_likedBuddy = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.arr_likedBuddy removeAllObjects];
    
    for (Review* review in self.moment.reviews) {
        if (review.type == REVIEW_TYPE_LIKE) {
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]]) {
                alreadyLiked = TRUE;
            }
            [self.arr_likedBuddy addObject:review];
        }
        else if (review.type == REVIEW_TYPE_TEXT){
            [self.arr_comments  addObject:review];
        }
    }
    
    if (dic_cellHeight == Nil) {
        dic_cellHeight = [[NSMutableDictionary alloc] init];
    }
    else{
        [dic_cellHeight removeAllObjects];
    }
    
    int i = 0;
    
    for (Review* review in self.arr_comments) {
        
        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(0,0,320 - 30- 10,100)];
        
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[Review styledReview:review]];
        
        tempLabel.componentsAndPlainText = componentsDS;
        
        CGSize optimalSize = [tempLabel optimumSize];
        [dic_cellHeight setObject:[NSNumber numberWithFloat:optimalSize.height +7] forKey:[NSString stringWithFormat:@"%d",i++]];
        [tempLabel release];
    }
    
    
    // Comment table height;
    commentTableHeight = 0;
    
    for (int i = 0; i< [self.arr_comments count]; i++) {
        commentTableHeight += [[dic_cellHeight objectForKey:[NSString stringWithFormat:@"%d",i]] integerValue];
    }
    
    commentTableHeight += 35;
    hasLikeRow = TRUE;
    
    if ([self.arr_comments count] == 0 &&[self.arr_likedBuddy count] == 0) {
        hasLikeRow = FALSE;
        commentTableHeight -=35 ;
    }
    
    
}

// put moment data into ui.
-(void)assignMomentMeta{
    
    OMHeadImgeView* avatar = (OMHeadImgeView*)[self.contentView viewWithTag:TAG_AVATAR];
    UILabel* name = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_NAME];
    UILabel* time = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_TIME];
    UILabel* category = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_CATEGORY];
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:TAG_IMAGE_CATEGORY];
    //UIView* bar_view = (UIView*)[self.contentView viewWithTag:TAG_COLOR_CATEGORY];
    //UIButton* btn_avatar = (UIButton*)[self.contentView viewWithTag:TAG_AVATAR_BUTTON];
    
    // avatar
    Buddy* buddy = _moment.owner;
    avatar.buddy = _moment.owner;
    NSData* data = [AvatarHelper getThumbnailForUser:buddy.userID];
    if (data) {
        avatar.headImage = [UIImage imageWithData:data];
//        [avatar setImage:[UIImage imageWithData:data]];
    }
    else{
        avatar.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
//        [avatar setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }
    
    Buddy* currentbuddy = [Database buddyWithUserID:buddy.userID];
    if (currentbuddy.needToDownloadThumbnail){
        [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:nil withObserver:nil];
    }
    
    // name
    [name setText:buddy.nickName];
    
    // time
    [time setText:[TimeHelper timestamp2date:_moment.timestamp]];
    
    //category
//    switch (self.moment.momentType) {
//        case 0:
//            category.text = NSLocalizedString(@"Notice", Nil);
//            //bar_view.backgroundColor = [Colors wowtalkbiz_blue];
//            break;
//        case 1:
//            category.text = NSLocalizedString(@"Q&A", Nil);
//           // bar_view.backgroundColor = [Colors wowtalkbiz_orange];
//            break;
//        case 2:
//            category.text = NSLocalizedString(@"Study", Nil);
//            //bar_view.backgroundColor = [Colors wowtalkbiz_red];
//            break;
//        case 5:
//            category.text = NSLocalizedString(@"Life", Nil);
//            //bar_view.backgroundColor = [UIColor cyanColor];
//            break;
//        case 6:
//            category.text = NSLocalizedString(@"Video", Nil);
//            //bar_view.backgroundColor = [Colors wowtalkbiz_green];
//            break;
//        default:
//            break;
//    }
    
    switch (self.moment.momentType) {
        case 0:
            category.text = NSLocalizedString(@"Notice", Nil);
            imageView.image = [UIImage imageNamed:@"icon_notice_number.png"];
            break;
        case 1:
            category.text = NSLocalizedString(@"Q&A", Nil);
            imageView.image = [UIImage imageNamed:@"share_point_question.png"];
            break;
        case 2:
            category.text = NSLocalizedString(@"Study", Nil);
            imageView.image = [UIImage imageNamed:@"messages_icon_new_voice_message .png"];
            break;
        case 5:
            category.text = NSLocalizedString(@"Life", Nil);
            imageView.image = [UIImage imageNamed:@"share_point_class.png"];
            break;
        case 6:
            category.text = NSLocalizedString(@"Video", Nil);
            imageView.image = [UIImage imageNamed:@"share_point_vote.png"];
            break;
        default:
            break;
            
    }
    
    
    
    /*
     UIImageView* favicon = (UIImageView*)[self.contentView viewWithTag:TAG_ICON_FAVORITE];
     
     if (isFavoriteMoment) {
     [favicon setImage:[UIImage imageNamed:@"timeline_favorite_a.png"]];
     }
     else{
     [favicon setImage:[UIImage imageNamed:@"timeline_favorite.png"]];
     }
     
     */
    
    
}

-(void)buildMomentArea{
    
    // text
    //UIWebView* momenttext = (UIWebView*)[self.contentView viewWithTag:TAG_MOMENT_TEXT];
    UITextView* momenttext = (UITextView*)[self.contentView viewWithTag:TAG_MOMENT_TEXT];
    if (MomentTextHeight > 0) {
        //working around for ios7 bug
        if (IS_IOS7 && momenttext!=nil) {
            [momenttext removeFromSuperview];
            [momenttext release];
            momenttext = [[UITextView alloc] initWithFrame:CGRectMake(11, 60, 291, 20)];
            momenttext.tag = TAG_MOMENT_TEXT;
            //momenttext.contentInset = UIEdgeInsetsMake(-8,-4,0,0);
            momenttext.font =  [UIFont systemFontOfSize:16];
            momenttext.backgroundColor = [UIColor clearColor];
            momenttext.textColor = [UIColor blackColor];
            momenttext.textAlignment = NSTextAlignmentLeft;
            momenttext.editable = NO;
            momenttext.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
            momenttext.scrollEnabled=NO;
            [self.contentView addSubview:momenttext];
        }
        //end of working around for ios7 bug
        //momenttext.delegate = self;
        
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDetail)];
        [gr setNumberOfTapsRequired:1];
        [momenttext addGestureRecognizer:gr];
        
        momenttext.hidden=FALSE;
        
        [momenttext setFrame:CGRectMake(11, infoHeight, 291, MomentTextHeight)];
        if (IS_IOS7 || IS_IOS8) {
            momenttext.bounds=momenttext.frame;
        }
        
        //        [momenttext setFrame:CGRectMake(11, infoHeight, 286, MomentTextHeight)];
        
        
        
        NSString* strMoment = _moment.text?_moment.text:@"";

        
        [momenttext setText:strMoment];
        
        [momenttext sizeToFit];
        [momenttext layoutIfNeeded];
        
        if (hasLocation || hasVideo) {
            MomentHeight += 10;
        }
    } else {
        momenttext.hidden=TRUE;
    }
    
    
    MomentHeight += MomentTextHeight + infoHeight;
    
    // location
    UIImageView* iv_location = (UIImageView*)[self.contentView viewWithTag:TAG_MOMENT_LOCATION_ICON];
    UILabel* lbl_location = (UILabel*)[self.contentView viewWithTag:TAG_MOMENT_LOCATION];
    UIButton* btn_viewlocation = (UIButton*)[self.contentView viewWithTag:TAG_MOMENT_LOCATION_BUTTON];
    
    if (hasLocation) {
        [iv_location setHidden:FALSE];
        [lbl_location setHidden:FALSE];
        [btn_viewlocation setHidden:FALSE];
        
        
        int location_height=[self getMomentLocationHeight];
        
        [iv_location setFrame:CGRectMake(17, MomentHeight , 16 , location_height)];
        
        lbl_location.text = self.moment.placename;
        [lbl_location setFrame:CGRectMake(35, MomentHeight , 265, location_height)];
        
        [btn_viewlocation setFrame:CGRectMake(17, MomentHeight , 280, location_height)];
        
        MomentHeight += location_height+10;
    }
    else{
        [iv_location setHidden:TRUE];
        [lbl_location setHidden:TRUE];
        [btn_viewlocation setHidden:TRUE];
    }
    
    
    // pictures
    UIScrollView* sv_images = (UIScrollView*)[self.contentView viewWithTag:TAG_MOMENT_IMAGES];
    if (hasVideo) {
        [sv_images setHidden:false];
        
        for(UIView* subview in [sv_images subviews]){
            [subview removeFromSuperview];
        }
        int x = 0;
        int y = 0;
        
        for (int i = 0; i< [self.arr_videos count]; i++) {
            
            WTFile* file = [self.arr_videos objectAtIndex:i];
            
            x = i/IMAGE_COUNTER;   //
            y = i%IMAGE_COUNTER;
            
            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_WIDTH*y, x*(IMAGE_HEIGHT+IMAGE_SPACE), IMAGE_WIDTH, IMAGE_HEIGHT)];

            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.clipsToBounds = YES;
            NSData* data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            if (data) {
                [imageview setImage:[UIImage imageWithData:data]];
            }
            else{
                [imageview setImage:[UIImage imageNamed:@"default_pic.png"]];
                [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000+i forMoment:self.moment.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
            };
            imageview.tag = 5000 + i;
            
            UIButton* btn = [[UIButton alloc] initWithFrame:imageview.frame];
            btn.tag = i;
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(watchTheMovie:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[PublicFunctions imageNamedWithNoPngExtension:PLAY_VIDEO] forState:UIControlStateNormal];

            [sv_images addSubview:imageview];
            [sv_images addSubview:btn];
            
            [imageview release];
            [btn release];
        }
        
        
        int imagesHeight =[self getMomentPicturesHeight];
        int imagecount = [self.arr_videos count];
        if (imagecount>IMAGE_COUNTER) {
            
            x = (imagecount-1)/IMAGE_COUNTER;
            
            [sv_images setContentSize:CGSizeMake((IMAGE_WIDTH+IMAGE_SPACE)*2 + IMAGE_WIDTH, imagesHeight)];
            [sv_images setFrame:CGRectMake(17, MomentHeight , 286 ,   imagesHeight)];
        }
        else{
            y = (imagecount -1)%IMAGE_COUNTER;
            
            [sv_images setContentSize:CGSizeMake((IMAGE_WIDTH+IMAGE_SPACE)*y + IMAGE_WIDTH, imagesHeight)];
            [sv_images setFrame:CGRectMake(17, MomentHeight , 286 , imagesHeight)];
            
        }
        MomentHeight += imagesHeight +10;
    }
    else{
        sv_images.hidden = TRUE;
    }
}



-(void)buildRestrictionArea{
    UIImageView* restrictionicons = (UIImageView*)[self.contentView viewWithTag:TAG_ICON_RESTICTION];
    UILabel* label_restrcition = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_RESTICTION];
    UIButton* btn_restriction = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_RESTRICTION];
    
    if (isMyMoment) {
        [restrictionicons setHidden:FALSE];
        [label_restrcition setHidden:FALSE];
        [btn_restriction setHidden:FALSE];
        
        if (![_moment isMomentLimited]) {
            [restrictionicons setImage:[UIImage imageNamed:@"timeline_public.png"]];
            label_restrcition.text = NSLocalizedString(@"Public", nil);
        }
        else{
            [restrictionicons setImage:[UIImage imageNamed:@"timeline_limited.png"]];
            label_restrcition.text = NSLocalizedString(@"Limited", nil);
        }
        CGFloat width = [UILabel labelWidth:label_restrcition.text FontType:10 withInMaxWidth:100];
        [label_restrcition setFrame:CGRectMake(label_restrcition.frame.origin.x , label_restrcition.frame.origin.y, width+4 , label_restrcition.frame.size.height)];
        [btn_restriction setFrame:CGRectMake(btn_restriction.frame.origin.x, btn_restriction.frame.origin.y, width+25 , btn_restriction.frame.size.height)];
        
    }
    else{
        [restrictionicons setHidden:TRUE];
        [label_restrcition setHidden:TRUE];
        [btn_restriction setHidden:TRUE];
    }
}

-(void)buildLikeAndCommentArea{
    UILabel* label_like = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_LIKE];
    UILabel* label_comment = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_COMMENT];
    
    CGFloat startx=label_like.frame.origin.x;
    CGFloat starty=MomentHeight;
    
    label_like.text = [NSString stringWithFormat:@"%@ %d %@  • ",NSLocalizedString(@"Like", nil),likeCount,NSLocalizedString(@"countUnit", nil)];
    CGFloat width = [UILabel labelWidth:label_like.text FontType:12 withInMaxWidth:100];
    [label_like setFrame:CGRectMake(startx, starty, width , [self getMomentLikeAndCommentAreaHeight])];
    startx+=width+5;
    
    if(self.moment.momentType==1){
        label_comment.text = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(@"AnswerMoment", nil),commentCount,NSLocalizedString(@"countUnit", nil)];
    }
    else{
        label_comment.text = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(@"Comment", nil),commentCount,NSLocalizedString(@"countUnit", nil)];
    }
    width = [UILabel labelWidth:label_comment.text FontType:12 withInMaxWidth:100];
    [label_comment setFrame:CGRectMake(startx, starty, width , [self getMomentLikeAndCommentAreaHeight])];
    
    MomentHeight += [self getMomentLikeAndCommentAreaHeight] + 13;
    
}

-(void)resetLikeAndCommentArea{
    UILabel* label_like = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_LIKE];
    UILabel* label_comment = (UILabel*)[self.contentView viewWithTag:TAG_LABEL_COMMENT];
    UIButton* btn_like = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_LIKE];
    
    CGFloat startx=label_like.frame.origin.x;
    CGFloat starty=label_like.frame.origin.y;
    
    label_like.text = [NSString stringWithFormat:@"%d %@",likeCount,NSLocalizedString(@"Like", nil)];
    CGFloat width = [UILabel labelWidth:label_like.text FontType:12 withInMaxWidth:100];
    [label_like setFrame:CGRectMake(startx, starty, width , [self getMomentLikeAndCommentAreaHeight])];
    startx+=width+5;
    
    
    
    
    if(self.moment.momentType==1){
        label_comment.text = [NSString stringWithFormat:@"%d %@",commentCount,NSLocalizedString(@"AnswerMoment", nil)];
    }
    else{
        label_comment.text = [NSString stringWithFormat:@"%d %@",commentCount,NSLocalizedString(@"Comment", nil)];
    }
    width = [UILabel labelWidth:label_comment.text FontType:12 withInMaxWidth:100];
    [label_comment setFrame:CGRectMake(startx, starty, width , [self getMomentLikeAndCommentAreaHeight])];
    
    
    if (alreadyLiked) {
        [btn_like setImage:[UIImage imageNamed:@"timeline_like_a.png"] forState:UIControlStateNormal];
        [btn_like setTitleColor:[Colors wowtalkbiz_blue] forState:UIControlStateNormal];
    }
    else{
        [btn_like setImage:[UIImage imageNamed:@"timeline_like.png"] forState:UIControlStateNormal];
        [btn_like setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
    }
    
    
}



-(void)buildButtonArea{
    
    UIButton* btn_like = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_LIKE];
    [btn_like setTitle:[NSString stringWithFormat:@"%d",likeCount] forState:UIControlStateNormal];
    UIButton* btn_comment = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_COMMENT];
    [btn_comment setTitle:[NSString stringWithFormat:@"%d",commentCount] forState:UIControlStateNormal];
    UIButton* btn_fav = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_FAVORITE];
    UILabel* lbl_separator = (UILabel*)[self.contentView viewWithTag:TAG_BUTTON_SEPARATOR];
    
    
    
    if(self.hasCommentPart) {
        btn_like.hidden=TRUE;
        btn_comment.hidden=TRUE;
        lbl_separator.hidden=TRUE;
        btn_fav.hidden =TRUE;
        return;
    }

    
    if (self.moment.momentType == 1) {
        [btn_comment setTitle:NSLocalizedString(@"AnswerMoment", Nil) forState:UIControlStateNormal];
    }
    else{
        [btn_comment setTitle: NSLocalizedString(@"Comment", nil) forState:UIControlStateNormal];
    }
    
        
    if (alreadyLiked) {
        [btn_like setImage:[UIImage imageNamed:@"timeline_like_a.png"] forState:UIControlStateNormal];
        [btn_like setTitleColor:[Colors wowtalkbiz_blue] forState:UIControlStateNormal];
    }
    else{
        [btn_like setImage:[UIImage imageNamed:@"timeline_like.png"] forState:UIControlStateNormal];
        [btn_like setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
    }
    
    if (alreadyComment) {
        [btn_comment setImage:[UIImage imageNamed:@"timeline_comment_a.png"] forState:UIControlStateNormal];
        [btn_comment setTitleColor:[Colors wowtalkbiz_blue] forState:UIControlStateNormal];
    }
    else{
        [btn_comment setImage:[UIImage imageNamed:@"timeline_comment.png"] forState:UIControlStateNormal];
        [btn_comment setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
    }
    
    if (isFavoriteMoment) {
        [btn_fav setImage:[UIImage imageNamed:@"timeline_favourite_14_a.png"]  forState:UIControlStateNormal];
        [btn_fav setTitleColor:[Colors wowtalkbiz_blue] forState:UIControlStateNormal];
    }
    else{
        [btn_fav setImage:[UIImage imageNamed:@"timeline_favourite_14.png"]  forState:UIControlStateNormal];
        [btn_fav setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
    }
    
    
    int starty = MomentHeight;
    [btn_like setFrame:CGRectMake(btn_like.frame.origin.x, starty, btn_like.frame.size.width, [self getMomentLikeAndCommentButtonHeight])];
    
    [lbl_separator setFrame:CGRectMake(160, starty+15, lbl_separator.frame.size.width, lbl_separator.frame.size.height)];
    
    [btn_comment setFrame:CGRectMake(btn_comment.frame.origin.x, starty, btn_comment.frame.size.width, [self getMomentLikeAndCommentButtonHeight])];
    
    
    [btn_fav setFrame:CGRectMake(btn_fav.frame.origin.x, starty, btn_fav.frame.size.width, [self getMomentLikeAndCommentButtonHeight])];
    
    
    
    
    MomentHeight += [self getMomentLikeAndCommentButtonHeight]+5;
}



-(void)buildCommentArea{
    UITableView* tb_comment = (UITableView*)[self.contentView viewWithTag:TAG_TABLE_COMMENT];
    if (self.hasCommentPart ) {
        [self analyzeComment];
        tb_comment.delegate = self;
        tb_comment.dataSource = self;
        [tb_comment setFrame:CGRectMake(7, MomentHeight+5, tb_comment.frame.size.width , commentTableHeight)];  //add here.
        [tb_comment setBackgroundColor:[UIColor clearColor]];
        tb_comment.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [tb_comment addGestureRecognizer:longPressRecognizer];
        [longPressRecognizer release];

        
        [tb_comment reloadData];
        MomentHeight += commentTableHeight;
    }
    else{
        tb_comment.hidden = TRUE;
    }
    
}

#pragma mark -- comment table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (hasLikeRow) {
        return 1;
    }
    else{
        if (self.moment.momentType == 1) {
            if ([self.arr_comments count]>0) {
                return 1;
            }
        }
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (hasLikeRow) {
        return [self.arr_comments count] + 1;
    }
    else{
        if (self.moment.momentType == 1) {
            return [self.arr_comments count];
        }
        return 0;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (hasLikeRow) {
        if (indexPath.row == 0)
            return;
        else{
             [self replyToComment:indexPath.row - 1];
        }
    }
    else{
          [self replyToComment:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (hasLikeRow) {
        if (indexPath.row == 0) {
            return 35;
        }
        else{
            return [[dic_cellHeight objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row -1]] integerValue];
        }
    }
    else{
        if (self.moment.momentType == 1) {

            return [[dic_cellHeight objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue];

        }
        return 0;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (hasLikeRow) {
        if (indexPath.row == 0) {
            static NSString* cellIdentifier = @"headcell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            for (UIView* subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
            [cell.contentView addSubview:[self customHeaderViewForCommentTable]];
            return cell;
            
        }
        else{
            static NSString *reviewCellIdentifier = @"CommentCell";
            RCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCellIdentifier];
            if (cell == nil) {
                cell = [[[RCViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCellIdentifier] autorelease];
                [cell.contentView setBackgroundColor:[Colors wowtalkbiz_comment_section_gray]];
            }
            
            Review* review = [self.arr_comments objectAtIndex:indexPath.row -1];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[Review styledReview:review]];
            cell.rtLabel.componentsAndPlainText = componentsDS;
            
            [cell.rtLabel setDelegate:self];
            return cell;
        }

    }
    else{
        static NSString *reviewCellIdentifier = @"CommentCell";
        RCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCellIdentifier];
        if (cell == nil) {
            cell = [[[RCViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCellIdentifier] autorelease];
            [cell.contentView setBackgroundColor:[Colors wowtalkbiz_comment_section_gray]];
        }
        
        Review* review = [self.arr_comments objectAtIndex:indexPath.row];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[Review styledReview:review]];
        cell.rtLabel.componentsAndPlainText = componentsDS;
        
        [cell.rtLabel setDelegate:self];
        return cell;
    }
    
    return nil;

}


-(UIScrollView*)customHeaderViewForCommentTable
{
    UIScrollView* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 306, 35)];
    scrollview.scrollsToTop = FALSE;
    
    scrollview.backgroundColor = [Colors wowtalkbiz_comment_section_gray];
    
    likeIconInCommentTable = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
    [likeIconInCommentTable setContentMode:UIViewContentModeCenter];

    if (alreadyLiked) {
        likeIconInCommentTable.image = [UIImage imageNamed:@"timeline_like_a.png"];
    }
    else
        likeIconInCommentTable.image = [UIImage imageNamed:@"timeline_like.png"];
    
    [scrollview addSubview:likeIconInCommentTable];
    [likeIconInCommentTable release];
    
    RCLabel* label = [[RCLabel alloc] initWithFrame:CGRectMake(28, 8, 271, 22)];
    
    NSString* str = [self likedString];
    CGFloat strwidth = [UILabel labelWidth:str FontType:15 withInMaxWidth:3000];
    if (strwidth > 271) {
        label.frame=CGRectMake(28, 8, strwidth, 22);
    }
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[self styledLikeComment]];
    label.componentsAndPlainText = componentsDS;
    [label setDelegate:self];
    [scrollview addSubview:label];
    [label release];
    
    [scrollview setContentSize:CGSizeMake(30+strwidth, 35)];
    
    UIView* bar = [[UIView alloc] initWithFrame:CGRectMake(10, 30 , 286, 1)];
    bar.backgroundColor = [Colors wowtalkbiz_background_gray];
    [scrollview addSubview:bar];
    [bar release];
    
    if (strwidth + 30 > 306) {
        [scrollview setScrollEnabled:TRUE];
        scrollview.showsHorizontalScrollIndicator = TRUE;
        [bar setFrame:CGRectMake(10, 30 , strwidth + 20, 1)];
    }
    else{
        scrollview.scrollEnabled =FALSE;
        [bar setFrame:CGRectMake(10, 30 , 286, 1)];
    }
    
    if ([self.arr_comments count] == 0) {
        [bar removeFromSuperview];
    }
    
    return [scrollview autorelease];
    
}


#pragma mark -- comment

-(void)replyToComment:(int)index
{
    Review* review = [self.arr_comments objectAtIndex:index];
    [(BizMomentDetailViewController*)self.parent tryToCommentReview:review InMoment:self.moment.moment_id];
}

#pragma mark -- comment style
-(NSString*)styledLikeComment
{
    NSString* str = @"";
    
    for (int i= 0; i< [self.arr_likedBuddy count]; i++) {
        Review* buddy = [self.arr_likedBuddy objectAtIndex:i];
        if (i != [self.arr_likedBuddy count] -1) {
            str = [str stringByAppendingFormat:@"<a href==\'%@\'>%@</a>, ",buddy.owerID,buddy.nickName];
        }
        else{
            str = [str stringByAppendingFormat:@"<a href==\'%@\'>%@</a>",buddy.owerID,buddy.nickName];
        }
        
    }
    
    if ([NSString isEmptyString:str]) {
        str = NSLocalizedString(@"Become the first to like！", nil);
    }
    
    return str;
}

-(NSString*)likedString{
    NSString* str = @"";
    
    for (int i= 0; i< [self.arr_likedBuddy count]; i++) {
        Review* buddy = [self.arr_likedBuddy objectAtIndex:i];
        if (i != [self.arr_likedBuddy count] -1) {
            str = [str stringByAppendingFormat:@"%@, ",buddy.nickName];
        }
        else{
            str = [str stringByAppendingFormat:@"%@",buddy.nickName];
        }
    }
    
    if ([NSString isEmptyString:str]) {
        str = NSLocalizedString(@"Become the first to like！", nil);
    }
    
    return str;
    
}

#pragma mark -- button action
-(void)viewUserMoments{
    
    if (self.isInSpace) {
        [(OMBuddySpaceViewController*)self.parent  viewBuddyDetail];
    }
    else{
        
        Buddy* buddy = self.moment.owner;
        
        OMBuddySpaceViewController *bbsvc = [[OMBuddySpaceViewController alloc] init];
        bbsvc.buddyid = buddy.userID;
        [self.parent.navigationController pushViewController:bbsvc animated:YES];
        
        [bbsvc release];
    }
    
}
-(void)viewLocationInMapApp:(id)sender{
    
    //     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?ll=%f,%f",self.moment.latitude,self.moment.longitude]]];
    //NSString * search_apple = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@&ll=139.45,35.41"
    //self.moment.placename =@"japan tokyo";
    NSString * address = self.moment.placename;
    if(![address canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        address = [self.moment.placename stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSString *address_encoded = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * search_apple = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@&ll=%f,%f"
                               ,address_encoded,self.moment.latitude,self.moment.longitude];
    NSString * search_goolge = [NSString stringWithFormat:@"comgooglemaps://?q=%@",address_encoded];
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:search_goolge]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:search_apple]];
    }
    
    
}

-(void)clickVoiceCilp{
    
    NSData* data = [MediaProcessing getMediaForFile:self.voiceclip.fileid withExtension:self.voiceclip.ext];
    
    if (!data){
        return;
    }
    
    if (_isPlaying){
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        return;
    }
    else{
        if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
            [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        }
        
        [VoiceMessagePlayer sharedInstance].delegate = self.parent;
        [VoiceMessagePlayer sharedInstance].filepath =  [NSFileManager absoluteFilePathForMedia:self.voiceclip] ;
        [VoiceMessagePlayer sharedInstance].totalLength = self.voiceclip.duration;
        [VoiceMessagePlayer sharedInstance].moment = _moment;
        [VoiceMessagePlayer sharedInstance].indexpath = _indexPath;
        
        [[VoiceMessagePlayer sharedInstance] playVoiceMessage];
    }
}



-(void)like
{
    if (alreadyLiked) {
        Review* review = [Database getMyLikedReviewForMoment:self.moment.moment_id];
        [WowTalkWebServerIF deleteMomentReview:self.moment.moment_id reviewid:review.review_id withCallback:@selector(didUnlikeReview:) withObserver:self ];
    }
    else{
        [WowTalkWebServerIF reviewMoment:self.moment.moment_id withType:[NSString stringWithFormat:@"%d",REVIEW_TYPE_LIKE] content:@"" withCallback:@selector(didLikeReview:) withObserver:self];
    }
}


-(void)comment
{
    if ([self.parent isKindOfClass:[BizMomentDetailViewController class]]) {
        [(BizMomentDetailViewController*)self.parent tryToCommentMoment:self.moment.moment_id];
    }
    else{
        BizMomentDetailViewController* bmdv = [[BizMomentDetailViewController alloc] init];
        bmdv.moment = self.moment;
        bmdv.needToBecomeFirstResponser = TRUE;
        [self.parent.navigationController pushViewController:bmdv animated:TRUE];
    }
    
    
}

-(void)checkRestriction{
    MomentPrivacyViewController* mpvc = [[MomentPrivacyViewController alloc] init];
//    mpvc.selectedDepartments = [Department departmentsFromIDs:self.moment.viewableGroups];
    mpvc.isNotEditable = TRUE;
    [self.parent.navigationController pushViewController:mpvc animated:TRUE];
    [mpvc release];
}

-(void)favoriteThisMoment:(id)sender{
    UIButton * btn_fav = (UIButton *)sender;
    if (self.moment.isFavorite) {
        self.moment.isFavorite = NO;
//        [Database deleteMomentFromFavorite:self.moment.moment_id];
        [btn_fav setImage:[UIImage imageNamed:@"timeline_favourite_14.png"] forState:UIControlStateNormal];
        [btn_fav setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
        //        if ([self.parent isKindOfClass:[BizFavoriteViewController class]]) {
        //            [[(BizFavoriteViewController *)self.parent arr_moments] removeObject:self.moment];
        //        }
    } else {
        self.moment.isFavorite = YES;
//        [Database addMomentAsFavorite:self.moment.moment_id];
        [btn_fav setImage:[UIImage imageNamed:@"timeline_favourite_14_a.png"] forState:UIControlStateNormal];
        [btn_fav setTitleColor:[Colors wowtalkbiz_blue] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMELINE_MOMENT_STATUS_CHANGED object:self.moment];
    
    [self imageanimation:1.5 onview:btn_fav.imageView];
    //    if ([self.parent isKindOfClass:[BizTimelineViewController class]]) {
    //        [[(BizTimelineViewController *)self.parent tb_moments] reloadData];
    //    } else if ([self.parent isKindOfClass:[BizFavoriteViewController class]]) {
    //        [[(BizFavoriteViewController *)self.parent tb_moments] reloadData];
    //    } else if ([self.parent isKindOfClass:[BizMomentDetailViewController class]]) {
    //        [[(BizMomentDetailViewController *)self.parent tb_detail] reloadData];
    //    }
}
-(void)imageanimation:(float) transform onview:(UIView *)view{
    // アニメーション
    [UIView animateWithDuration:0.5f // アニメーション速度2.5秒
                          delay:0.0f // 1秒後にアニメーション
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // 画像を2倍に拡大
                         view.transform = CGAffineTransformMakeScale(transform, transform);
                         //view.transform = CGAffineTransformMakeScale(1, 1);
                         
                     } completion:^(BOOL finished) {
                         
                         if(transform !=1){
                             [self imageanimation:1 onview:view];
                         }
                     }];
    
}




#pragma mark -- wowtalk network callback.
-(void)didGetBuddyThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];

    if (error.code == NO_ERROR) {
//        NSData* data = [AvatarHelper getThumbnailForUser:_moment.owner.userID];
//        if (data) {
//            UIImageView* avatar = (UIImageView*)[self.contentView viewWithTag:TAG_AVATAR];
//            [avatar setImage:[UIImage imageWithData:data]];
//        }

    }
}

-(void)didLikeReview:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        alreadyLiked = TRUE;
        likeCount ++;
        [self resetLikeAndCommentArea];
        UIButton* btn_like = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_LIKE];
        [btn_like setTitle:[NSString stringWithFormat:@"%d",likeCount] forState:UIControlStateNormal];
        [self imageanimation:1.5 onview:btn_like.imageView];
        

        Moment* moment = [Database getMomentWithID:self.moment.moment_id];
        self.moment.reviews = moment.reviews;
        if (self.hasCommentPart) {
            if ([self.parent isKindOfClass:[BizMomentDetailViewController class]]) {
                [(BizMomentDetailViewController*)self.parent likedTheMoment];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];
    }
}

-(void)didUnlikeReview:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        alreadyLiked = FALSE;
        likeCount --;
        [self resetLikeAndCommentArea];
        UIButton* btn_like = (UIButton*)[self.contentView viewWithTag:TAG_BUTTON_LIKE];
        [btn_like setTitle:[NSString stringWithFormat:@"%d",likeCount] forState:UIControlStateNormal];
        [self imageanimation:1.5 onview:btn_like.imageView];
        
        Moment* moment = [Database getMomentWithID:self.moment.moment_id];
        self.moment.reviews = moment.reviews;
        
        if (self.hasCommentPart) {
            if ([self.parent isKindOfClass:[BizMomentDetailViewController class]]) {
                [(BizMomentDetailViewController*)self.parent unlikedTheMoment];
            }
        }
    
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];
    }
}


-(void)didDownloadImage:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:[[notif userInfo] valueForKey:@"momentid"]];
             // because the cell is reused, we have to check its momentid to verify whether the images needs to be refreshed.
        
        
    }
}

-(void)resizeMyself:(UIImage  *)current_image{
    CGFloat current_height = IMAGE_HEIGHT*current_image.size.width/IMAGE_WIDTH;
    if(current_height>IMAGE_HEIGHT_CURRENT && current_height<=276){
        IMAGE_HEIGHT_CURRENT = current_height;
    }else if (current_height>276){
        IMAGE_HEIGHT_CURRENT = 276;
    }
    if(IMAGE_HEIGHT_CURRENT != IMAGE_HEIGHT){
        //refresh the cell
        //self.parent
        NSLog(@"refesh now !!!!!!!!!!!!");
        //[myTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        IMAGE_HEIGHT = IMAGE_HEIGHT_CURRENT;
    }
    
}


#pragma mark -- height method


+(CGFloat)heightForMoment:(Moment*)tmpmoment{
    
    BOOL withvideo = FALSE,withLocation = FALSE;
    
    int videocount = 0;
    
    if (tmpmoment.multimedias != nil && [tmpmoment.multimedias count] > 0 ){
        for (WTFile* file in tmpmoment.multimedias) {
            if ([file.ext isEqualToString:@"mp4"] || [file.ext isEqualToString:@"mov"]) {
                withvideo = TRUE;
                videocount++;
            }
           
        }
    }
    
    if (![NSString isEmptyString:tmpmoment.placename]) {
        withLocation = TRUE;
    }
    
    CGFloat cellheight = 60;
   
//   // CGFloat textheight = [UILabel labelHeight:tmpmoment.text FontType:16 withInMaxWidth:286]+10;
    CGFloat textheight = [VideoMomentCell getMomentTextHeight:tmpmoment];
    
    cellheight += textheight;

    if (textheight>0 && (withLocation ||  withvideo)) {
        cellheight += 10;
    }
  
    
    if (withLocation) {
        cellheight += 26;
    }
    

    
    
    if (withvideo) {
        if (videocount> IMAGE_COUNTER) {
            int x = (videocount -1)/IMAGE_COUNTER;
            cellheight += 10+ x*(IMAGE_WIDTH+IMAGE_SPACE)+IMAGE_WIDTH;
        }
        else{
             cellheight += IMAGE_HEIGHT;
        }
    }
    
    
    cellheight += 25;
    
   
    cellheight += 55;
    return cellheight;
    
}





+(CGFloat)heightForMomentWithComment:(Moment*)tmpmoment{
    
    BOOL withimage = false, withvoice = false,withLocation = false;
    
    int imagecount = 0;
    
    if (tmpmoment.multimedias != nil && [tmpmoment.multimedias count] > 0) {
        for (WTFile* file in tmpmoment.multimedias) {
            if ([file.ext isEqualToString:@"mp4"] || [file.ext isEqualToString:@"mov"]) {
                withimage = TRUE;
                imagecount ++;
            }
            else if ([file.ext isEqualToString:@"aac"] || [file.ext isEqualToString:@"m4a"]){
                withvoice = TRUE;
            }
        }
    }
    
    if (![NSString isEmptyString:tmpmoment.placename]) {
        withLocation = TRUE;
    }
    
    CGFloat cellheight = 60;
    
    CGFloat textheight = [VideoMomentCell getMomentTextHeight:tmpmoment];
    
    cellheight += textheight;
    

    if (textheight>0 && (withLocation || withvoice || withimage)) {
        cellheight += 10;
    }
    
    if (withLocation) {
        cellheight += 26;
    }
    
    if (withvoice) {
        cellheight = cellheight + 54;
    }
    
    if (withimage) {
        if (imagecount> IMAGE_COUNTER) {
            int x = (imagecount -1)/IMAGE_COUNTER;
            cellheight = cellheight+ 10+ x*(IMAGE_WIDTH +IMAGE_SPACE)+IMAGE_WIDTH;
        }
        else{
            cellheight = cellheight+ (IMAGE_WIDTH+IMAGE_SPACE);
        }
    }
    
    cellheight = cellheight + 25;
    
    // add comment table height
    
    NSMutableArray* arr_likedBuddy = [[NSMutableArray alloc] init];
    NSMutableArray* arr_comments = [[NSMutableArray alloc] init];
    for (Review* review in tmpmoment.reviews) {
        if (review.type == REVIEW_TYPE_LIKE) {
            [arr_likedBuddy addObject:review];
        }
        else if (review.type == REVIEW_TYPE_TEXT){
            [arr_comments  addObject:review];
        }
    }
    
    CGFloat commentTableHeight = 0;
    for (Review* review in arr_comments) {
        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(0,0,320 - 30- 10,100)];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[Review styledReview:review]];
        tempLabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [tempLabel optimumSize];
        commentTableHeight = commentTableHeight+ optimalSize.height+7;
        [tempLabel release];
    }
    
    commentTableHeight += 40;
    if ([arr_comments count] == 0 &&[arr_likedBuddy count] == 0 ) {
        commentTableHeight -=35 ;
    }
    
    
    cellheight = cellheight+commentTableHeight;
    cellheight = cellheight + 12;
    
    return cellheight;
    
}


#pragma mark -- delete the moment

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
          UITableView* tb_comment = (UITableView*)[self.contentView viewWithTag:TAG_TABLE_COMMENT];
        CGPoint touchPoint = [pGesture locationInView:tb_comment];
        NSIndexPath* indexPath = [tb_comment indexPathForRowAtPoint:touchPoint];
        if (indexPath.row == 0) {
            return;
        }
        if (indexPath != nil) {
            //Handle the long press on row
            if (indexPath.row > [self.arr_comments count]) {
                return;
            }
            Review* review = [self.arr_comments objectAtIndex:indexPath.row - 1];
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]] || [review.replyToUid isEqualToString:[WTUserDefaults getUid]]) {
                currentSelectedReviewID = review.review_id;
                UIActionSheet * actionsheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Delete this comment", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [actionsheet showInView:self.parent.view];
                [actionsheet release];
            }
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        [WowTalkWebServerIF deleteMomentReview:self.moment.moment_id reviewid:currentSelectedReviewID withCallback:nil withObserver:nil];
    }
}

-(void)didDeleteReview:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        for (int i = 0; i< [self.moment.reviews count]; i++) {
            Review* review = [self.moment.reviews objectAtIndex:i];
            if ([review.review_id isEqualToString:currentSelectedReviewID]) {
                [self.moment.reviews removeObject:review];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];
        [[(BizMomentDetailViewController*)self.parent tb_detail] reloadData];
    }
}

#pragma mark -- select name url
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString*)url
{
    NSString* buddyid = [url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\'="]];
    OMBuddySpaceViewController *bbsvc = [[OMBuddySpaceViewController alloc] init];
    bbsvc.buddyid = buddyid;
    [self.parent.navigationController pushViewController:bbsvc animated:YES];
    [bbsvc release];
}

#pragma mark - momentheight related
-(int)getMomentLocationHeight{
	return 16;
}

-(int)getMomentInfoHeight{
	return 60;
}
+(int)getMomentTextHeight:(Moment*)moment{
    if(nil == moment.text || 0 == [moment.text length]) {
        return 0;
    }
    id cachedWebViewHeight=[dicLoadedWebViewFittingSize objectForKey:moment.text];
    if (nil != cachedWebViewHeight) {
        return [cachedWebViewHeight integerValue];
    }
    int height=0 ;
    //    if(IS_IOS7){
    //        height  =[UILabel labelHeight:moment.text FontType:17 withInMaxWidth:286] + 20;
    //    }
    //    else if(IS_IOS6){
    //        height  =[UILabel labelHeight:moment.text FontType:19 withInMaxWidth:286] + 20;
    //    }
    //    else if(IS_IOS5){
    //        height  =[UILabel labelHeight:moment.text FontType:19 withInMaxWidth:286] + 20;
    //    }
    height = [UITextView txtHeight:moment.text fontSize:16 andWidth:286];
    return height;
}
-(int)getMomentLikeAndCommentAreaHeight{
	return 12;
}
-(int)getMomentVoiceHeight{
	return 44;
}
-(int)getMomentPicturesHeight{
    int imagecount = [self.arr_videos count];
    height = 0;
    if (imagecount>IMAGE_COUNTER) {
        int x = (imagecount-1)/IMAGE_COUNTER;
        height= x*(IMAGE_HEIGHT+IMAGE_SPACE)+IMAGE_HEIGHT;;
    }
    else{
        height += IMAGE_HEIGHT;
    }
    return height;
}
-(int)getMomentLikeAndCommentButtonHeight{
	return 50;
}
#pragma mark -- momoent URL link
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        [[UIApplication sharedApplication] openURL:[request URL]];
        
        return NO;
    }
    
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
   // NSString *fixWidth =@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=286;', false);";
   // [webView stringByEvaluatingJavaScriptFromString:fixWidth];
    
    id cachedWebViewHeight=[dicLoadedWebViewFittingSize objectForKey:_moment.text];
    CGRect frame = webView.frame;
    int initFrameHeight=frame.size.height;
    
    /*hacked by coca0406*/
    /*frame.size.height=1;
    webView.frame=frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size=fittingSize;
    webView.frame=frame;*/
    /*end of hacking*/
    
    /*hacked by coca0410*/
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    CGSize fittingSize = newFrame.size;
    /*end of hacking*/
    
    
    
    
    if (nil == cachedWebViewHeight ||
        ([cachedWebViewHeight integerValue] != fittingSize.height && [cachedWebViewHeight integerValue] != initFrameHeight)) {
        //NSLog(@"webView loaded for %@: origin frame=%@",_moment.text,NSStringFromCGRect(frame));
        //NSLog(@"webView loaded for %@: fitting size=%@",_moment.text,NSStringFromCGSize(fittingSize));
        
        int actHeight=fittingSize.height;
        if (fittingSize.width < 286) {
            //if only one line,height seems too much,so do a special handle
            actHeight=initFrameHeight;
        }
        NSString *key2store=_moment.text;
        if (nil != key2store && 0 != [key2store length]) {
            [dicLoadedWebViewFittingSize setObject:[NSNumber numberWithInteger: actHeight] forKey:key2store];
            [[NSNotificationCenter defaultCenter] postNotificationName:WT_NEED_RELOAD_TIMELINE_MOMENT_TABLE object:nil];
        }
    }
}

- (void)dealloc
{

    NSLog(@"normal moment cell dealloc");

    if(self.moment){
        [self.moment release];
        self.moment = nil;
    }
    
    if(self.arr_videos){
        [self.arr_videos release];
    }
    if(self.arr_comments){
        [self.arr_comments release];
    }
    if(self.arr_likedBuddy){
        [self.arr_likedBuddy release];
    }
    
    for(UIView* subview in [self.contentView subviews]){
        [subview removeFromSuperview];
    }

  

    
    [super dealloc];
}



-(void)watchTheMovie:(id)sender{
    
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        WTFile* file = [self.arr_videos objectAtIndex:[(UIButton*)sender tag]];
        
        
        if (file==nil || file.fileid==nil) {
            return;
        }
        
        NSString* tmpfileid = [file.fileid stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
        
        NSString *mp4File =[ NSString stringWithFormat:@"http://%@.oss-cn-hangzhou.aliyuncs.com/momentfile/%@.mp4",S3_BUCKET,tmpfileid];
        
        MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:mp4File]];
        [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [moviePlayerViewController.moviePlayer setShouldAutoplay:YES];
        [moviePlayerViewController.moviePlayer setFullscreen:NO animated:YES];
        [moviePlayerViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [moviePlayerViewController.moviePlayer setScalingMode:MPMovieScalingModeNone];

        
        [[NSNotificationCenter defaultCenter] addObserver:self    selector:@selector(moviePlaybackStateDidChange:)      name:MPMoviePlayerPlaybackStateDidChangeNotification    object:moviePlayerViewController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self     selector:@selector(moviePlayBackDidFinish:)    name:MPMoviePlayerPlaybackDidFinishNotification     object:moviePlayerViewController];

        [self.parent presentViewController:moviePlayerViewController animated:YES completion:nil];
        moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;

        [moviePlayerViewController release];
        [pool release];
    }
    @catch (NSException *exception) {
        // throws exception
        NSLog(@"%@",exception.description);
    }
    
    
    
}


@end
