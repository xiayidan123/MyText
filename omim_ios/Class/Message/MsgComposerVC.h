//
//  MsgComposerVC.h
//  omim
//
//  Created by Coca on 5/26/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>

#import "HPGrowingTextView.h"
#import "EGORefreshTableHeaderView.h"
#import "AVRecorderVC.h"
#import "AlbumPickerViewController.h"
#import "CameraViewController.h"
#import "ViewDetailedLocationVC.h"
#import "ExpressionPickView.h"
#import "DAViewController.h"
#import "PicVoiceMsgPreview.h"
#import "OnlineHomeworkVC.h"
@class Buddy;
@class GroupChatRoom;
@class ChatMessage;
@class AVRecorderVC;
@class ExpressionPickView;

enum MSG_MODE
{
    TEXT_MODE = 0,   // normal mode
    STAMP_MODE,       // stamp board is shown
    KEYBOARD_MODE,    // cover the stamp board with a keyboard.
    MORE_OPERATION_MODE   // shows more functions.
};

@interface MsgComposerVC : UIViewController<AlbumPickerViewControllerDelegate,HPGrowingTextViewDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,AVRecorderVCDelegate,UITextFieldDelegate,CameraViewControllerDelegate,UIGestureRecognizerDelegate,ViewDetailedLocationVCDelegate,ExpressionPickerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DAViewControllerDelegate,PicVoiceMsgPreviewDelegate> {

	BOOL _isKeyboardShown;	
	
	// limit for showing records
	BOOL _shouldShowIncreaseLimitBtn;
	BOOL _shouldReloadMsg;
    
	// reload title name
	BOOL _shouldReloadTitleName;
      
    BOOL changeBackFromKeyboardToStamp;
    
    BOOL resetDefaultOperationBar;
    
    BOOL containsTapGuesture;
    
    int rotatecount;
    BOOL isCloseIcon;
    BOOL needsToRotate;
  //NSString* groupID;
    
}

// by yangbin
@property (nonatomic,assign) BOOL isRemoveBuddyPop;
@property (nonatomic,assign) BOOL isFristChat;


@property (nonatomic,retain) GroupChatRoom* room;
@property BOOL isGroupMode;

@property BOOL isTalkingToOfficialUser;
@property (nonatomic,retain) NSMutableArray* buddys;
//@property (nonatomic,retain) NSString* groupID;  //Here we use username to represent the groupid.

@property (nonatomic,retain) NSMutableArray* arrayOfAutoplayMessages;

@property (nonatomic,retain) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic,retain) CLLocationManager* cllmanager;

@property(nonatomic,retain) NSMutableArray* arrayOfAutoUploadingIndexPaths;


@property (nonatomic) BOOL needToDownloadMissingThumbnails;
@property (nonatomic) int maxNumofThumbnailsToBeDownload;

@property (assign) enum MSG_MODE mInputMode; 
@property (nonatomic,retain) NSString* warningDesc;

//Reloading headerview
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;

@property (nonatomic,assign) id parent;

@property BOOL isFromSelection;  // check whether from a friend selection 


@property (nonatomic,retain) UIImage* imageForProfile;
@property (nonatomic,retain) Buddy* _buddy;
@property (nonatomic,retain) NSString* _userName;  // buddy userID;
@property (nonatomic,retain) NSString* _compositeName;  // show name in local book or phone number of the chatbuddy;
@property (nonatomic,retain) NSString* _displayname; // store the displayname in local

@property (assign)NSInteger _showLimit;
@property (assign)NSInteger _recordCnt;
//@property (assign) NSInteger _recordID;


//Data Structure
@property (nonatomic,retain) NSMutableArray* listOfMessages;
@property (nonatomic,retain) NSMutableArray* dateOfMessages;
@property (nonatomic,retain) NSMutableArray* _arrAllMsgs;


@property (nonatomic,retain) IBOutlet UITableView* tb_messages;

// navigation bar
@property (nonatomic,retain) UIButton* btn_goback;
@property (nonatomic,retain) IBOutlet UIView* uv_navcontainer;
@property (nonatomic,retain) IBOutlet UIButton* btn_addtocontact;
@property (nonatomic,retain) IBOutlet UILabel* lbl_namelist;


@property (nonatomic,retain) UIView* uv_barcontainer;

//default operation bar
@property (nonatomic,retain) IBOutlet UIView* uv_defaultoperationbar;

@property (nonatomic,retain) IBOutlet UIImageView* iv_defaultoperationbar_bg;
@property (nonatomic,retain) IBOutlet UIImageView* iv_inputbox_bg;

