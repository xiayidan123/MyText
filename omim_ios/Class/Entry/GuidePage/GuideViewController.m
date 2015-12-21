//
//  GuideViewController.m
//  dev01
//
//  Created by 杨彬 on 15/3/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCollectionViewCell.h"

@interface GuideViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GuideCollectionViewCellDelegate>
@property (retain, nonatomic) IBOutlet UICollectionView *guide_collectionView;

@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (retain, nonatomic)NSArray *imageArray;

@end

@implementation GuideViewController

- (void)dealloc {
    [_imageArray release];
    [_guide_collectionView release];
    [_pageControl release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}

- (void)prepareData{
    UIImage *slide1Image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"slide1" ofType:@"png"]];
    UIImage *slide2Image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"slide2" ofType:@"png"]];
    
    self.imageArray = @[slide1Image,slide2Image,@"null"];
}

- (void)uiConfig{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _guide_collectionView.collectionViewLayout = layout;
    [layout release];
    
    [_guide_collectionView registerNib:[UINib nibWithNibName:@"GuideCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GuideCollectionViewCell"];
    
    
    self.pageControl.numberOfPages = self.imageArray.count - 1;
    
    
}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuideCollectionViewCell *cell = [GuideCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.imageObj = self.imageArray[indexPath.row];
    if (indexPath.row == self.imageArray.count - 2 ){
        cell.isLaste = YES;
    }else{
        cell.isLaste = NO;
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == self.view.bounds.size.width * (self.imageArray.count - 1)){
        if ([self.delegate respondsToSelector:@selector(releaseGuideViewController:)]){
            [self.delegate releaseGuideViewController:self];
        }
    }else{
        if (scrollView.contentOffset.x == self.view.bounds.size.width * (self.imageArray.count - 2)){
            self.pageControl.hidden = YES;
        }else{
            self.pageControl.hidden = NO;
        }
        self.pageControl.currentPage = scrollView.contentOffset.x / self.view.bounds.size.width;
    }
}


#pragma mark - GuideCollectionViewCellDelegate

-(void)enterAppWithGuideCollectionView:(GuideCollectionViewCell *)guideCollectionViewCell{
    if ([self.delegate respondsToSelector:@selector(releaseGuideViewController:)]){
        [self.delegate releaseGuideViewController:self];
    }
}






@end
