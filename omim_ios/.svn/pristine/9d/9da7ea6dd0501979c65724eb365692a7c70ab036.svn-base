//
//  ViewDetailedLocationVC.m
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "ViewDetailedLocationVC.h"
#import "CustomAnnotation.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import "MsgComposerVC.h"
#import "NSString+Compare.h"
#import "WGS84TOGCJ02.h"

#define METERS_PER_MILE 1609.344
@interface ViewDetailedLocationVC ()<UIAlertViewDelegate>

@end

@implementation ViewDetailedLocationVC
@synthesize delegate = _delegate;
@synthesize mode = _mode;
@synthesize mapview = _mapview;
@synthesize btn_goback = _btn_goback;
@synthesize btn_send = _btn_send;
@synthesize cllmanager = _cllmanager;
@synthesize parent = _parent;
@synthesize annotation = _annotation;
@synthesize lbl_location = _lbl_location;
@synthesize btn_origin = _btn_origin;
@synthesize origin = _origin;
@synthesize btn_view = _btn_view;

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize fixOrigin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)goBack
{
    if (self.mode == PICK_TO_SET_GROUP_POSITION) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    //    [self.parent.uv_barcontainer setHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)sendTheMapData
{
    if ([NSString isEmptyString: self.annotation.subtitle] ) {
        self.annotation.subtitle = @" ";
    }
    [self.delegate getDataFromMap:self];
    
    [self goBack];
}

-(void)changeTheGroupPosition
{
    [self.delegate getDataFromMap:self];
    [self goBack];
}

-(void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Location",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    
    if (self.mode == PICK_TO_SEND)
    {
        
        UIBarButtonItem *leftbutton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
           [self.navigationItem addLeftBarButtonItem:leftbutton];
        [leftbutton release];
        
//        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(sendTheMapData)];
        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavDoneButtonWithTarget:self selector:@selector(sendTheMapData)];
          [self.navigationItem addRightBarButtonItem:rightbutton];
        [rightbutton release];
        [self.navigationItem disableRightBarButtonItem];
        
    }
    else if(self.mode == VIEW_DATA)
    {

        UIBarButtonItem *leftbutton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:leftbutton];
        [leftbutton release];
        
        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MAP_IMAGE] selector:@selector(openMapApp)];
           [self.navigationItem addRightBarButtonItem:rightbutton];
        [rightbutton release];
        
    }
    else if (self.mode == PICK_TO_SET_GROUP_POSITION)
    {
        
        UIBarButtonItem *leftbutton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:leftbutton];
        [leftbutton release];
        
