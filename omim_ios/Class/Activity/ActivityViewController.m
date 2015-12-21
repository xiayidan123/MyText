//
//  ActivityViewController.m
//  yuanqutong
//
//  Created by Harry on 13-1-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "ActivityViewController.h"
#import "ApplyActivityViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "MediaProcessing.h"
#import "WTFile.h"

#import "WTHeader.h"

@interface ActivityViewController ()

- (void)loadContent;
- (void)loadScrollViewWithPage:(int)page;
- (void)initScrollView;

@end

#define PAGE_SIDE_MARGIN        16
#define PAGE_WIDTH              IPHONE_WIDTH - (PAGE_SIDE_MARGIN * 2)

@implementation ActivityViewController

@synthesize activity;
@synthesize voiceTime;
@synthesize activityScrollView;
@synthesize pictureScrollView;
@synthesize titleView;
@synthesize titleLabel;
@synthesize detailView;
@synthesize timeLabel;
@synthesize localeLabel;
@synthesize typeLabel;
@synthesize feeLabel;
@synthesize voiceView;
@synthesize voiceButton;
@synthesize voiceLabel;
@synthesize contentView;
@synthesize contentLabel;

@synthesize applyView;
@synthesize inputView;
@synthesize inputBg;
@synthesize inputDivider;
@synthesize inputName;
@synthesize inputPhonenumber;
@synthesize moreInfoView;
@synthesize moreInfoLabel;
@synthesize sendIndicatorLabel;
@synthesize emailLabel;

@synthesize buttonView;
@synthesize applyButton;
@synthesize discussionButton;
@synthesize imageViews;
@synthesize applyActivityViewController;


# pragma mark - initialization method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMessage:(Activity *)messageInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.activity = messageInfo;
        self.title = @"活动详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view detail media count : %zi", [self.activity.mediaArray count]);
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
    
    [voiceButton setImage:[UIImage imageNamed:ACTIVITY_PLAY_IMAGE] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:ACTIVITY_PLAY_SELECTED_IMAGE] forState:UIControlStateSelected];
