//
//  DiscoveryVC.m
//  dev01
//
//  Created by Huan on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "DiscoveryVC.h"
#import "ActivityListViewController.h"
#import "TimelineContainerVC.h"
#import "PublicFunctions.h"
#import "weburlview.h"

@interface DiscoveryVC ()
@property (retain, nonatomic) IBOutlet UIButton *funActivity_Btn;
@property (retain, nonatomic) IBOutlet UIButton *friendCircle_Btn;
@property (retain, nonatomic) IBOutlet UIImageView *findNone_imageView;

- (IBAction)go_buy:(id)sender;

@end

@implementation DiscoveryVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
}
- (void)configNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    
    self.title = NSLocalizedString(@"Discovery", nil);
    
}

- (IBAction)funActivity:(id)sender {
    ActivityListViewController *activityVC = [[ActivityListViewController alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];
    [activityVC release];
}
- (IBAction)friendCircle:(id)sender {
    TimelineContainerVC *timeLineVC = [[TimelineContainerVC alloc] init];
    [self.navigationController pushViewController:timeLineVC animated:YES];
    [timeLineVC release];
}

- (void)dealloc {
    [_funActivity_Btn release];
    [_friendCircle_Btn release];
    [_findNone_imageView release];
    [super dealloc];
}
- (IBAction)go_buy:(id)sender {
    
//    NSString *urlText = [NSString stringWithFormat:@"http://www.1234o2o.com/product-771.html"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
////    
////    [[UIApplication sharedApplication] openURL:[ NSURL urlWithString:urlText];
//    
//    UIWebView *myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
////    myWebView.delegate=self;
//    NSURLRequest *request=[NSURL :[NSURLURLWithString:urlStr]];
//    [myWebView loadRequest:request];
//    [self.viewaddSubview:myWebView];
    weburlview *wurl = [[weburlview alloc] init];
    wurl.web_url = @"http://www.1234o2o.com/product-771.html";
    [self.navigationController pushViewController:wurl animated:YES];

    
}
@end
