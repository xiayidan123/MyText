//
//  MultimediaIncomingCell.h
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoviePlayerViewController.h"
#import "OMHeadImgeView.h"

@class PDColoredProgressView;
@class ChatMessage;
@class MsgComposerVC;
@class ViewLargePhotoVC;

@interface MultimediaIncomingCell : UITableViewCell<CustomMoviePlayerViewControllerDelegate>
{
 
}


@property (nonatomic,retain) ChatMessage* msg;
@property (nonatomic,retain) MsgComposerVC* parent;   // exists only the msgcomposer ui is shown.
@property (nonatomic,retain) NSIndexPath* indexPath;


@property (nonatomic,retain) IBOutlet UIImageView* iv_bg;
@property (nonatomic,retain) IBOutlet UIImageView* iv_content;

@property (nonatomic,retain) IBOutlet UIButton* btn_view;


@property (nonatomic,retain) IBOutlet UILabel* lbl_name;
@property (nonatomic,retain) IBOutlet UILabel* lbl_senttimeLabel;
@property (nonatomic,retain) PDColoredProgressView* progressView;

@property (nonatomic,retain) UIButton* btn_viewbuddy;
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

-(void)layoutSubviews;

-(IBAction)downloadMedia:(id)sender;
-(void)viewThePhoto;
-(void)watchTheMovie;
-(void)watchThePicVoice;


@end
