//
//  ReviewListViewController.m
//  omim
//
//  Created by elvis on 2013/05/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ReviewListViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "BizMomentDetailViewController.h"

#define TAG_AVATAR          1
#define TAG_NAME            2
#define TAG_REVIEW_TEXT     3
#define TAG_TIME            4
#define TAG_DIVIDER         5

@interface ReviewListViewController ()
{
    int limits;
    NSInteger offset;
    UILabel* lbl_loading;
    BOOL isLoadingMoreReviews;
}
@property (nonatomic,retain) NSMutableArray* arr_reviews;

@end

@implementation ReviewListViewController


- (void)goBack
{
    if (self.newReviewOnly) {
        self.arr_reviews = [Database getUnreadReviews];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (Review* review in self.arr_reviews) {
            [array addObject:review.review_id];
        }
        
        [WowTalkWebServerIF setReviewAsRead:array withCallback:nil withObserver:nil];
       
        
        [Database setReviewReadByIDArray:array];  // we set it locally as read first.
        [[AppDelegate sharedAppDelegate].tabbarVC refreshCustomBarUnreadNum];
        
        [array release];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    if (self.newReviewOnly) {
        
        UILabel* label = [[[UILabel alloc] init] autorelease];
        label.text = NSLocalizedString(@"New comment",nil);
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        self.navigationItem.titleView = label;

    }
    else{

        UILabel* label = [[[UILabel alloc] init] autorelease];
        label.text = NSLocalizedString(@"comment list",nil);
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
        UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"nav_delete.png"] selector:@selector(clickeToSetAllReviewsInvisible)];
            [self.navigationItem addRightBarButtonItem:barButtonRight];
        [barButtonRight release];
    }
    
}

-(void)clickeToSetAllReviewsInvisible
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Hide all the comments in the list", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
    [alert release];
    
}


-(void)setAllReviewsInvisible
{
    for (Review* review in self.arr_reviews) {
        [Database setReviewInvisible:review.review_id];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self setAllReviewsInvisible];
        [self.arr_reviews removeAllObjects];
        [self.tb_reviews reloadData];
    }
}


#pragma mark -- scoll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.newReviewOnly) {
        return;
    }
    
    CGPoint soffset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = soffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 30;
    if(y > h + reload_distance && h > [UISize screenHeight]) {
        
        if (!scrollView.isDragging && !isLoadingMoreReviews) {
            
            self.tb_reviews.tableFooterView = [self customFootView];
            [self loadMoreReviews];
        }
        
    }
    
}
-(void)loadMoreReviews
{
    offset = [self.arr_reviews count];
    
    [self.arr_reviews addObjectsFromArray:[Database fetchMomentReviewListWithLimit:limits andOffset:(int)offset]];
    [self.tb_reviews reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2];
}

