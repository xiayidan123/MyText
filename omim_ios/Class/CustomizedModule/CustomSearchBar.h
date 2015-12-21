//
//  CustomSearchBar.h
//  omim
//
//  Created by coca on 2012/11/03.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchBarDelegate

@optional

- (void)hitCustomCancelButton;

@end

@interface CustomSearchBar : UISearchBar
{

}

@property (nonatomic) BOOL isBarShort;
@property (nonatomic) BOOL isActive;

@property (nonatomic,retain) UIButton * cancelButton;
@property (nonatomic,retain) UITextField* inputTextfield;

@property (nonatomic, assign) id<CustomSearchBarDelegate> customDelegate;

@end
