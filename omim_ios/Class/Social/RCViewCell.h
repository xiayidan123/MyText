//
//  RCViewCell.h
//  RCLabel
//
//  Created by wow on 14-3-21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface RCViewCell : UITableViewCell {
	RCLabel *rtLabel;
}
@property (nonatomic, retain) RCLabel *rtLabel;
@end
