//
//  CustomQBAssetVC.m
//  第三方相册
//
//  Created by Huan on 15/3/26.
//  Copyright (c) 2015年 LiuHuan. All rights reserved.
//

#import "CustomQBAssetVC.h"
#import "PreviewPhotos.h"
#import "SendTo.h"
@interface CustomQBAssetVC ()
@property (nonatomic, retain) UIButton *bottomLetfBtn;
@property (nonatomic, retain) UIButton *bottomRightBtn;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation CustomQBAssetVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.8;
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        _bottomLetfBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomLetfBtn.frame = CGRectMake(0, 0, 40, 40);
        [_bottomLetfBtn setTitle:@"预览" forState:UIControlStateNormal];
        [view addSubview:_bottomLetfBtn];
        [_bottomLetfBtn addTarget:self action:@selector(previewBtn) forControlEvents:UIControlEventTouchUpInside];
        _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomRightBtn.frame = CGRectMake(view.frame.size.width - 80, 0, 80, 40);
        [_bottomRightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_bottomRightBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_bottomRightBtn];
//        [self.view addSubview:view]; // 隐藏先
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[[UIView alloc] init] autorelease]];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)send
{
    SendTo *sendtoVC = [[SendTo alloc] initWithNibName:@"SendTo" bundle:nil];
    sendtoVC.imageDataArray = self.selectedAssets.array;
    [self.navigationController pushViewController:sendtoVC animated:YES];
}
- (void)previewBtn
{
    //    [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
    PreviewPhotos *preView = [[PreviewPhotos alloc] init];
    preView.dataArray = self.selectedAssets.array;
    NSLog(@"%@",preView.dataArray);
    [self.navigationController pushViewController:preView animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)assetCell:(QBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index
{
    [super assetCell:assetCell didChangeAssetSelectionState:selected atIndex:index];
    //暂时隐藏
//    NSString *sendCount = [NSString stringWithFormat:@"发送（%lu）",(unsigned long)self.selectedAssets.count];
//    [_bottomRightBtn setTitle:sendCount forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zd",indexPath.row);
}
@end
