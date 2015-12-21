//
//  SendTo.m
//  dev01
//
//  Created by Huan on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SendTo.h"
#import "leftBarBtn.h"
#import "PublicFunctions.h"
#import "ContactListViewController.h"
#import "SendToCell.h"
#import "Database.h"
#import "SendToRecently.h"
#import "SendToInSchoolCell.h"
#import "Constants.h"
#import "Buddy.h"
#import "NSFileManager+extension.h"
#import "AppDelegate.h"
#import "MessagesVC.h"
#import "UIImage+Resize.h"
#import "ChatMessage.h"
#import "Database.h"
#import "MessagesVC.h"
#import "UserGroup.h"
#import "OMMessageVC.h"
#import "AddCourseController.h"
@interface SendTo ()<UICollectionViewDataSource,UICollectionViewDelegate,SendToCellDelegate,RecentlytableViewCellDelegate,SendToInSchoolDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *recentPerson_Btn;
@property (retain, nonatomic) IBOutlet UIButton *contactList_Btn;
@property (retain, nonatomic) IBOutlet UIButton *inSchool_Btn;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet UIView *sliderView;
@property (retain, nonatomic) IBOutlet UIView *TopView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property (retain, nonatomic) ContactListViewController *contactListVC;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) Buddy *buddy;
@property (retain, nonatomic) ChatMessage *chatMessage;
@property (assign, nonatomic) BOOL needCropping;
@property (retain, nonatomic) NSMutableArray *buddys;
@property (retain, nonatomic) NSMutableArray *groupAndBuddy;
@end

@implementation SendTo
- (void)dealloc {
    self.buddys = nil;
    self.groupAndBuddy = nil;
    [_searchBar release];
    _searchBar = nil;
    [_recentPerson_Btn release];
    _recentPerson_Btn = nil;
    [_contactList_Btn release];
    _contactList_Btn = nil;
    [_inSchool_Btn release]; _inSchool_Btn = nil;
    [_collectionView release]; _collectionView = nil;
    [_sliderView release]; _sliderView = nil;
    [_TopView release]; _TopView = nil;
    [_centerX release]; _centerX = nil;
    [_imageDataArray release]; _imageDataArray = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self uiConfig];
}
- (void)configNavigation
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"SendTo", nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    leftBarBtn *leftBarBtn = [[[NSBundle mainBundle] loadNibNamed:@"leftBarBtn" owner:nil options:nil] firstObject];
    [leftBarBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)] autorelease];
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)uiConfig
{
    [self configSearchBar];
    
    [self configCollectionView];
    
    [self loadData];
}
- (void)loadData
{
    
}

- (void)addFriend {
    AddCourseController *contactVC = [[AddCourseController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (NSMutableArray *)groupAndBuddy{
    if (!_groupAndBuddy) {
        NSMutableArray *buddyArr = [Database getContactListWithoutOfficialAccounts];
        _groupAndBuddy = buddyArr;
        NSMutableArray *groupArr = [Database getAllFixedGroup];
        [_groupAndBuddy addObjectsFromArray:[groupArr retain]];
    }
    return _groupAndBuddy;
}
- (ContactListViewController *)contactListVC
{
    if (!_contactListVC) {
        _contactListVC = [[ContactListViewController alloc] init];
    }
    return _contactListVC;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:self.contactListVC.accountSectionArray];
    }
    return _dataArray;
}
- (void)configSearchBar
{
    //    self.searchBar.backgroundColor = [UIColor clearColor];
    //    [[self.searchBar.subviews firstObject] removeFromSuperview];
    //    for (UIView *subView in self.searchBar.subviews) {
    //        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
    //            [subView removeFromSuperview];
    //            break;
    //        }
    //    }
    self.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
    //    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)configCollectionView
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.collectionView.bounds.size.width , self.collectionView.bounds.size.height);
    [self.collectionView registerNib:[UINib nibWithNibName:@"SendToCell" bundle:nil] forCellWithReuseIdentifier:@"contact"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SendToRecently" bundle:nil] forCellWithReuseIdentifier:@"recently"];
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"SendToInSchoolCell" bundle:nil] forCellWithReuseIdentifier:@"inschool"];
    [self.collectionView registerClass:[SendToInSchoolCell class] forCellWithReuseIdentifier:@"inschool"];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        static NSString *ID = @"recently";
        SendToRecently *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.delegate = self;
        cell.dataArray = [Database fetchAllBuddysAndGroup:YES];
        return cell;
    }
    else if (indexPath.item == 1)
    {
        static NSString *ID = @"contact";
        SendToCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.delegate = self;
        cell.dataArray = self.groupAndBuddy;
        return cell;
    }
    else {
        static NSString *ID = @"inschool";
        SendToInSchoolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        
        cell.sendDelegate = self;
        return cell;
        
    }
}

