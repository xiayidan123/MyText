//
//  HeaderView.h
//  MG
//
//  Created by macbook air on 14-9-22.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (nonatomic,assign)NSInteger section;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UIImageView *arrowsView;
@end
