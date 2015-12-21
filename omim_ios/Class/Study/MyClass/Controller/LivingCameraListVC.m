//
//  LivingCameraListVC.m
//  dev01
//
//  Created by 杨彬 on 15/4/7.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LivingCameraListVC.h"
#import "ClassRoomCamera.h"
#import "PublicFunctions.h"
#import "Base64Encode.h"
#import "OMCamPlayVC.h"
#import "WebPlayViewController.h"

@interface LivingCameraListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *camera_tableView;

@end

@implementation LivingCameraListVC

- (void)dealloc {
    self.camera_array = nil;
    [_camera_tableView release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
//    [PublicFunctions hideTabbar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}


- (void)uiConfig{
    self.camera_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
}



#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ClassRoomCamera *camera_model = self.camera_array[indexPath.row];
    cell.textLabel.text = camera_model.camera_name;
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.camera_array.count;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassRoomCamera *camera_model = self.camera_array[indexPath.row];
    NSString *url_string = camera_model.httpUrl;
    //    NSLog(@"%@", url_string);
    if ([url_string hasPrefix:@"http:"]) {
        
        //        NSLog(@"解密后播放地址 %@", [Base64Encode textFromBase64String:url_string]);
        OMCamPlayVC *omcamvc = [[OMCamPlayVC alloc] init];
        
        
        omcamvc.url = [Base64Encode textFromBase64String:url_string];
        [self.navigationController pushViewController:omcamvc animated:YES];
    } else {
        
        
        //        /*************播放视频配置**************/
        //        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        //        NSString *plistPath1
        //        = [paths objectAtIndex:0];
        //        NSLog(@"%@", plistPath1);
        //        [UIImageVideoView setLocalPath:plistPath1];
        
        WebPlayViewController *playVc = [[WebPlayViewController alloc] init];
        playVc.deviceId = url_string;
        //        playVc.username = @"18500134395";
        [self.navigationController pushViewController:playVc animated:YES];
    }
}





@end
