//
//  BizMomentDetailViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/10/09.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "BizMomentDetailViewController.h"
#import "NormalMomentCell.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "AppDelegate.h"
#import "SurveyMomentCell.h"
#import "MomentPrivacyViewController.h"
#import "WarningView.h"
#import "VideoMomentCell.h"
#define TAG_ACTIONSHEET_MY_MOMENT   101
#define TAG_ACTIONSHEET_OTHERS_MOMENT 102
#define MOMENT_DETAIL_BOTTOM_CELL_HEIGHT 20
@interface BizMomentDetailViewController ()
{
    
    BOOL alreadyLiked;
    BOOL isCommentReview;
    
    int keyboardheight;
    UIView* commentBox;
    UIImageView* iv_commetbox_bg;
    UIImageView* iv_inputbox_bg;
  
    UIButton* btn_like;
    UIButton* btn_send;
    
    CGFloat orginOffsetY;
    BOOL momentDeleted;
    BOOL isCommentBarSet;
    BOOL isVCVisible;
}

@property (nonatomic,retain) UITapGestureRecognizer* gestureRecognizer;
@property (nonatomic,retain) UISwipeGestureRecognizer* swiper;

@property (nonatomic,retain) UIImageView* likeicon;
@property (nonatomic,retain) NSString* currentMomentID;
@property (nonatomic,retain) Review* currentReview;

@property (nonatomic,retain) NSIndexPath* currentMomentIndexPath;
@property CGRect currentCellRectInTable;
@property CGRect currentCellRectInView;

@property  BOOL keyboardIsShown;

@end

@implementation BizMomentDetailViewController
@synthesize inputTextView = _inputTextView;
@synthesize tb_detail;






-(void)resignTextView
{
    [_inputTextView.internalTextView resignFirstResponder];
    [self.view removeGestureRecognizer:self.gestureRecognizer];
    [self.view removeGestureRecognizer:self.swiper];
}


#pragma mark -- comment box

-(void)tryToCommentMoment:(NSString*)momentid{
    isCommentReview = FALSE;
    [_inputTextView.internalTextView becomeFirstResponder];
    _inputTextView.internalTextView.text = @"";
    [_inputTextView setPlaceholder:NSLocalizedString(@"comment max length 260", nil)];
}

-(void) tryToCommentReview:(Review*)review InMoment:(NSString*)momentid
{
    isCommentReview = TRUE;
    self.currentMomentID = momentid;
    self.currentReview = review;
    _inputTextView.internalTextView.text = @"";
    [_inputTextView.internalTextView becomeFirstResponder];
    if ([_inputTextView.internalTextView.text isEqualToString:@""]) {
        [_inputTextView setPlaceholder:[[NSString stringWithFormat:@"@%@ ",review.nickName] stringByAppendingString:NSLocalizedString(@"comment max length 260", nil)]];
    }
    else{
        [_inputTextView setPlaceholder:NSLocalizedString(@"comment max length 260", nil)];
    }
    
}

