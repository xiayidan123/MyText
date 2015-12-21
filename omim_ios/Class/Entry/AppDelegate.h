//
//  AppDelegate.h
//

#import <UIKit/UIKit.h>
#import "WowtalkUIDelegates.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "LoginCodeVC.h"
#import "LoginVC.h"

#import "OMTabBarVC.h"


@class LoginVC;
@class TabBarViewController;
@class MessagesVC;
@class ContactsViewController;
@class ContactListViewController;
@class CallProcessVC;
@class HomeViewController;
@class TimelineContainerVC;

@class NewHomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WowTalkUIMakeCallDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    BOOL alertShown;
}
@property (assign, nonatomic) BOOL isFull;
@property (assign) BOOL comeFromViewLargePhoto;  // used in moment related.

@property (assign,nonatomic) int unread_message_count;

@property (assign,nonatomic) int unread_moment_notice_count;

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) TabBarViewController *tabbarVC;
@property (nonatomic, retain) MessagesVC *messagesViewController;
//@property (nonatomic, retain) ContactsViewController *contactsViewController;
//@property (nonatomic, retain) ContactListViewController *contactListViewController;
//@property (nonatomic,retain) TimelineContainerVC *timelineContainerVC;


//@property (nonatomic,retain) HomeViewController *homeVC;
//@property (nonatomic,retain) NewHomeViewController *newHomeVC;
@property (nonatomic,retain) LoginCodeVC *loginCodeVC;
@property (nonatomic,retain) LoginVC *lgVC;

@property (nonatomic, retain) CallProcessVC* myCallProcessVC;

@property (nonatomic,retain)CLLocationManager *myLocationManager;

// belows are for timeline view controller get only partial data without reloading all data from db.
@property BOOL needToRefreshCover;
@property BOOL needToAddNewMoment;
@property BOOL needToDeleteMoment;
@property BOOL needToFreshMoment;

@property BOOL dbUpdatedFromFiveToSeven;



@property (nonatomic, retain) UIView* statusView;
@property (nonatomic,retain) UIColor* navColor;

@property BOOL isForwarding;
@property (nonatomic,retain) ChatMessage* forwardingmsg;

@property BOOL hasSyncTheCompanyStructureWithServer;
@property BOOL hasSyncAllTheMemberInfoWithServer;

@property (nonatomic,retain) NSMutableDictionary* dict_syncinfo;

@property BOOL contactListViewIsShown;

@property (nonatomic,retain) NSMutableSet* moments;
@property (nonatomic,retain) NSMutableSet* deletedMoments;
@property (nonatomic,retain) NSMutableSet* refreshedMoments;


@property BOOL barIsShown;
// bool value help the call ui
@property BOOL isCallFromMsgComposer;
@property BOOL isMyCallProcessVCShown;
@property BOOL needRefreshMsgComposer;
@property BOOL appDidEnterBackground;

-(void)initWelcomeVC;
- (void)initProfileSetVC;
-(void)setupApplicaiton:(BOOL)rightAfterLogin;
-(void)logout;


-(void)setStatusColor:(UIColor*)color;

+(AppDelegate*)sharedAppDelegate;


// by yangbin

@property (retain, nonatomic)OMTabBarVC *tabBarVC;


@end
