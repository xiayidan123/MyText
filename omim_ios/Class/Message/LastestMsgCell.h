//
//  LastestMsgCell.h
//  omim
//
//  Created by Coca on 6/2/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"


@interface LastestMsgCell : UITableViewCell {
	
}


@property (nonatomic,retain) IBOutlet UIImageView* iv_divider;
@property (nonatomic,retain) IBOutlet UIImageView* iv_countbg;

@property(nonatomic,retain) IBOutlet UILabel *lblUserName;
@property(nonatomic,retain) IBOutlet UILabel *lblMsg;
@property(nonatomic,retain) IBOutlet UILabel *lblSentDate;
@property (nonatomic,retain) IBOutlet UILabel* lblcount;

@property (nonatomic,retain) IBOutlet UIButton* btn_delete;

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;


@end
