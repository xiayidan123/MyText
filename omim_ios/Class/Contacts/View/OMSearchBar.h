//
//  OMSearchBar.h
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMSearchBar;

@protocol OMSearchBarDelegate <NSObject,UISearchBarDelegate>
@optional
- (void)searchBarShouldReturn:(OMSearchBar *)searchBar;

@end



@interface OMSearchBar : UISearchBar

@property (copy, nonatomic) NSString * button_title;

@end