//    [voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initScrollView];
    [self loadContent];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [self.activityScrollView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.activityScrollView setContentOffset:CGPointMake(0, _offsetYBefore) animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _offsetYBefore = self.activityScrollView.contentOffset.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// this is called when the mode is changed to keyboard mode or the textfield is clicked
- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // animation settings
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGRect keyboardFrame = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - keyboardFrame.size.height;
    [self.activityScrollView setFrame:CGRectMake(self.activityScrollView.frame.origin.x, self.activityScrollView.frame.origin.y, IPHONE_WIDTH, height)];
    
    _offsetYBefore = self.activityScrollView.contentOffset.y;
    float bottomY = self.activityScrollView.contentOffset.y + height;
    float inputFieldBottomY = self.applyView.frame.origin.y + self.inputView.inputView.frame.origin.y + self.inputView.frame.size.height;
    if (bottomY < inputFieldBottomY) {
        [self.activityScrollView setContentOffset:CGPointMake(0, inputFieldBottomY - height) animated:YES];
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animation settings
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    float height = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT;
    [self.activityScrollView setFrame:CGRectMake(self.activityScrollView.frame.origin.x, self.activityScrollView.frame.origin.y, IPHONE_WIDTH, height)];
    [self.activityScrollView setContentOffset:CGPointMake(0, _offsetYBefore) animated:YES];
    
    [UIView commitAnimations];
}

- (void)didTapBackground:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.inputName resignFirstResponder];
        [self.inputPhonenumber resignFirstResponder];
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadContent
{
    [self.activityScrollView setFrame:CGRectMake(0, 0, IPHONE_WIDTH, SCREEN_HEIGHT -STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    
//    if (activity.multimedias && activity.multimedias.count > 0) {
    if (YES) {
        [self.pictureScrollView setFrame:CGRectMake(0, 10, IPHONE_WIDTH, ACTIVITY_IMAGESCROLLVIEW_HEIGHT)];
    } else {
        [self.pictureScrollView setFrame:CGRectMake(PAGE_SIDE_MARGIN, 10, IPHONE_WIDTH - PAGE_SIDE_MARGIN * 2, 0)];
    }
    
//    CGSize titleSize = [self.activity.title sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:CGSizeMake(titleLabel.frame.size.width, 9999) lineBreakMode:NSLineBreakByClipping];
    
    CGSize size=CGSizeMake(titleLabel.frame.size.width, 9999);
    UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    NSDictionary *atttibutes=@{NSFontAttributeName:font};
    CGSize titleSize = [self.activity.title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
    
    [self.titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleSize.width, titleSize.height)];
    [self.titleView setFrame:CGRectMake(0, self.pictureScrollView.frame.origin.y + self.pictureScrollView.frame.size.height, IPHONE_WIDTH, self.titleLabel.frame.size.height + 20)];
    [self.detailView setFrame:CGRectMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height, IPHONE_WIDTH, ACTIVITY_TITLEVIEW_HEIGHT)];
    
    // TODO 判断有没有音频文件
    if (activity.mediaArray && activity.mediaArray.count > 0) {
        [self.voiceView setFrame:CGRectMake(0, self.detailView.frame.origin.y + self.detailView.frame.size.height, IPHONE_WIDTH, ACTIVITY_VOICEEVIEW_HEIGHT)];
    } else {
        [self.voiceView setFrame:CGRectMake(0, self.detailView.frame.origin.y + self.detailView.frame.size.height, IPHONE_WIDTH, 0)];
        [self.voiceView setHidden:YES];
    }
    
//    if (activity.multimedias && activity.multimedias.count > 0) {
    if (YES) {
        [self.pictureScrollView setFrame:CGRectMake(PAGE_SIDE_MARGIN, 10, IPHONE_WIDTH - PAGE_SIDE_MARGIN * 2, ACTIVITY_IMAGESCROLLVIEW_HEIGHT)];
    } else {
        [self.pictureScrollView setFrame:CGRectMake(PAGE_SIDE_MARGIN, 10, IPHONE_WIDTH - PAGE_SIDE_MARGIN * 2, 0)];
    }
    
//    CGSize labelSize = [self.activity.content sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(288.0f, 9999) lineBreakMode:NSLineBreakByClipping];
    
    
    CGSize size1=CGSizeMake(288.0f, 9999);
    UIFont *font1 = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *atttibutes1=@{NSFontAttributeName:font1};
    CGSize labelSize = [self.activity.title boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes1 context:nil].size;
    
    [self.contentLabel setFrame:CGRectMake(16.0f, 25.0f, labelSize.width, labelSize.height)];
    
    [self.contentView setFrame:CGRectMake(0, self.voiceView.frame.origin.y + self.voiceView.frame.size.height, IPHONE_WIDTH, self.contentLabel.frame.size.height + 30)];
    [self.buttonView setFrame:CGRectMake(0, self.contentView.frame.origin.y + self.contentView.frame.size.height, IPHONE_WIDTH, ACTIVITY_BUTTONVIEW_HEIGHT)];
    
    [self.inputBg setImage:[[UIImage imageNamed:@"table_white.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:20]];
    if (YES) {
        // have to input apply info when applying
        [self.applyView setHidden:NO];
        if (NO) {
            // only have to input name and phonenumber
            [self.moreInfoView setHidden:YES];
            [self.applyView setFrame:CGRectMake(0, self.contentView.frame.origin.y + self.contentView.frame.size.height, IPHONE_WIDTH, self.inputView.frame.origin.y + self.inputView.frame.size.height)];
        }
        else {
            // have to input various infos
            [self.moreInfoView setHidden:NO];
            NSString *infoStr = @"此处显示创建活动时，创建者填写的信息。";
//            CGSize labelSize = [infoStr sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(288.0f, 9999) lineBreakMode:NSLineBreakByClipping];
            
            CGSize size=CGSizeMake(288.0f, 9999);
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            NSDictionary *atttibutes=@{NSFontAttributeName:font};
            CGSize labelSize = [infoStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
            
            [self.moreInfoLabel setFrame:CGRectMake(0, self.moreInfoLabel.frame.origin.y, labelSize.width, labelSize.height)];
            
            [self.sendIndicatorLabel setFrame:CGRectMake(0, self.moreInfoLabel.frame.origin.y + self.moreInfoLabel.frame.size.height + 15.0f, 288.0f, [UILabel labelHeight:@"发送至：" FontType:16 withInMaxWidth:288.0f])];
            [self.emailLabel setFrame:CGRectMake(0, self.sendIndicatorLabel.frame.origin.y + self.sendIndicatorLabel.frame.size.height, 288.0f, [UILabel labelHeight:@"xd.jian@wowtech-inc.com" FontType:16 withInMaxWidth:288.0f])];
            
            [self.moreInfoView setFrame:CGRectMake(16.0f, self.inputView.frame.origin.y + self.inputView.frame.size.height + 10.0f, 288.0f, self.emailLabel.frame.origin.y + self.emailLabel.frame.size.height)];
            [self.applyView setFrame:CGRectMake(0, self.contentView.frame.origin.y + self.contentView.frame.size.height, IPHONE_WIDTH, self.moreInfoView.frame.origin.y + self.moreInfoView.frame.size.height)];
            self.moreInfoLabel.text = infoStr;
            [infoStr release];
            self.sendIndicatorLabel.text = @"发送至：";
            self.emailLabel.text = @"xd.jian@wowtech-inc.com";
        }
    }
    else {
        // no need to input any info when applying
        [self.applyView setHidden:YES];
        [self.applyView setFrame:CGRectMake(0, self.contentView.frame.origin.y + self.contentView.frame.size.height, IPHONE_WIDTH, 0)];
    }
    [self.buttonView setFrame:CGRectMake(0, self.applyView.frame.origin.y + self.applyView.frame.size.height, IPHONE_WIDTH, ACTIVITY_BUTTONVIEW_HEIGHT)];
    
    
    [self.activityScrollView setContentSize:CGSizeMake(IPHONE_WIDTH, 10 + self.pictureScrollView.frame.size.height + self.titleView.frame.size.height + self.detailView.frame.size.height + self.voiceView.frame.size.height + self.contentView.frame.size.height + self.applyView.frame.size.height + self.buttonView.frame.size.height)];
    
    UIImageView *dividerImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, detailView.frame.origin.y, IPHONE_WIDTH, 1)];
    [dividerImageView1 setImage:[UIImage imageNamed:ACTIVITY_DIVIDER_IMAGE]];
    UIImageView *dividerImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, voiceView.frame.origin.y, IPHONE_WIDTH, 1)];
    [dividerImageView2 setImage:[UIImage imageNamed:ACTIVITY_DIVIDER_IMAGE]];
    UIImageView *dividerImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.origin.y, IPHONE_WIDTH, 1)];
    [dividerImageView3 setImage:[UIImage imageNamed:ACTIVITY_DIVIDER_IMAGE]];
    UIImageView *dividerImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, applyView.frame.origin.y, IPHONE_WIDTH, 1)];
    [dividerImageView4 setImage:[UIImage imageNamed:ACTIVITY_DIVIDER_IMAGE]];

    [self.applyButton setBackgroundImage:[[UIImage imageNamed:LOGINBUTTON_IMAGE] stretchableImageWithLeftCapWidth:30 topCapHeight:30] forState:UIControlStateNormal];
    [self.discussionButton setBackgroundImage:[[UIImage imageNamed:REGISTERBUTTON_IMAGE] stretchableImageWithLeftCapWidth:30 topCapHeight:30] forState:UIControlStateNormal];
    
    [self.activityScrollView addSubview:dividerImageView1];
    [self.activityScrollView addSubview:dividerImageView2];
    [self.activityScrollView addSubview:dividerImageView3];
    [self.activityScrollView addSubview:dividerImageView4];
    
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.activity.startDate];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    
    [self.titleLabel setText:self.activity.title];
    [self.timeLabel setText:dateStr];
    if (self.activity.maxMemberNumber == 0) {
        [self.feeLabel setText:self.activity.maxMemberNumber];
    } else {
        [self.feeLabel setText:@"无限制"];
    }
    
    
    [self.contentLabel setText:self.activity.content];
    [self refreshScrollView];
}

