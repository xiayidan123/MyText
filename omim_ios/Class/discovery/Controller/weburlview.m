//
//  webview.m
//  product
//
//  Created by Jonathan on 15/9/16.
//  Copyright (c) 2015年 WowTech Inc. All rights reserved.
//

#import "weburlview.h"
#import "AppDelegate.h"

@interface weburlview()
{
    UIWebView *UIweburl;
}
@end

@implementation weburlview

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIweburl=[[UIWebView alloc] initWithFrame:self.view.bounds];
//    UIweburl.delegate=self;//因为这个代理设置的self
    [self.view addSubview:UIweburl];
    [UIweburl loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.web_url]]];
    
    [UIweburl release];
    UIScrollView *scollview=(UIScrollView *)[[UIweburl subviews]objectAtIndex:0];
    scollview.bounces=NO;
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidUnload{
    [super viewDidUnload];
    self.web_url=nil;
}

- (void)dealloc
{
    [_web_url release];
    [super dealloc];
}

@end