-(void)buildCommentBar{
    if (isCommentBarSet) {
        return;
    }
    isCommentBarSet=true;
    commentBox = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 40, 320, 40)];
    [commentBox setBackgroundColor:[UIColor whiteColor]];
    
   /* iv_commetbox_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [iv_commetbox_bg setImage:[PublicFunctions strecthableImage:@"bottom_bar_bg.png"]];
    [commentBox addSubview:iv_commetbox_bg];
    [iv_commetbox_bg release];
    */

        iv_inputbox_bg = [[UIImageView alloc] initWithFrame:CGRectMake(42, 5, 218 , 30)];
        _inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(42, 5, 218, 30)];
        _inputTextView.internalTextView.text = @"";
        [_inputTextView setPlaceholder:NSLocalizedString(@"comment max length 260", nil)];
        //add like button
        btn_like = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
        [btn_like setBackgroundColor:[UIColor clearColor]];
        if (alreadyLiked) {
            [btn_like setImage:[UIImage imageNamed:@"timeline_like_btn_a.png"] forState:UIControlStateNormal];
        }
        else{
            [btn_like setImage:[UIImage imageNamed:@"timeline_like_btn.png"] forState:UIControlStateNormal];
        }
        
        [btn_like addTarget:self action:@selector(likeThisMoment:) forControlEvents:UIControlEventTouchUpInside];
        [commentBox addSubview:btn_like];
        [btn_like release];

    
    [iv_inputbox_bg setImage:[PublicFunctions strecthableImage:SMS_TEXT_INPUT_BG]];
    [commentBox addSubview:iv_inputbox_bg];
    
    // minheight is 35;
    _inputTextView.delegate = self;
    
    // the corner radius of the button
    CALayer* txtinput_Layer = [_inputTextView layer];
    [txtinput_Layer setMasksToBounds:YES];
    [txtinput_Layer setCornerRadius:10.0f];
    [txtinput_Layer setBorderWidth:1.0f];
    [txtinput_Layer setBorderColor: [[UIColor clearColor] CGColor]];
    [txtinput_Layer setBackgroundColor: [[UIColor clearColor] CGColor]];
    
    CALayer* txtview_input_internal_layer = [_inputTextView.internalTextView layer];
    [txtview_input_internal_layer setMasksToBounds:YES];
    [txtview_input_internal_layer setCornerRadius:10.0f];
    [txtview_input_internal_layer setBorderWidth:1.0f];
    [txtview_input_internal_layer setBorderColor: [[UIColor clearColor] CGColor]];
    [txtview_input_internal_layer setBackgroundColor:[[UIColor clearColor] CGColor]];
    
    [commentBox addSubview:_inputTextView];
    [_inputTextView release];
    
    // add send button.
    btn_send = [[UIButton alloc] initWithFrame:CGRectMake(265, 5, 50, 32)];
    [btn_send setBackgroundImage:[PublicFunctions strecthableImage:MESSAGE_SEND_BUTTON_IMAGE] forState:UIControlStateNormal];
    [btn_send setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [btn_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_send.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btn_send addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [commentBox addSubview:btn_send];
    [btn_send release];
    
    
    [self.view addSubview:commentBox];
    
}


-(void)sendComment:(id)sender
{
    if ([NSString isEmptyString:_inputTextView.internalTextView.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Input is empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    } else if (_inputTextView.internalTextView.text.length > 260) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"comment max length 260", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (!isCommentReview) {
        [WowTalkWebServerIF reviewMoment:self.currentMomentID withType:[NSString stringWithFormat:@"%d", REVIEW_TYPE_TEXT] content:_inputTextView.internalTextView.text withCallback:@selector(didAddComment:) withObserver:self];
    }
    
    else{
        [WowTalkWebServerIF replyToReview:self.currentReview.review_id inMoment:self.currentMomentID withType:[NSString stringWithFormat:@"%d", REVIEW_TYPE_TEXT] content:_inputTextView.internalTextView.text  withCallback:@selector(didAddComment:) withObserver:self];
        
    }
    
}

-(void)didAddComment:(NSNotification*)notif
{

    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        isCommentReview = FALSE;
        
        _inputTextView.internalTextView.text = @"";
        [self resignTextView];
        
        [commentBox setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
        
        [iv_commetbox_bg setFrame:CGRectMake(0, 0, 320, 40)];

            [iv_inputbox_bg setFrame:CGRectMake(42, 5, 218 , 30)];
            [_inputTextView setFrame:CGRectMake(42, 5, 218 , 30)];
            [btn_like setFrame:CGRectMake(5, 5, 32, 32)];

        [_inputTextView setPlaceholder:NSLocalizedString(@"comment max length 260", nil)];
        [btn_send setFrame:CGRectMake(265, 5, 50, 32)];
        self.moment = [Database getMomentWithID:self.currentMomentID];
        [self.tb_detail reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];
        
        [self performSelector:@selector(refresh2bottom) withObject:self afterDelay:0.3];
    }
}

-(void)refresh2bottom
{
    NSUInteger sections = [self.tb_detail numberOfSections];
    if (sections>0){
        NSUInteger rows = [self.tb_detail numberOfRowsInSection:(sections-1)];
        
        if (rows>0){
            [self.tb_detail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(rows-1) inSection:(sections-1)]
                                    atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }
}


#pragma mark - table delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        if (self.moment.momentType == 3 || self.moment.momentType == 4) {
            return [SurveyMomentCell heightForMomentWithComment:self.moment];
        }
        else if (self.moment.momentType == 6) {
            return [VideoMomentCell heightForMomentWithComment:self.moment];
        }
        else{
            return [NormalMomentCell heightForMomentWithComment:self.moment];
        }
    } else {
        return MOMENT_DETAIL_BOTTOM_CELL_HEIGHT;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        if (self.moment.momentType == 3 || self.moment.momentType == 4) {
            SurveyMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"surveycell_detail"];
            if (cell == Nil) {
                cell = [[[SurveyMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surveycell_detail"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hasCommentPart = TRUE;
            }
            cell.parent = self;
            cell.indexPath = indexPath;
            cell.moment = self.moment;
            return cell;
        }
        else if (self.moment.momentType == 6) {
            VideoMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"videocell_detail"];
            if (cell == Nil) {
                cell = [[VideoMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videocell_detail"] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hasCommentPart = TRUE;
            }
            cell.parent = self;
            cell.indexPath = indexPath;
            cell.moment = self.moment;
            return cell;
        }
        else{
            NormalMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"normalcell_detail"];
            if (cell == Nil) {
                cell = [[NormalMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalcell_detail"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hasCommentPart = TRUE;
            }
            cell.parent = self;
            cell.indexPath = indexPath;
            cell.moment = self.moment;
            return cell;
        }
    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"moment_detail_empty_bottom_cell"];
        if (nil == cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moment_detail_empty_bottom_cell"] autorelease];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.backgroundColor=[UIColor clearColor];
            
            UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, MOMENT_DETAIL_BOTTOM_CELL_HEIGHT)] autorelease];
            view.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:view];
        }
        return cell;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    return [view autorelease];
}


