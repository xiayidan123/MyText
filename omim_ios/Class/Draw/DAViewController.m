//
//  DAViewController.m
//
//  Created by coca on 10/09/14.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "DAViewController.h"
#import "DAScratchPadView.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicFunctions.h"
#import "Constants.h"
#import "UIImage+Resize.h"
#import "NSFileManager+extension.h"
#import "SendTo.h"
#import "OMMessageVC.h"
@interface DAViewController ()
@property (nonatomic,retain) IBOutlet UIView* settingView;
@property (unsafe_unretained, nonatomic) IBOutlet DAScratchPadView *scratchPad;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *airbrushFlowSlider;
@property (retain,nonatomic) IBOutlet UIView* uvControlPanel;


//view control
- (IBAction)triggerSettingView;
- (IBAction)closeSettingView;

//methods
- (IBAction)setColor:(id)sender;
- (IBAction)setWidth:(id)sender;
- (IBAction)setOpacity:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)paint:(id)sender;
- (IBAction)airbrush:(id)sender;
//- (IBAction)airbrushFlow:(id)sender;




@end

@implementation DAViewController

@synthesize myImage;
@synthesize needCropping = _needCropping;
@synthesize maxThumbnailSize = _maxThumbnailSize;
@synthesize imagePath;
@synthesize thumbnailPath;
@synthesize dirName;
@synthesize parent;
@synthesize delegate;
@synthesize mmtType;



- (void)fSend
{
    
        self.mmtType = MMT_PHOTO;
        
        UIImage *image = [self.scratchPad getSketch];

    self.imagePath = [NSFileManager randomRelativeFilePathInDir:dirName ForFileExtension:JPG];
    self.thumbnailPath = [NSFileManager randomRelativeFilePathInDir:dirName ForFileExtension:JPG];
    
    
        CGSize targetSize;
        CGSize targetSizeThumbnail;
        
        UIImage *scaledImage;
        UIImage* thumbnailImage;
        
        if (self.needCropping)
        {
            
            if (image.size.height>image.size.width)
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.width) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            else
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.height, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            
            scaledImage = [image resizeToSqaureSize:targetSize];
            
            targetSizeThumbnail = [scaledImage calculateTheScaledSize:CGSizeMake(scaledImage.size.width, scaledImage.size.height) withMaxSize: self.maxThumbnailSize];
            
            thumbnailImage = [image resizeToSqaureSize:targetSizeThumbnail];
            
        }
        
        else
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            
            scaledImage = [image resizeToSize:targetSize];
            
            targetSizeThumbnail = [scaledImage calculateTheScaledSize:CGSizeMake(scaledImage.size.width, scaledImage.size.height) withMaxSize: self.maxThumbnailSize];
            
            thumbnailImage = [image resizeToSize:targetSizeThumbnail];
        }
        
        
        //   NSLog(@"scaled image size width: %f, height: %f", scaledImage.size.width, scaledImage.size.height);
        //  NSLog(@"scaled thumbnail size width: %f, height: %f", thumbnailImage.size.width, thumbnailImage.size.height);
        
        NSData * data = [NSData dataWithData:UIImageJPEGRepresentation(scaledImage, 1.0f)];//1.0f = 100% quality
        
        [data writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:self.imagePath] atomically:YES];
        
        NSData * data2 = [NSData dataWithData:UIImageJPEGRepresentation(thumbnailImage, 1.0f)];  //1.0f = 100% quality
        
        [data2 writeToFile: [NSFileManager absolutePathForFileInDocumentFolder:self.thumbnailPath] atomically:YES];
        
        [self.delegate getDataFromDAView:self];
//    [self goBack];
    if ([self.navigationController.viewControllers.firstObject isKindOfClass:[OMMessageVC class]]) {
        [self comeBack];
    }
    else{
        SendTo *sendToVC = [[[SendTo alloc] init] autorelease];
        //    sendToVC.homeworkThumnailIMG = thumbnailImage;
        sendToVC.homeworkIMG = image;
        sendToVC.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
        [self.navigationController pushViewController:sendToVC animated:YES];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.64f blue:0.89f alpha:1.00f];
    UIGestureRecognizer *gestureRecognizer = self.navigationController.view.gestureRecognizers.lastObject;
    gestureRecognizer.enabled = YES;
    
}


- (void)comeBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Handler

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    UIGestureRecognizer *gestureRecognizer = self.navigationController.view.gestureRecognizers.lastObject;
    gestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
//    if (IS_IOS7) {
//        [self.view setAutoresizesSubviews:FALSE];
//        [self.view setAutoresizingMask:UIViewAutoresizingNone];
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        
//    }
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    NSLog(@"===========%f",self.view.bounds.size.height);
    self.uvControlPanel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - self.uvControlPanel.bounds.size.height/2);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNav];
    if (myImage) {
        [self.scratchPad setSketch:myImage];
    }
    
    for (UIButton *btn in self.uvControlPanel.subviews){
        if (btn.backgroundColor != [UIColor clearColor]) {
//            btn.layer.masksToBounds  = YES;
//            btn.layer.cornerRadius = btn.frame.size.height/2;
            
        }
    }
    
    

}



-(void)configNav
{
//    UILabel* label = [[[UILabel alloc] init] autorelease];
//    label.text =  NSLocalizedString(@"New Hand-writing",nil);
//    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_CLOSE_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];

    
    barButton = [PublicFunctions getCustomNavButtonWithText:NSLocalizedString(@"Send",nil) withTextColor:[UIColor whiteColor]  target:self selection:@selector(fSend)];
    [self.navigationItem addRightBarButtonItem:barButton];
    [barButton release];

    
}
-(void)goBack
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidUnload {
	[self setScratchPad:nil];
	[self setAirbrushFlowSlider:nil];
    [self setSettingView:nil];
	[super viewDidUnload];
}


- (IBAction)triggerSettingView{
    [self.settingView setHidden: !self.settingView.hidden];
}

- (IBAction)closeSettingView{
    [self.settingView setHidden: YES];
}

#pragma mark - Setting method

- (IBAction)setColor:(id)sender
{
	UIButton* button = (UIButton*)sender;
	self.scratchPad.drawColor = button.backgroundColor;
}

- (IBAction)setWidth:(id)sender
{
	UISlider* slider = (UISlider*)sender;
	self.scratchPad.drawWidth = slider.value;
}

- (IBAction)setOpacity:(id)sender
{
	UISlider* slider = (UISlider*)sender;
	self.scratchPad.drawOpacity = slider.value;
}

- (IBAction)clear:(id)sender
{
	[self.scratchPad clearToColor:[UIColor clearColor]];
    if (myImage) {
        [self.scratchPad setSketch:myImage];
    }
}

- (IBAction)paint:(id)sender
{
	self.scratchPad.toolType = DAScratchPadToolTypePaint;
}

- (IBAction)airbrush:(id)sender
{
	self.scratchPad.toolType = DAScratchPadToolTypeAirBrush;
}

- (IBAction)airbrushFlow:(id)sender
{
	UISlider* slider = (UISlider*)sender;
	self.scratchPad.airBrushFlow = slider.value;
}

@end
