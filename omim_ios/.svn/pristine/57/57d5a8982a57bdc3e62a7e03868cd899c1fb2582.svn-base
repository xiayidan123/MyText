//
//  ViewDetailedLocationVC.h
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>

@class MsgComposerVC;
@class ViewDetailedLocationVC;
@class CustomAnnotation;
@protocol ViewDetailedLocationVCDelegate

- (void)getDataFromMap:(ViewDetailedLocationVC *)requestor;

@end

enum MAP_VIEW_MODE
{
    PICK_TO_SEND = 0,
    VIEW_DATA,
    PICK_TO_SET_GROUP_POSITION
};

@interface ViewDetailedLocationVC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{

}

@property (nonatomic,retain) CustomAnnotation* annotation;

@property (nonatomic,retain) CLLocation* origin;
@property (nonatomic,assign) MsgComposerVC* parent;
@property (nonatomic,retain) UILabel* lbl_location;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@property (nonatomic,copy)NSString *address;

@property (nonatomic,retain) IBOutlet UIButton* btn_origin;
@property (nonatomic,assign) id<ViewDetailedLocationVCDelegate> delegate;

@property (nonatomic,retain) IBOutlet MKMapView* mapview;
@property(nonatomic,retain) CLLocationManager* cllmanager;

@property (nonatomic,retain) UIButton* btn_goback;
@property (nonatomic,retain) UIButton* btn_send;
@property (nonatomic,retain) UIButton* btn_view;

@property enum MAP_VIEW_MODE mode;

@property (assign) BOOL fixOrigin;

-(IBAction)backToOrigin:(id)sender;


@end