- (IBAction)likeThisMoment:(id)sender
{
    if (alreadyLiked) {
        Review* review = [Database getMyLikedReviewForMoment:self.moment.moment_id];
        [WowTalkWebServerIF deleteMomentReview:self.moment.moment_id reviewid:review.review_id withCallback:@selector(didUnlikeReview:) withObserver:self ];
    }
    else{
        [WowTalkWebServerIF reviewMoment:self.moment.moment_id withType:[NSString stringWithFormat:@"%d",REVIEW_TYPE_LIKE] content:@"" withCallback:@selector(didLikeReview:) withObserver:self];
        
    }
}

-(void)didLikeReview:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        [self likedTheMoment];
        
    }
}

-(void)didUnlikeReview:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        [self unlikedTheMoment];
    }
}


-(void)didVotedTheMoment:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        Moment* newmoment = [[notif userInfo] valueForKey:@"moment"];
        self.moment.options = newmoment.options;
        [self.tb_detail reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];
    }
}

-(void)likedTheMoment{
    [btn_like setImage:[UIImage imageNamed:@"timeline_like_btn_a.png"] forState:UIControlStateNormal];
    alreadyLiked = TRUE;
    
    self.moment = [Database getMomentWithID:self.moment.moment_id];
    [self.tb_detail reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];

}


-(void)unlikedTheMoment{
    [btn_like setImage:[UIImage imageNamed:@"timeline_like_btn.png"] forState:UIControlStateNormal];
    alreadyLiked = FALSE;
    self.moment = [Database getMomentWithID:self.moment.moment_id];
    [self.tb_detail reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:self.moment.moment_id];

}


#pragma mark keyboard notification
// this is called when the mode is changed to keyboard mode or the inputbox is clicked
-(void) keyboardWillShow:(NSNotification *)note{
        self.keyboardIsShown = TRUE;
        [self.view addGestureRecognizer: self.gestureRecognizer];
        [self.view addGestureRecognizer:self.swiper];

        CGRect keyboardFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        int kbSizeH = keyboardFrame.size.height;
        
        int commentbox_y = self.view.frame.size.height - kbSizeH - commentBox.frame.size.height;
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        [commentBox setFrame:CGRectMake(0, commentbox_y, commentBox.frame.size.width, commentBox.frame.size.height)];
    
        [self.tb_detail setFrame:CGRectMake(0,0,self.tb_detail.frame.size.width,self.view.frame.size.height - kbSizeH)];
    
    
    
        [UIView commitAnimations];
    
}

