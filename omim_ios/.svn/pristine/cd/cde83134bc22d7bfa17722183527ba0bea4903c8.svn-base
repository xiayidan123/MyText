//
//  PictureBrowserVC.m
//  dev01
//
//  Created by Huan on 15/2/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "PictureBrowserVC.h"
#import "PublicFunctions.h"
#import "PhotoCell.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "WTError.h"
#import "NSFileManager+extension.h"
#import "WTFile.h"
#import "Constants.h"
@interface PictureBrowserVC ()
{
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    UICollectionView *_conllectionView;
    int PhotoIndex;
}
@end

@implementation PictureBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self configNavigation];
    
    [self configUI];
}



- (void)prepareData
{
   
    _data = [[NSMutableData alloc] init];
    _dataArray = [[NSMutableArray alloc] init];

     [self loadData];
}

- (void)loadData
{
    if (_moment.multimedias.count <= 0) {
        //设置没有图片时的背景图
        
    }
    for (int i = 0; i < _moment.multimedias.count; i++) {
        NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_moment.multimedias[i] fileid],[_moment.multimedias[i] ext]] WithSubFolder:@"momentsmedia"]];
        BOOL isDirectory;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (exist && !isDirectory){
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            [_dataArray addObject:image];
            [image release];
        }
        else {
            [WowTalkWebServerIF getMomentMedia:_moment.multimedias[i] isThumb:NO inShowingOrder:i+5100 forMoment:_moment.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
            
        }
    }
}

- (void)didDownloadImage:(NSNotification *)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *fileName = [[notif name] componentsSeparatedByString:@"download_moment_multimedia"][1];
        for (int i=0; i<_moment.multimedias.count; i++){
            if ([[_moment.multimedias[i] fileid] isEqualToString:fileName]){
                NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",fileName,[_moment.multimedias[i] ext]] WithSubFolder:@"momentsmedia"];
                NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:absolutepath];
                [_dataArray addObject:image];
                [image release];
            }
        }
    }
    [_conllectionView reloadData];
}
- (void)configNavigation
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"照片浏览", nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    
    
    UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_DOWNLOAD_IMAGE] selector:@selector(savePhoto)];
    rightbutton.tag = 10001;
    [self.navigationItem addRightBarButtonItem:rightbutton];
    
    [backBarButton release];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePhoto{
    UIButton *btn = (UIButton *)[self.view viewWithTag:10000];
    [btn setEnabled:NO];
    UIImageView *photoView = (UIImageView *)(((PhotoCell *)[_conllectionView viewWithTag:300 + PhotoIndex]).imageView);
    UIImageWriteToSavedPhotosAlbum(photoView.image, nil, nil,nil);
    [self saveShow];
}
-(void)saveShow
{
    UIAlertView *avSave = [[UIAlertView alloc]initWithTitle:nil message:@"已保存到本地相册" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    avSave.alertViewStyle = UIAlertViewStyleDefault;
    [avSave show];
    [avSave release];
    UIButton *btn = (UIButton *)[self.view viewWithTag:10000];
    [btn setEnabled:YES];
}

- (void)configUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;//左右
    layout.sectionInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    layout.itemSize = CGSizeMake(self.view.bounds.size.width , self.view.bounds.size.height - 64);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _conllectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:layout];
    _conllectionView.pagingEnabled = YES;
    _conllectionView.showsHorizontalScrollIndicator = NO;
    _conllectionView.dataSource = self;
    _conllectionView.delegate = self;
    [self.view addSubview:_conllectionView];
    [_conllectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"Cellid"];
}

#pragma mark conllectionView dataSource and Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cellid";
    PhotoCell *cell = [_conllectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.tag = 300 + indexPath.item;
    cell.icon = _dataArray[indexPath.item];
    PhotoIndex = indexPath.item;
    return cell;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self GetPhoto];
    [self ViewOffset:_PageIndex];
    
}
- (void)GetPhoto
{
    
}
- (void)ViewOffset:(int)PageIndex
{
    _conllectionView.contentOffset = CGPointMake(self.view.bounds.size.width * PageIndex, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [super dealloc];
    _conllectionView.delegate = nil,_conllectionView.dataSource = nil;
    [_conllectionView release],_conllectionView = nil;
    
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
