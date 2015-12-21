//
//  BizSearchBar.h
//  dev01
//
//  Created by elvis on 2013/08/30.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSearchBarDelegate

-(void)customCancelButtonHit;

@end

@interface BizSearchBar : UISearchBar

@property (nonatomic) BOOL isShortbar ;
@property (nonatomic) BOOL isActive;

@property (nonatomic,retain) UIButton * btn_cancel;
@property (nonatomic,retain) UITextField* tf_inputbox;

@property (nonatomic, assign) id<CustomSearchBarDelegate> customDelegate;


@end