// we hide it when the textfield lost focus. Text_Mode and special mode is different.
-(void) keyboardWillHide:(NSNotification *)note{
    self.keyboardIsShown = FALSE;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    [commentBox setFrame:CGRectMake(0, self.view.frame.size.height - commentBox.frame.size.height, commentBox.frame.size.width, commentBox.frame.size.height)];
    [self.tb_detail setFrame:CGRectMake(0, 0, self.tb_detail.frame.size.width, self.view.frame.size.height)];
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (_inputTextView.frame.size.height - height);
    
    [iv_inputbox_bg setFrame:CGRectMake( _inputTextView.frame.origin.x, _inputTextView.frame.origin.y, _inputTextView.frame.size.width,height)];
    
    CGRect frame = commentBox.frame;
    frame.origin.y += diff;
    frame.size.height -= diff;
    
    [commentBox setFrame:frame];
    [iv_commetbox_bg setFrame:CGRectMake(0, 0, commentBox.frame.size.width, commentBox.frame.size.height)];
    
    frame = btn_send.frame;
    frame.origin.y = (commentBox.frame.size.height-btn_send.frame.size.height)/2;
    btn_send.frame = frame;
    
    frame = btn_like.frame;
    frame.origin.y = (commentBox.frame.size.height - btn_like.frame.size.height)/2;
    btn_like.frame = frame;
}

#pragma mark - voiceplayerdelegate
-(void)didStopPlayingVoice:(VoiceMessagePlayer *)requestor
{

    if (requestor.moment.momentType == 3 || requestor.moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = FALSE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_play.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]];
    }
       else {
           NormalMomentCell* cell = (NormalMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
           cell.isPlaying = FALSE;
           UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
           [recordicon setImage:[UIImage imageNamed:@"timeline_player_play.png"]];
           
           UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
           [recordlabel setText:[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]];
       }

}

-(void)willStartToPlayVoice:(VoiceMessagePlayer *)requestor
{
        if (requestor.moment.momentType == 3 || requestor.moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = TRUE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_stop.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
        else {
            NormalMomentCell* cell = (NormalMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
            cell.isPlaying = TRUE;
            UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
            [recordicon setImage:[UIImage imageNamed:@"timeline_player_stop.png"]];
            
            UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
            [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
        }

}

- (void) timeHandler:(VoiceMessagePlayer *)requestor
{
        if (requestor.moment.momentType == 3 || requestor.moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
        else {
            NormalMomentCell* cell = (NormalMomentCell*)[self.tb_detail cellForRowAtIndexPath:requestor.indexpath];
            UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
            [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
        }

}



#pragma mark -view lifecycle.


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.moment.owner.userID isEqualToString:[WTUserDefaults getUid]]) {
        self.isMe = TRUE;
    }
    [self configNav];
    isCommentReview = FALSE;
    
    [self.tb_detail setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    [self.tb_detail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tb_detail setScrollsToTop:TRUE];
    
    Review* review =  [Database getMyLikedReviewForMoment:self.moment.moment_id];
    
    alreadyLiked = (review!=nil);
    
   
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (Review* review in self.moment.reviews) {
        if (!review.read) {
            [array addObject:review.review_id];
        }
    }
    [WowTalkWebServerIF setReviewAsRead:array withCallback:nil withObserver:nil];
    [array release];

    self.gestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)] autorelease];
    self.gestureRecognizer.delegate = self;
    self.gestureRecognizer.cancelsTouchesInView = TRUE;
    
    self.swiper = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)] autorelease];
    self.swiper.direction = UISwipeGestureRecognizerDirectionDown;
    self.swiper.delegate = self;

    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_detail setFrame:CGRectMake(0, 0, self.tb_detail.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }
    
    momentDeleted=false;
    self.currentMomentID = self.moment.moment_id;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData:) name:TIMELINE_MOMENT_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentActionDeleteMomentHandle:) name:MOMENT_ACTION_DELETE_MOMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentActionRefreshMomentHandle:) name:MOMENT_ACTION_REFRESH_MOMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(check2reloadTableData:) name:BIZ_MEMBER_UPDATED object:nil];
}