- (void)initScrollView
{
    NSInteger kNumberOfPages = 0;
    if (activity.mediaArray && activity.mediaArray.count > 0)
        kNumberOfPages = activity.mediaArray.count;
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;
    
    pictureScrollView.pagingEnabled = YES;
    pictureScrollView.clipsToBounds = NO;
    pictureScrollView.contentSize = CGSizeMake(pictureScrollView.frame.size.width * kNumberOfPages, pictureScrollView.frame.size.height);
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    pictureScrollView.showsVerticalScrollIndicator = NO;
    pictureScrollView.scrollsToTop = NO;
    pictureScrollView.delegate = self;
    
    
    for (int i = 0; i < kNumberOfPages; i++)
        [self loadScrollViewWithPage:i];
    
    //[pictureScrollView setContentOffset:CGPointMake(0, 0)];
}


- (void)loadScrollViewWithPage:(int)page
{
	NSInteger kNumberOfPages = 0;
    if (activity.mediaArray && activity.mediaArray.count > 0)
        kNumberOfPages = activity.mediaArray.count;
	
    if (page < 0) {
        return;
    }
    if (page >= kNumberOfPages) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageView *tempView = [imageViews objectAtIndex:page];
        if ((NSNull *)tempView == [NSNull null]) {
            tempView = [[UIImageView alloc] init];
            [imageViews replaceObjectAtIndex:page withObject:tempView];
        }
        
      //  NSMutableDictionary *mediadict = [activity.mediaArray objectAtIndex:page];
//        NSData *data = [AvatarHelper getImageForFile:[mediadict objectForKey:@"multimedia_content_path"]];
        WTFile *file = (WTFile *)[self.activity.mediaArray objectAtIndex:page];
        NSData *data = [MediaProcessing getMediaForEvent:file.thumbnailid withExtension:file.ext];
        if (data)
            tempView.image = [UIImage imageWithData:data];
        else
        {
//            [WowTalkWebServerIF getFileFromServer:[mediadict objectForKey:@"multimedia_content_path"] withCallback:@selector(getFile:) withObserver:self];
            /*
            WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:[mediadict objectForKey:@"multimedia_content_path"] taskInfo:[NSDictionary dictionaryWithObjectsAndKeys:[mediadict objectForKey:@"multimedia_content_path"], WT_FILE_PATH_IN_SERVER, nil] taskType:GET_FILE_FROM_SERVER notificationName:@"get_file" notificationObserver:self userInfo:nil];
            [task startWithSelector:@selector(getFile:)];
             */
        }
        
        if (tempView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil == tempView.superview) {
                    CGRect frame = pictureScrollView.frame;
                    frame.origin.x = frame.size.width * page;
                    frame.origin.y = 0;
                    tempView.frame = CGRectMake(frame.size.width * page + 5, 0, 270, 280);
                    [pictureScrollView addSubview:tempView];
                    
                    [tempView setUserInteractionEnabled:YES];
                    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTabImageViewAction:)];
                    [tempView addGestureRecognizer:singleTap];
                    [singleTap release];
                }
            });
        }
        else {
            //NSLog(@"impossible download image");
        }
    });
}

