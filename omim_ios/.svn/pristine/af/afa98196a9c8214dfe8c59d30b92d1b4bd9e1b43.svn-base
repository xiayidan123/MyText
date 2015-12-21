//
//  AddPhotoView.m
//  dev01
//
//  Created by Huan on 15/5/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "AddPhotoView.h"
#import "LHImageCell.h"
#import "LHLineLayout.h"
#import "NewhomeWorkModel.h"
#import "Moment.h"

#import "YBImagePickerViewController.h"

@interface AddPhotoView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (retain, nonatomic) NSMutableArray * homeWorks;
@end



@implementation AddPhotoView



- (void)dealloc{
    self.photos = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _photos = [[NSMutableArray alloc] init];
        [self loadCollectionView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor redColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"fdsa");
}

- (void)loadCollectionView{
    LHLineLayout *lineLayout = [[[LHLineLayout alloc] init] autorelease];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:lineLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    lineLayout.minimumInteritemSpacing = 5;
    lineLayout.minimumLineSpacing = 5;
//    lineLayout.itemSize = CGSizeMake(80, 80);
//    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LHImageCell" bundle:nil] forCellWithReuseIdentifier:@"hello"];
    [self addSubview:self.collectionView];
}
#pragma mark UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSettingHomework) {
        static NSString *cellID = @"hello";
        LHImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        
        return cell;
    }else{
        if (indexPath.item == self.photos.count) {
            static NSString *cellID = @"hello";
            LHImageCell *redCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            UIImage *image = [UIImage imageNamed:@"timeline_add_photo"];
            redCell.addImage = image;
            return redCell;
        }else{
            static NSString *cellID = @"hello";
            LHImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            cell.image = self.photos[indexPath.item];
            return cell;
        }
    }
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isSettingHomework) {
        return self.photos.count;
    }else{
        return self.photos.count + 1;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSettingHomework) {
        //photo detail
        
    }else{
        if (indexPath.row == self.photos.count) {
            if (self.photos.count >= 7) {
                if ([_delegate respondsToSelector:@selector(cannotAddphoto)]) {
                    [_delegate cannotAddphoto];
                    return;
                }
            }
            // add photo
            if ([_delegate respondsToSelector:@selector(didSelectedAddPhoto)]) {
                [_delegate didSelectedAddPhoto];
            }
        }else{
            // photo detail
        }
    }
}



- (void)setHomeWorkModel:(NewhomeWorkModel *)homeWorkModel{
    if (_homeWorkModel != homeWorkModel) {
        [_homeWorkModel release];
        _homeWorkModel = [homeWorkModel retain];
//        self.photos = homeWorkModel.moment.multimedias;
        
        NSArray *image_array = _homeWorkModel.homework_moment.multimedias;
        
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        
        
        for (int i=0; i<image_array.count; i++){
            WTFile *file = image_array[i];
            
            YBPhotoModel *photo_model = [[YBPhotoModel alloc]init];
            photo_model.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            photo_model.image_obj = file;
            
            [photos addObject:photo_model];
            [photo_model release];
        }
        self.photos = photos;
        [photos release];
    }
}



- (void)setPhotos:(NSMutableArray *)photos{
    [_photos release],_photos = nil;
    _photos = [photos retain];
    
    if (_photos ==nil) return;
    
    [self.collectionView reloadData];
}




@end