-(void)momentActionDeleteMomentHandle:(NSNotification*) notification
{
    NSString *momentId=[notification object];
    if ([momentId isEqualToString:self.currentMomentID]) {
        if (isVCVisible) {
            [self goBack];
        } else {
            momentDeleted=true;
        }
    }
}

-(void)momentActionRefreshMomentHandle:(NSNotification*) notification
{
    NSString *momentId=[notification object];
    if ([momentId isEqualToString:self.moment.moment_id]) {
        self.moment = [Database getMomentWithID:self.moment.moment_id];
        [self.tb_detail reloadData];
    }
}

-(void)check2reloadTableData:(NSNotification*) notification
{
    NSString *memberId=[notification object];
    if (nil != memberId) {
        if ([memberId isEqualToString:self.moment.owner.userID]) {
            [self reloadTableData:notification];
        }
    }
}

-(void)reloadTableData:(NSNotification*) notification
{
    self.moment = [Database getMomentWithID:self.moment.moment_id];
    [ self.tb_detail reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _moment=nil;

    [tb_detail release];
    
    [super dealloc];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didVotedTheMoment:)
                                                 name:WT_VOTE_MOMENT_SURVEY
                                               object:nil];
    
    [self buildCommentBar];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    isVCVisible=true;
    if (self.needToBecomeFirstResponser) {
        [_inputTextView.internalTextView becomeFirstResponder];
        self.needToBecomeFirstResponser = FALSE;
    }
    if (momentDeleted) {
        [self goBack];
    } else {
        if (nil != self.moment && ![NSString isEmptyString:self.moment.moment_id]) {
            [WowTalkWebServerIF getSingleMoment:self.moment.moment_id withCallback:nil withObserver:nil];
        }        
    }
}

-(void)setMomentReviewReaded
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (Review* review in self.moment.reviews) {
        if (!review.read) {
            [array addObject:review.review_id];
        }
    }
    
    [WowTalkWebServerIF setReviewAsRead:array withCallback:nil withObserver:nil];
    
    
    [Database setReviewReadByIDArray:array];  // we set it locally as read first.
    [[AppDelegate sharedAppDelegate].tabbarVC refreshCustomBarUnreadNum];
    
    [array release];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    if ([VoiceMessagePlayer sharedInstance].isPlaying) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WT_VOTE_MOMENT_SURVEY object:self];
    
    
    [self setMomentReviewReaded];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    isVCVisible=false;
    if ([VoiceMessagePlayer sharedInstance].isPlaying) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (_isDeep){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.navigationController pushViewController:viewController animated:animated];
    
}

#pragma mark - navigation bar

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    if (self.isMe) {
        UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MORE_IMAGE] selector:@selector(showActionSheet)];
        [self.navigationItem addRightBarButtonItem:barButtonRight];
        [barButtonRight release];

        
    }
    
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Details",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;

}


#pragma mark-- cover
-(void)showActionSheet
{
    
    if (self.isMe) {
        UIActionSheet* actionsheet;

        actionsheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Delete Timeline", nil),nil];
//        NSLocalizedString(@"View Share Range", nil),
        actionsheet.destructiveButtonIndex = 2;
        actionsheet.tag=TAG_ACTIONSHEET_MY_MOMENT;
        [actionsheet showInView:self.view];
        [actionsheet release];

    
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isMe) {
        if(actionSheet.tag==TAG_ACTIONSHEET_MY_MOMENT){
            switch (buttonIndex) {
                case 0:
                    // [self checkRestriction];
                    [self deleteMoment];
                    break;
                case 1:
                    
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    

}





-(void)deleteMoment
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Delete this moment", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    
    [alert show];
    [alert release];
    
    
}

-(void)didDeleteMoment:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_DELETE_MOMENT object:self.moment.moment_id];
    } else {
        //if network is connected,show operation failed
        //or network failure error will be shown by other part
        if ([WowTalkVoipIF fIsConnectedToNetwork]) {
            [[WarningView viewWithString:NSLocalizedString(@"operation_failed", nil)] showAlert:nil];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!= alertView.cancelButtonIndex) {
        [WowTalkWebServerIF deleteMoment:self.moment.moment_id withCallback:@selector(didDeleteMoment:) withObserver:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end


