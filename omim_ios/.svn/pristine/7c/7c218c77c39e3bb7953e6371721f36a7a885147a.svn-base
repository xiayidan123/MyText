//
//  MultimediaOutgoingCell.h
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoviePlayerViewController.h"

@class PDColoredProgressView;
@class ChatMessage;
@class MsgComposerVC;
@class ViewLargePhotoVC;

@interface MultimediaOutgoingCell : UITableViewCell <CustomMoviePlayerViewControllerDelegate>
{

}



@property (nonatomic,retain) MsgComposerVC* parent;
@property (nonatomic,retain) ChatMessage* msg;
@property (nonatomic,retain) NSIndexPath* indexPath;


@property (nonatomic,retain) IBOutlet UIButton* btn_view;
@property (nonatomic,retain) IBOutlet UIButton* btn_resend;

@property (nonatomic,retain) IBOutlet UIImageView* iv_bg;
@property (nonatomic,retain) IBOutlet UIImageView* iv_content;
@property (nonatomic,retain) IBOutlet UILabel* lbl_sentlabel;
@property (nonatomic,retain) IBOutlet UILabel* lbl_senttimeLabel;

@property (nonatomic,retain) PDColoredProgressView* progressView;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* ua_indicator;

-(void)viewThePhoto;
-(void)watchTheMovie;
-(void)watchThePicVoice;
@end
