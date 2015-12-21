//
//  LHImagePickerController.m
//  第三方相册
//
//  Created by Huan on 15/3/26.
//  Copyright (c) 2015年 LiuHuan. All rights reserved.
//

#import "LHImagePickerController.h"
#import "CustomQBAssetVC.h"
#import "PublicFunctions.h"
@interface LHImagePickerController ()

@end

@implementation LHImagePickerController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self) {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)cancel
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    BOOL showsHeaderButton = ([self.delegate respondsToSelector:@selector(descriptionForSelectingAllAssets:)] && [self.delegate respondsToSelector:@selector(descriptionForDeselectingAllAssets:)]);
    
    //   showsHeaderButton = TRUE;
    
    BOOL showsFooterDescription = NO;
    
    switch(self.filterType) {
        case QBImagePickerFilterTypeAllAssets:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]);
            break;
        case QBImagePickerFilterTypeAllPhotos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]);
            break;
        case QBImagePickerFilterTypeAllVideos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]);
            break;
    }
    
    // Show assets collection view
    CustomQBAssetVC *assetCollectionViewController = [[CustomQBAssetVC alloc] init];
    assetCollectionViewController.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    assetCollectionViewController.delegate = self;
    assetCollectionViewController.assetsGroup = assetsGroup;
    assetCollectionViewController.filterType = self.filterType;
    assetCollectionViewController.showsCancelButton = self.showsCancelButton;
    assetCollectionViewController.fullScreenLayoutEnabled = self.fullScreenLayoutEnabled;
    assetCollectionViewController.showsHeaderButton = showsHeaderButton;
    assetCollectionViewController.showsFooterDescription = showsFooterDescription;
    
    assetCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetCollectionViewController.limitsMinimumNumberOfSelection = self.limitsMinimumNumberOfSelection;
    assetCollectionViewController.limitsMaximumNumberOfSelection = self.limitsMaximumNumberOfSelection;
    assetCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    assetCollectionViewController.selectedAssets = self.TotalSelectedArrays;
    
    NSLog(@"selected photos in the album: %@", self.TotalSelectedArrays);
    
    assetCollectionViewController.flags = self.flags;
    [self.navigationController pushViewController:assetCollectionViewController animated:YES];
    
}
@end