#pragma mark - SendToCellDelegate
- (void)getBuddyFromCell:(Buddy *)buddy{
    self.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
    [self thumbnail];
    [self appendPath];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:buddy withFirstChat:NO andViewController:self];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)getGroupFromCell:(UserGroup *)userGroup{
    self.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
    [self thumbnail];
    [self appendPath];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC createGroupChatRoom:userGroup.memberList withGroupID:userGroup.groupID WithViewController:self];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}


#pragma mark - RecentlytableViewCellDelegate
- (void)getBuddyFromRecentCell:(Buddy *)buddy{
    self.buddy = buddy;
}
- (void)getChatMessageFromCell:(ChatMessage *)chatMessage{
    self.chatMessage = chatMessage;
    self.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
    [self thumbnail];
    [self appendPath];
    if (chatMessage.isGroupChatMessage) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC createGroupChatRoom:self.buddys withGroupID:self.chatMessage.chatUserName WithViewController:self];
    }
    else{
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO andViewController:self];
        
    }
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
- (void)getBuddysFromCell:(NSMutableArray *)buddys{
    self.buddys = buddys;
}





- (void)thumbnail
{
    UIImage *image = self.homeworkIMG;
    CGSize targetSize;
    CGSize targetSizeThumbnail;
    if (self.needCropping) {
        if (image.size.height>image.size.width)
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.width) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        }
        else
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.height, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        }
        
        image = [image resizeToSqaureSize:targetSize];
        
        targetSizeThumbnail = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: self.maxThumbnailSize];
        
        self.homeworkThumnailIMG = [image resizeToSqaureSize:targetSizeThumbnail];
        
    }
    else
    {
        targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        
        image = [image resizeToSize:targetSize];
        
        targetSizeThumbnail = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: self.maxThumbnailSize];
        
        self.homeworkThumnailIMG = [image resizeToSize:targetSizeThumbnail];
        
    }
}
-(NSString *)imagePath
{
    if (!_imagePath) {
        _imagePath = [NSFileManager randomRelativeFilePathInDir:self.dirName ForFileExtension:JPG];
    }
    return _imagePath;
}

- (NSString *)thumbnailPath
{
    if (!_thumbnailPath) {
        _thumbnailPath = [NSFileManager randomRelativeFilePathInDir:self.dirName ForFileExtension:JPG];
    }
    return _thumbnailPath;
}
- (NSString *)dirName
{
    if (!_dirName) {
        _dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
    }
    return _dirName;
}
- (void)appendPath
{
    NSData * data = [NSData dataWithData:UIImageJPEGRepresentation(self.homeworkIMG, 1.0f)];//1.0f = 100% quality
    
    [data writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:self.imagePath] atomically:YES];
    NSLog(@"imgpath : %@",self.imagePath);
    NSData * data2 = [NSData dataWithData:UIImageJPEGRepresentation(self.homeworkThumnailIMG, 1.0f)];  //1.0f = 100% quality
    NSLog(@"thumnailPath : %@",self.thumbnailPath);
    [data2 writeToFile: [NSFileManager absolutePathForFileInDocumentFolder:self.thumbnailPath] atomically:YES];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (IBAction)inSchool:(id)sender {
    self.centerX.constant = 215;
    [UIView animateWithDuration:0.2 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    //加动画会底部滑动view会抖动？？？？？？？？
    //    NSIndexPath *IndexPath=[NSIndexPath indexPathForItem:2 inSection:0];
    //    [self.collectionView scrollToItemAtIndexPath:IndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width * 2, 0) animated:NO];
}
- (IBAction)getRecentPerson:(id)sender {
    self.centerX.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.sliderView layoutIfNeeded];
        
    }];
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO ];
}
- (IBAction)getContactList:(id)sender {
    self.centerX.constant = 110;
    [UIView animateWithDuration:0.2 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0) animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int count = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    if (count == 0) {
        self.centerX.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderView layoutIfNeeded];
        }];
    }
    else if (count == 1)
    {
        self.centerX.constant = 110;
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderView layoutIfNeeded];
        }];
    }
    else if (count == 2)
    {
        self.centerX.constant = 215;
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderView layoutIfNeeded];
        }];
    }
}

@end
