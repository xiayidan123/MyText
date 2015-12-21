//
//  PreviewPhotos.m
//  第三方相册
//
//  Created by Huan on 15/3/23.
//  Copyright (c) 2015年 LiuHuan. All rights reserved.
//

#import "PreviewPhotos.h"
#import "EveryPhotoCell.h"
#import "QBImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface PreviewPhotos ()<UICollectionViewDataSource,UICollectionViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *TopConstraint;

@end

@implementation PreviewPhotos
{
    BOOL isTakingPhoto;
    NSMutableArray *_selectedPhotos;
    ALAssetsLibrary* _assetLib;
    BOOL dismissFromPicker;
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BigPhotoCell"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;//左右
    layout.sectionInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    layout.itemSize = CGSizeMake(self.view.bounds.size.width , self.view.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EveryPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"BigPhotoCell"];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSelectStatus
{
    if (![[self.isSelectedBtn.titleLabel text] isEqualToString:@"已选中"]) {
        [self.isSelectedBtn setTitle:@"已选中" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.isSelectedBtn setTitle:@"未选中" forState:UIControlStateNormal];
    }
}
- (IBAction)selecteAction:(id)sender {
    NSLog(@"%@",((UIButton *)sender).titleLabel.text);
    [self changeSelectStatus];
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
        
    }
    return _dataArray;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BigPhotoCell";
    EveryPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.photo_imageV.image = [UIImage imageWithCGImage:[[self.dataArray[indexPath.row] defaultRepresentation] fullScreenImage]];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
//- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
//{
//    if (isTakingPhoto) {
//        isTakingPhoto = FALSE;
//        NSString *mediaType = info[UIImagePickerControllerMediaType];
//        
//        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
//        {
//            // Media is an image
//            UIImage *image = info[UIImagePickerControllerOriginalImage];
//            
//            [_assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
//                [_assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                    [_selectedPhotos addObject:assetURL];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                    //                    [self loadPhotoView];
//                    
//                } failureBlock:^(NSError *error) {
//                    [self dismissViewControllerAnimated:YES completion:NULL];
//                    //                    [self loadPhotoView];
//                }];
//            }];
//        }
//    }
//    else{
//        if(imagePickerController.allowsMultipleSelection) {
//            [_selectedPhotos removeAllObjects];
//            for (ALAsset* asset in info ) {
//                NSURL* url = [[asset defaultRepresentation] url];
//                [_selectedPhotos addObject:url];
//            }
//        }
//        [self dismissViewControllerAnimated:YES completion:NULL];
//        //        [self loadPhotoView];
//    }
//}
//
//
//- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//
//-(NSString*)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
//{
//    return NSLocalizedString(@"select all", nil);
//}
//
//
//- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
//{
//    return NSLocalizedString(@"Deselect all", nil);
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
//{
//    return [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Photo", nil), numberOfPhotos,NSLocalizedString(@"张", nil)];
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
//{
//    return [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Video", nil), numberOfVideos,NSLocalizedString(@"Clips", nil)];
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
//{
//    return [NSString stringWithFormat:@"%@%d%@、%@%d%@",NSLocalizedString(@"Photo", nil), numberOfPhotos,NSLocalizedString(@"张", nil), NSLocalizedString(@"Video", nil), numberOfVideos,NSLocalizedString(@"Clips", nil)];
//}


@end
