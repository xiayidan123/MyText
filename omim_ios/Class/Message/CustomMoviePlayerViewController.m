//
//  CustomMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

#import "WTHeader.h"
#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

@synthesize delegate = _delegate;
/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
    if (moviePath == nil)
    {
        return nil;
    }
	// Initialize and create movie URL
  if (self = [super init])
  {
	  movieURL = [NSURL fileURLWithPath:moviePath];    
     [movieURL retain];
  }
	return self;
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

    // When tapping movie, status bar will appear, it shows up
    // in portrait mode by default. Set orientation to landscape
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
     
   //   CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
   //   NSLog(@"status bar : %f,y %f,w %f,h %f",frame.origin.x, frame.origin.y, frame.size.width,frame.size.height);

      CGFloat screenHeight = [UISize screenHeight];
      CGFloat screenWidth = [UISize screenWidth];
		// Rotate the view for landscape playback
	    [[self view] setBounds:CGRectMake(0, 0, screenHeight, screenWidth)];
		[[self view] setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 

		// Set frame of movieplayer
		[[mp view] setFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
    
    // Add movie player as subview
	   [[self view] addSubview:[mp view]];   

		// Play the movie
		[mp play];
    //  frame = [[UIApplication sharedApplication] statusBarFrame];
//      NSLog(@"status bar : %f,y %f,w %f,h %f",frame.origin.x, frame.origin.y, frame.size.width,frame.size.height);

	}
}


/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{

   [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.view.window.rootViewController.view.frame = [UIScreen mainScreen].applicationFrame;
    
   
 
    
  //  CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
 //   NSLog(@"status bar : %f,y %f,w %f,h %f",frame.origin.x, frame.origin.y, frame.size.width,frame.size.height);
    
 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
  												removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

    [self.delegate movieDidFinished:self];
    
	[self dismissViewControllerAnimated:YES completion:nil];
    
  
   
  
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
    
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

  if ([mp respondsToSelector:@selector(loadState)]) 
  {
  	// Set movie player layout
  	[mp setControlStyle:MPMovieControlStyleFullscreen];
    [mp setFullscreen:YES];

		// May help to reduce latency
		[mp prepareToPlay];

		// Register that the load state changed (movie is ready)
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
      
		[[NSNotificationCenter defaultCenter] addObserver:self
                       selector:@selector(moviePlayerLoadStateChanged:) 
                       name:MPMoviePlayerLoadStateDidChangeNotification 
                       object:nil];
	}  


  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                        selector:@selector(moviePlayBackDidFinish:) 
                        name:MPMoviePlayerPlaybackDidFinishNotification 
                        object:nil];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView
{
  [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];
  [[self view] setBackgroundColor:[UIColor blackColor]];
}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/

-(void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    if (!self.isViewLoaded && !self.view.window)
    {
        if (mp) {
            [mp release];
            mp = nil;
        }
        
        if (movieURL) {
            [movieURL release];
            mp = nil;
        }
        
    }
}
- (void)dealloc 
{
    if (mp) {
        [mp release];
        mp = nil;
    }
    
    if (movieURL) {
        [movieURL release];
        mp = nil;
    }
   
	[super dealloc];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