//        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(changeTheGroupPosition)];
        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavDoneButtonWithTarget:self selector:@selector(changeTheGroupPosition)];
           [self.navigationItem addRightBarButtonItem:rightbutton];
        [rightbutton release];
        [self.navigationItem disableRightBarButtonItem];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    
    
    if (self.mode == PICK_TO_SEND || self.mode == PICK_TO_SET_GROUP_POSITION) {
        self.btn_send.enabled = false;
        
        if (nil == self.cllmanager)
        {
            self.cllmanager = [[[CLLocationManager alloc] init] autorelease];
            
            self.cllmanager.delegate = self;
            self.cllmanager.desiredAccuracy = kCLLocationAccuracyKilometer;
            
            // Set a movement threshold for new events.
            self.cllmanager.distanceFilter = 500;
            
            if(![CLLocationManager locationServicesEnabled]
               || (!(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)))){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请允许调用位置信息,方可使用此功能!\n您可以在\"设置->隐私->定位\"中启用",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"设置",nil), nil];
                alertView.tag = 2123;
                [alertView show];
                [alertView release];
                return;
            }
        }
        
        [self.cllmanager startUpdatingLocation];
        
    }
    
    
    
    [self.btn_origin setBackgroundImage:[UIImage imageNamed:@"location_btn.png"] forState:UIControlStateNormal];
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.mode == VIEW_DATA) {
        
        self.annotation = [[[CustomAnnotation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        self.annotation.subtitle = _address;
        self.annotation.title = NSLocalizedString(@"当前位置",nil);
        
        self.origin = [[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startCoord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        if (viewRegion.span.latitudeDelta < 0 || viewRegion.span.longitudeDelta < 0) {
            //somewhere in moment,latitude and longitude is not correct order,try again
            CLLocationDegrees tmpDegree;
            tmpDegree = self.latitude;
            self.latitude=self.longitude;
            self.longitude=tmpDegree;
            
            self.annotation = [[[CustomAnnotation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
            startCoord = CLLocationCoordinate2DMake(self.latitude, self.longitude);
            
            
            self.origin = [[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
            
            viewRegion = MKCoordinateRegionMakeWithDistance(startCoord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        }
        
        MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
        
        [self.mapview setRegion:adjustedRegion animated:NO];
        
        [self.mapview addAnnotation:self.annotation];
    }
}

#pragma mark - 
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 2123) {
        // Send the user to the Settings for this app
        [self.navigationController popViewControllerAnimated:NO];
        
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }else if (alertView.tag == 2123 && buttonIndex != 1){
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(fixOrigin)return;
    
    if (self.annotation) {
        self.annotation.coordinate = self.mapview.centerCoordinate;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.annotation.latitude longitude:self.annotation.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark =  placemarks[0];
            
            NSDictionary *address =[[[NSDictionary alloc]initWithDictionary:placemark.addressDictionary] autorelease];
            
            NSString* country = [address valueForKey:@"Country"];
            NSString* city = [address valueForKey:@"City"];
            NSString* state = [address valueForKey:@"State"];
            
            NSString* thoroughfare = [address valueForKey:@"Thoroughfare"];
            NSString* subThoroughfare = [address valueForKey:@"SubThoroughfare"];
            
            NSMutableString* title = [[[NSMutableString alloc] init] autorelease];
            if (country !=nil) {
                [title appendString:country];
                [title appendString:@" "];
            }
            
            if (state !=nil) {
                [title appendString:state];
                [title appendString:@" "];
            }
            
            if (city !=nil) {
                [title appendString:city];
                
                self.annotation.shortTitle = [NSString stringWithFormat:@"%@", title];
                
                [title appendString:@" "];
            }
            
            if (thoroughfare !=nil) {
                [title appendString:thoroughfare];
                [title appendString:@" "];
            }
            if (subThoroughfare !=nil) {
                [title appendString:subThoroughfare];
            }
            
            self.annotation.title = NSLocalizedString(@"Location",nil );
            
            self.annotation.subtitle = title;
            
            if (self.mode == PICK_TO_SEND) {
                self.btn_send.enabled = TRUE;
            }
        }
    }];
    [location release];
    [geocoder release];
    
}


#pragma mark - by yangbin

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (!locations || (locations.count <= 0))return;
    
    CLLocation* location =  [locations firstObject];
    
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        location = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    
    self.origin = location;
    
    [self.cllmanager stopUpdatingLocation];
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake( location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startCoord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
    
    [self.mapview setRegion:adjustedRegion animated:NO];
    
    
    if (nil == self.annotation) {
        self.annotation = [[[CustomAnnotation alloc] initWithLatitude:startCoord.latitude longitude:startCoord.longitude] autorelease] ;
        [self.mapview addAnnotation:self.annotation];
        
    }
    
    [self.navigationItem enableRightBarButtonItem];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark =  placemarks[0];
            
            NSDictionary *address =[[[NSDictionary alloc]initWithDictionary:placemark.addressDictionary] autorelease];
            
            NSString* country = [address valueForKey:@"Country"];
            NSString* city = [address valueForKey:@"City"];
            NSString* state = [address valueForKey:@"State"];
            
            NSString* thoroughfare = [address valueForKey:@"Thoroughfare"];
            NSString* subThoroughfare = [address valueForKey:@"SubThoroughfare"];
            
            NSMutableString* title = [[[NSMutableString alloc] init] autorelease];
            if (country !=nil) {
                [title appendString:country];
                [title appendString:@" "];
            }
            
            if (state !=nil) {
                [title appendString:state];
                [title appendString:@" "];
            }
            
            if (city !=nil) {
                [title appendString:city];
                
                self.annotation.shortTitle = [NSString stringWithFormat:@"%@", title];
                
                [title appendString:@" "];
            }
            
            if (thoroughfare !=nil) {
                [title appendString:thoroughfare];
                [title appendString:@" "];
            }
            if (subThoroughfare !=nil) {
                [title appendString:subThoroughfare];
            }
            
            self.annotation.title = NSLocalizedString(@"Location",nil );
            
            self.annotation.subtitle = title;
            
            if (self.mode == PICK_TO_SEND) {
                self.btn_send.enabled = TRUE;
            }
        }
    }];
    [geocoder release];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.cllmanager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.cllmanager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    } 
}

-(IBAction)backToOrigin:(id)sender
{
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake( self.origin.coordinate.latitude, self.origin.coordinate.longitude);
    
    self.annotation.coordinate = startCoord;
    
    self.mapview.centerCoordinate = startCoord;
    
    [self.cllmanager stopUpdatingLocation];
}


-(void)openMapApp
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?ll=%f,%f",self.annotation.latitude,self.annotation.longitude]]];
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    
    if(annotation != self.mapview.userLocation)
    {
        static NSString *defaultPinID = @"com.wowtech-inc.wowtalk.pin";
        
        pinView = (MKAnnotationView *)[self.mapview dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if ( pinView == nil )
            pinView = [[[MKAnnotationView alloc]
                        initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        pinView.canShowCallout = YES;
        
        pinView.image = [UIImage imageNamed:@"map_pin.png"];    //as suggested by Squatch
        
    }
    
    else {
        [self.mapview.userLocation setTitle:@"I am here"];
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
 
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title = @"hfdasfdsa";
    
//    CLLocationCoordinate2D coord = [userLocation coordinate];
}

-(void)dealloc
{
    self.annotation = nil;
    
    self.origin = nil;
    
    self.lbl_location = nil;
    self.btn_origin = nil;
    self.mapview = nil;
    
    self.cllmanager = nil;
    self.btn_goback = nil;
    self.btn_send = Nil;
    
    [_address release],_address = nil;
    
    [super dealloc];
}

@end