@property (nonatomic,retain)  HPGrowingTextView *txtView_Input;
@property (nonatomic,retain) IBOutlet  UIButton* btn_send;
@property (nonatomic,retain) IBOutlet UIButton* btn_showmore;
@property (nonatomic,retain) IBOutlet UIButton* btn_hidemore;
@property (nonatomic,retain) IBOutlet UIButton* btn_stamp;
@property (nonatomic,retain) IBOutlet UIButton* btn_keyboard;



// mic bar;
@property (nonatomic,retain) IBOutlet UIView* uv_micbar_container;
@property (nonatomic,retain) IBOutlet UIView* uv_micbar;
@property (nonatomic,retain) IBOutlet UIButton* btn_record;
@property (nonatomic,retain) IBOutlet UILabel* lbl_recorddesc;
@property (nonatomic,retain) IBOutlet UIButton* btn_gobacktext;
@property (nonatomic,retain) IBOutlet UIImageView* iv_mic_icon;
@property (nonatomic,retain) IBOutlet UIImageView* iv_micbar_bg;

@property (nonatomic,retain) IBOutlet UIImageView* iv_goback;



//more operation bar
@property (nonatomic,retain) IBOutlet UIView* uv_moreoperationbar;
@property (nonatomic,retain) IBOutlet UIImageView* iv_moreoperationbar_bg;

@property (nonatomic,retain) IBOutlet  UIButton* btn_mic;
@property (nonatomic,retain) IBOutlet UIButton* btn_location;
@property (nonatomic,retain) IBOutlet UIButton* btn_photo;
@property (nonatomic,retain) IBOutlet UIButton* btn_camera;
@property (nonatomic,retain) IBOutlet UIButton* btn_call;
@property (nonatomic,retain) IBOutlet UIButton* btn_videocall;

@property (nonatomic,retain) IBOutlet UIButton* btn_pic_write;
@property (nonatomic,retain) IBOutlet UIButton* btn_pic_voice;

// family member operatio bar
@property (retain, nonatomic) IBOutlet UIView *familyOperationBar;
@property (retain, nonatomic) IBOutlet UIImageView *familyOperationBarBackground;
@property (retain, nonatomic) IBOutlet UIButton *familyOperationBarIndicator;




@property (nonatomic,retain) AVRecorderVC* recordVC;
@property (nonatomic,retain) AlbumPickerViewController* pvc;
@property (nonatomic,retain) CameraViewController* cameraViewController;
@property (nonatomic,retain) ExpressionPickView* expressionPickView;


@property (nonatomic,retain) NSMutableArray* arr_photomsgs;




// operation bar button methods
-(IBAction)showMoreMessageOptions:(id)sender;
-(IBAction)ChangeToStampMode:(id)sender;
-(IBAction)ChangeToKeyboardMode:(id)sender;


// mic related method;
-(void)chooseToRecord;
-(IBAction)fBackToTextInput:(id)sender;
-(IBAction)fPressToRecord:(id)sender;
-(IBAction)fReleaseToEnd:(id)sender;


// temp method for multimedia
-(void)sendCurrentLocation;

//album related method
-(void)selectFromAlbum;

// camera related method
-(void)captureUseCamera;

-(IBAction)buttonIsTouchedDown:(id)sender;
-(IBAction)buttonIsTouchedUp:(id)sender;


-(void)startChatWithUser:(NSString*)username withCompositeName:(NSString*)compositename withDisplayname:(NSString*)displayname;

-(void)startGroupChat:(NSString*) groupID withBuddys:(NSArray*)chatbuddys withCompositeName:(NSString*)compositename;

-(void)resignTextView;
-(void)fIncreaseShowLimit;
- (void)ScrollChatTableToLatestMessageRow:(BOOL)animated;
-(void) refreshMessageTableScrollToBottom:(BOOL)isScrollToBottom Animation:(BOOL)isAnimated;


-(void)fProcessNewIncomeMsg:(ChatMessage *)msg;



//-(void)sendMultimediaMessage:(ChatMessage*) msg;
-(void)sendTextMessage;
-(void)startDownloadingThumbnail:(ChatMessage*) msg WithIndexpath:(NSIndexPath*)indexPath;

-(IBAction)addStrangerToContact:(id)sender;

- (IBAction)shouldToggleMoreOperationBar:(id)sender;

-(void)goBack;

- (void)getDataFromDAView:(DAViewController*)requestor;

-(void)getDataFromHomeworkCamera:(OnlineHomeworkVC *)requestor;

- (void)getDataFromSignInContent:(NSString *)content;

@end
