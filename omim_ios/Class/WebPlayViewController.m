//
//  PlayViewController.m
//  product
//
//  Created by miguo on 15/7/23.
//  Copyright (c) 2015年 WowTech Inc. All rights reserved.
//

#import "WebPlayViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WebPlayViewController ()

@property (strong, nonatomic) UIWebView *webView;
@property (copy, nonatomic) NSString *name;

@end

@implementation WebPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    backItem.title =@"返回";
    self.navigationItem.leftBarButtonItem = backItem;

    self.name = @"dsafaf";

    [self initWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStarted:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)initWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if (self.deviceId.length > 0) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://demo.anyan.com/demo_bh.html?device_id=%@&channel_id=1&rate=700", self.deviceId];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
    }
    [self.view addSubview:self.webView];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)videoStarted:(NSNotification *)notification {// 开始播放
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = YES;
    
}



- (void)videoFinished:(NSNotification *)notification {//完成播放
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = NO;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
