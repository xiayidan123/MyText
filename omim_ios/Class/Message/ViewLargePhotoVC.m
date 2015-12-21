//
//  ViewLargePhotoVC.m
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "ViewLargePhotoVC.h"
//#import "WowtalkAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "PublicFunctions.h"
#import "Constants.h"

#import "MsgComposerVC.h"
#import "WTHeader.h"

@implementation ViewLargePhotoVC

@synthesize iv_container;
@synthesize thumbnailFrame;
@synthesize originalFilePath;
@synthesize sv_container;
@synthesize parent;
@synthesize image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    //   if (!self.isViewLoaded && !self.view.window)
    {
        //     self.originalFilePath = nil;
        //     self.image = nil;
    }
}


-(void)handleTap:(id)sender
{
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    if(!isButtonHide)
    {
        [UIView animateWithDuration:0.3
                         animations:^(void) {
                      //       self.btn_save.alpha = 0;
                      //       self.btn_dismiss.alpha = 0;
                         } completion:^(BOOL finished) {
                             // we're going to crossfade, so change the background to clear
                             isButtonHide = TRUE;
                         }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^(void) {
                      //       self.btn_save.alpha = 1;
                       //      self.btn_dismiss.alpha = 1;
                         } completion:^(BOOL finished) {
                             // we're going to crossfade, so change the background to clear
                             isButtonHide = FALSE;
                         }];
        
        
    }
    
    
    
}

-(void)scale:(id)sender {
	
	static CGRect initialBounds;
    
    UIImageView* imageview = (UIImageView* )[(UIPinchGestureRecognizer*)sender view];
    
    [self.view bringSubviewToFront:imageview];
    
    UIPinchGestureRecognizer* recognizer = (UIPinchGestureRecognizer*)sender;
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = imageview.bounds;
    //    NSLog(@"initial image bound: %f, %f",initialBounds.size.width,initialBounds.size.height);
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        
        CGFloat scale = 1.0 - (lastScale - recognizer.scale);
        
        CGAffineTransform currentTransform = imageview.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        
        initialBounds = CGRectApplyAffineTransform(initialBounds, newTransform);
        
        
        if (recognizer.scale<=1 && (initialBounds.size.width<=320|| initialBounds.size.height<=460))
        {
            lastScale = 1.0;
            
            initialBounds = imageview.bounds;
            
            return;
        }
        else
        {
            lastScale = recognizer.scale;
            imageview.bounds = initialBounds;
            
        }
        
    }
    
	
	if([recognizer state] == UIGestureRecognizerStateEnded)
    {
		lastScale = 1.0;
        
        CGFloat finalX = screenWidth/2;
		CGFloat finalY = screenHeight/2;
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[imageview setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
        
		return;
	}
	
    
    
    
}

-(void)move:(id)sender {
	
    
    
    UIPanGestureRecognizer* recognizer = (UIPanGestureRecognizer*)sender ;
    UIImageView* imageview = ( UIImageView*)[(UIPanGestureRecognizer*)sender view];
    
    CGRect bounds = imageview.bounds;
    CGFloat imageviewwidth = bounds.size.width;
    CGFloat imageviewheight = bounds.size.height;
    
	[[imageview layer] removeAllAnimations];
    
    // shown image size.
    UIImage* realimage = imageview.image;
    CGSize imagescale = [imageview imageScale];
    CGFloat imagewidth = realimage.size.width* imagescale.width;
    CGFloat imageheight = realimage.size.height * imagescale.height;
   
    
     [self.view bringSubviewToFront:imageview];
    

    CGPoint translatedPoint = [recognizer translationInView:self.view];
	
	if([recognizer state] == UIGestureRecognizerStateBegan)
    {
		
        //		firstX = [[sender view] center].x;
        //		firstY = [[sender view] center].y;
        
        
		firstX = [imageview center].x;
		firstY = [imageview center].y;
        
        
	}
	
    if (imagewidth <= screenWidth && imageheight <= screenHeight)
    {
            return;
    }
    else if (imageviewwidth <= screenWidth && imageviewheight <= screenHeight)
    {
            return;
    }
    else
    {
        translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
        [imageview setCenter:translatedPoint];
    }
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat finalX = translatedPoint.x + (.3*[recognizer velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y + (.3*[recognizer velocityInView:self.view].y);
		
    //    NSLog(@"%d", [[UIDevice currentDevice] orientation]);
        
		if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ||
           ([[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown) )
        {
			
            if (imagewidth >= screenWidth)
            {
                
                
                if(finalX <  screenWidth - imagewidth/2)
                {
                    finalX = screenWidth - imagewidth/2;
                    
                }
                
                else if(finalX >  imagewidth/2)
                {
                    
                    finalX = imagewidth/2;
                }
                
			}
            else
            {
            
                finalX = screenWidth/2;
            }
                
              
            if (imageheight >= screenHeight)
            {
                
                
                if(finalY <  screenHeight - imageheight/2) {
                    
                    finalY =  screenHeight - imageheight/2;
                }
                
                else if(finalY > imageheight/2) {
                    
                    finalY = imageheight/2;
                }
            }
            else
            {
                
                finalY = screenHeight/2;
            }
            
            
		}
    
	
		else if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])){
			
            if (imagewidth >= screenHeight) {
                
                
                if(finalX <  screenHeight - imagewidth/2)
                {
                    finalX = screenHeight - imagewidth/2;
                    
                }
                
                else if(finalX >  imagewidth/2) {
                    
                    finalX = imagewidth/2;
                }
                
			}
            else
            {
                
                finalX = screenHeight/2;
                
                
            }
            
            if (imageheight >= screenWidth) {
                
                
                if(finalY <  screenWidth - imageheight/2) {
                    
                    finalY =  screenWidth - imageheight/2;
                }
                
                else if(finalY > imageheight/2) {
                    
                    finalY = imageheight/2;
                }
            }
            else
            {
                
                finalY = screenWidth/2;
            }
		}
		 
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[imageview setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
	}
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    isSaved = TRUE;
    [self.navigationItem disableRightBarButtonItem];
}

