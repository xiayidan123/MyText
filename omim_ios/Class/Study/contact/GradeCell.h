//
//  GradeCell.h
//  MG
//
//  Created by macbook air on 14-9-23.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface GradeCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)void(^CB)(BOOL);

- (void)loadCell:(ClassModel *)model andisunfold:(BOOL)unfold;

@end