- (void)getFile:(NSNotification *)notification
{
    NSInteger kNumberOfPages = 0;
    if (activity.mediaArray && activity.mediaArray.count > 0)
        kNumberOfPages = activity.mediaArray.count;
    
    for (int i = 0; i < kNumberOfPages; i++)
    {
        UIImageView *tempView = [imageViews objectAtIndex:i];
        if ((NSNull *)tempView == [NSNull null]) {
            tempView = [[UIImageView alloc] init];
            [imageViews replaceObjectAtIndex:i withObject:tempView];
        }
        
        NSMutableDictionary *mediadict = [activity.mediaArray objectAtIndex:i];
        NSData *data = [AvatarHelper getImageForFile:[mediadict objectForKey:@"multimedia_content_path"]];
        if (data)
            tempView.image = [UIImage imageWithData:data];
    }
}

-(void)doTabImageViewAction:(UIGestureRecognizer *)singleTap
{
   
}

- (void)refreshScrollView
{
    static int count = 10;
    NSArray *subViews = [pictureScrollView subviews];
    if ([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [subViews release];
    
    
    for (int i = 0; i < count; i++) {
        int x = 25 + 280 * i;
//        if (i == 0) {
//            x = 25;
//        } else {
//            x = 25 + 280 * i;
//        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 270, 280)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"login_bg_460.png"];
        [pictureScrollView addSubview:imageView];
        [imageView release];
    }
    pictureScrollView.contentSize = CGSizeMake(40 + 280 * count, 280);
    [self.pictureScrollView setContentOffset:CGPointMake(15, 0)];
}


# pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = floor(((self.pictureScrollView.contentOffset.x + 160) - 20) / 280);
    [self.pictureScrollView setContentOffset:CGPointMake(page * 280 + 15, 0) animated:YES];
}

//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    return YES;
//}
//
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{ 
//    return NO; 
//}

- (IBAction)voiceButtonClick:(id)sender
{
    if (voiceButton.selected) {
        [self.voiceLabel setText:@"播放语音介绍"];
        [timer invalidate];
        voiceTime = 0;
    } else{
        [self.voiceLabel setText:@"0"];
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    voiceButton.selected = !voiceButton.selected;
    
}

- (void)onTimer
{
    [self.voiceLabel setText:[NSString stringWithFormat:@"%zi",++voiceTime]];
}

- (IBAction)discussionButtonClick:(id)sender
{
    
}

- (IBAction)applyButtonClick:(id)sender
{
    if (applyActivityViewController == nil) {
        applyActivityViewController = [[ApplyActivityViewController alloc] initWithNibName:@"ApplyActivityViewController" bundle:nil];
    }
    [applyActivityViewController setActivityId:self.activity.eventId];
    [self.navigationController pushViewController:applyActivityViewController animated:YES];
}


- (void)dealloc
{
    [applyActivityViewController release];
    [imageViews release];
    [activityScrollView release];
    [pictureScrollView release];
    [titleLabel release];
    [detailView release];
    [voiceView release];
    [contentView release];
    [buttonView release];
    [timeLabel release];
    [localeLabel release];
    [typeLabel release];
    [feeLabel release];
    [voiceButton release];
    [voiceLabel release];
    [contentLabel release];
    [applyButton release];
    [discussionButton release];
    [titleView release];
    [applyView release];
    [inputView release];
    [inputBg release];
    [inputBg release];
    [inputDivider release];
    [inputName release];
    [inputPhonenumber release];
    [moreInfoView release];
    [moreInfoLabel release];
    [emailLabel release];
    [sendIndicatorLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setActivityScrollView:nil];
    [self setPictureScrollView:nil];
    [self setTitleLabel:nil];
    [self setDetailView:nil];
    [self setVoiceView:nil];
    [self setContentView:nil];
    [self setButtonView:nil];
    [self setTimeLabel:nil];
    [self setLocaleLabel:nil];
    [self setTypeLabel:nil];
    [self setFeeLabel:nil];
    [self setVoiceButton:nil];
    [self setVoiceLabel:nil];
    [self setContentLabel:nil];
    [self setApplyButton:nil];
    [self setDiscussionButton:nil];
    [self setTitleView:nil];
    [self setApplyView:nil];
    [self setInputView:nil];
    [self setInputBg:nil];
    [self setInputBg:nil];
    [self setInputDivider:nil];
    [self setInputName:nil];
    [self setInputPhonenumber:nil];
    [self setMoreInfoView:nil];
    [self setMoreInfoLabel:nil];
    [self setEmailLabel:nil];
    [self setSendIndicatorLabel:nil];
    [super viewDidUnload];
}

@end