-(void)fSavePhoto
{
    if(!isSaved)
    {
        UIImageWriteToSavedPhotosAlbum(self.image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    }
}

-(IBAction)fdismiss:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         self.view.alpha= 0;
                     } completion:^(BOOL finished) {
                         // we're going to crossfade, so change the background to clear
                         //     [self dismissModalViewControllerAnimated:NO];
                         if([self.view superview] != nil)
                         {
                             [self.view removeFromSuperview];
                         }
                         
                     }];
    
}

-(void) fViewImage
{
    if (self.originalFilePath) {
        self.image = [UIImage imageWithContentsOfFile:self.originalFilePath]; 
    }
    else  if (self.asset) {
        
        if ([[VersionHelper systemVersion] floatValue] < 5.0 ) {
            ALAssetRepresentation *defaultRep = [self.asset defaultRepresentation];
           self.image = [UIImage imageWithCGImage:[defaultRep fullScreenImage]
                                                  scale:[defaultRep scale] orientation:(UIImageOrientation)[defaultRep orientation]];
            
          
        }
        else{
              ALAssetRepresentation *defaultRep = [self.asset defaultRepresentation];
            self.image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
        }
       // self.image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullResolutionImage]];
    }
    else
        return;
    
    self.iv_container.contentMode = UIViewContentModeScaleAspectFit;
    [self.iv_container setImage:self.image];
    
    [UIView beginAnimations:@"enlargetofullscreen" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    
    self.view.alpha = 1;
    
    [UIView commitAnimations];
    
}

#pragma mark - View lifecycle
-(void)goBack
{
    /*
    if (self.parent) {
        [self.parent.uv_barcontainer setHidden:NO]; 
    }
  */
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Photo",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;

    self.navigationItem.backBarButtonItem = nil;
    
    UIBarButtonItem *leftbutton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
      [self.navigationItem addLeftBarButtonItem:leftbutton];
    [leftbutton release];
        
    UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_DOWNLOAD_IMAGE] selector:@selector(fSavePhoto)];
       [self.navigationItem addLeftBarButtonItem:rightbutton];
    [rightbutton release];
}

- (void)viewDidLoad
{
    //   NSLog(@"view large photo is loaded");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    // enable the view;
    self.view.alpha =0;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    self.iv_container.userInteractionEnabled = YES;
    
   // [self.btn_dismiss setBackgroundImage:[[Theme sharedInstance]pngImageWithName:PHOTO_CLOSE] forState:UIControlStateNormal];
   // [self.btn_save setBackgroundImage:[[Theme sharedInstance] pngImageWithName:PHOTO_SAVE] forState:UIControlStateNormal];
    
    
 //   UITapGestureRecognizer* tgr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
 //   tgr.delegate = self;
    
    UIPinchGestureRecognizer* pgr = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    pgr.delegate = self;
    
    
	UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
    
    lastScale = 1.0;
    
  //  [self.iv_container addGestureRecognizer:tgr];
    [self.iv_container addGestureRecognizer:pgr];
    [self.iv_container addGestureRecognizer:panRecognizer];
    
    screenHeight = [UISize screenHeight];
    screenWidth = [UISize screenWidth];
    
    originalImageviewWidth = self.iv_container.frame.size.width;
    originalImageviewHeight = self.iv_container.frame.size.height;
    
    [self fViewImage];
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