-(void)stopLoading
{
    isLoadingMoreReviews = FALSE;
    self.tb_reviews.tableFooterView = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNav];
    
    
    limits = 10;
    offset = 0;
 
    [self.tb_reviews setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tb_reviews setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_reviews setFrame:CGRectMake(0, 0, self.tb_reviews.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
       
    if (self.newReviewOnly) {
        self.arr_reviews = [Database getUnreadReviews];
    }
    else
        self.arr_reviews = [Database fetchMomentReviewListWithLimit:limits andOffset:(int)offset];
    
    if (self.arr_reviews == nil) {
        self.arr_reviews = [[[NSMutableArray alloc] init] autorelease];
    }
    
    
    [self.tb_reviews reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didGetThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo]valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_reviews reloadData];
    }
    
}
#pragma mark -- tablewiew

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewcell"];
    if (cell == Nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reviewcell"] autorelease];
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
        
        UIImageView*avatar  = [[ UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        avatar.tag = TAG_AVATAR;
        avatar.layer.cornerRadius = 25.0f;
        avatar.layer.masksToBounds = YES;
        [cell.contentView addSubview:avatar];
        [avatar release];
        
        UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:17];
        name.textColor = [Colors grayColor];
        name.textAlignment = NSTextAlignmentLeft;
        name.tag = TAG_NAME;
        [cell.contentView addSubview:name];
        [name release];
        
        UILabel* reviewtext = [[UILabel alloc] initWithFrame:CGRectMake(70, 23, 250, 36)];
        reviewtext.backgroundColor = [UIColor clearColor];
        reviewtext.font = [UIFont systemFontOfSize:15];
        reviewtext.numberOfLines = 2;
        reviewtext.textColor = [Colors blackColor];
        reviewtext.textAlignment = NSTextAlignmentLeft;
        reviewtext.tag = TAG_REVIEW_TEXT;
        [cell.contentView addSubview:reviewtext];
        [reviewtext release];
        
        UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 20)];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:10];
        time.textColor = [Colors grayColor];
        time.textAlignment = NSTextAlignmentLeft;
        time.tag = TAG_TIME;
        [cell.contentView addSubview:time];
        [time release];
        
        UIImageView* divider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 1)];
        [divider setImage:[UIImage imageNamed:DIVIDER_IMAGE_320]];
        divider.tag = TAG_DIVIDER;
        [cell.contentView addSubview:divider];
        [divider release];
        
    }
    
    UIImageView* avatar = (UIImageView*)[cell.contentView viewWithTag:TAG_AVATAR];
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:TAG_NAME];
    UILabel* reviewtext = (UILabel*)[cell.contentView viewWithTag:TAG_REVIEW_TEXT];
    UILabel* time = (UILabel*)[cell.contentView viewWithTag:TAG_TIME];
//    UIImageView* divider = (UIImageView*)[cell.contentView viewWithTag:TAG_DIVIDER];
    
    Review* review = [self.arr_reviews objectAtIndex:indexPath.row];
    
    NSData* data = [AvatarHelper getThumbnailForUser:review.owerID];
    if (data) {
        [avatar setImage:[UIImage imageWithData:data]];
    }
    else{
        [avatar setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        [WowTalkWebServerIF getThumbnailForUserID:review.owerID withCallback:@selector(didGetThumbnail:) withObserver:self];
    }
    
    name.text = review.nickName;
    
    if (review.type == REVIEW_TYPE_LIKE) {
        review.text = NSLocalizedString(@"liked your moment", nil);
    }

    reviewtext.text = review.text;
    
    NSString* timetext = [TimeHelper getReviewTimeFromtimestamp:review.timestamp];
    int width = [UILabel labelWidth:timetext FontType:12 withInMaxWidth:100];
    [time setFrame:CGRectMake(310-width, name.frame.origin.y, width, 20)];
    time.text = timetext;
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Review* review = [self.arr_reviews objectAtIndex:indexPath.row];
    
    
    if (self.newReviewOnly) {
        [WowTalkWebServerIF setReviewAsRead:[NSArray arrayWithObjects:review.review_id, nil] withCallback:nil withObserver:nil];
        [Database setReviewReadByIDArray:[NSArray arrayWithObjects:review.review_id, nil]];
        [[AppDelegate sharedAppDelegate].tabbarVC refreshCustomBarUnreadNum];
    }
    
    Moment* moment = [Database getMomentWithID:review.moment_id];
    BizMomentDetailViewController * mdvc = [[BizMomentDetailViewController alloc] init];
    mdvc.moment = moment;
    [self.navigationController pushViewController:mdvc animated:TRUE];
    [mdvc release];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr_reviews count];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   Review* review = [self.arr_reviews objectAtIndex:indexPath.row];
    return 65;
}

-(UIView*)customFootView
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,  50)];
    [footerview setBackgroundColor:[Colors blackColorUnderMomentTable]];

    lbl_loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
    lbl_loading.text = NSLocalizedString(@"Loading...", nil);
    lbl_loading.font = [UIFont systemFontOfSize:15];
    lbl_loading.textAlignment = NSTextAlignmentCenter;
    lbl_loading.textColor = [UIColor whiteColor];
    lbl_loading.backgroundColor =[UIColor clearColor];
    
    [footerview addSubview:lbl_loading];
    [lbl_loading release];
    
     return [footerview autorelease];
}

@end
