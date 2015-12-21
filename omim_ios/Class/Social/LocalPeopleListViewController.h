//
//  LocalPeopleListViewController.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewDelegate.h"
#import "LocationHelper.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@class UIGridView;

@interface LocalPeopleListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGridViewDelegate,LocationHelperDelegate,CLLocationManagerDelegate>

@property (retain, nonatomic) UITableView *nearPersonVTable;
@property (retain, nonatomic) UITableView *nearGroupTable;
@property (retain, nonatomic) UIGridView  *nearPersonHTable;
@property (retain, nonatomic) NSMutableArray *nearPersonArray;
@property (retain, nonatomic) NSMutableArray *nearGroupArray;
@property (assign, nonatomic) BOOL isHTable;
@property (nonatomic,retain)CLLocationManager *myLocationManager;

@end
