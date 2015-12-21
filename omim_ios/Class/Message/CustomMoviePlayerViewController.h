//
//  CustomMoviePlayerViewController.h
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class CustomMoviePlayerViewController;

@protocol CustomMoviePlayerViewControllerDelegate

-(void)movieDidFinished:(CustomMoviePlayerViewController *)requestor;

@end

@interface CustomMoviePlayerViewController : UIViewController 
{
  MPMoviePlayerController *mp;
  NSURL 	*movieURL;
}

@property (nonatomic,assign) id<CustomMoviePlayerViewControllerDelegate> delegate;

- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;

@end
