//
//  ShowHomeworkView.m
//  dev01
//
//  Created by Huan on 15/5/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ShowHomeworkView.h"
#import "LHImageCell.h"
#import "NewhomeWorkModel.h"
#import "LHLineLayout.h"
#import "WTUserDefaults.h"
@interface ShowHomeworkView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *content_label;
@property (retain, nonatomic) NSMutableArray *photos;
@property (retain, nonatomic) NSMutableArray * multimedias;
@end


@implementation ShowHomeworkView
- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}
- (void)awakeFromNib{
    self.collectionView.collectionViewLayout = [[[LHLineLayout alloc] init] autorelease];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LHImageCell" bundle:nil] forCellWithReuseIdentifier:@"hello"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"hello";
    LHImageCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    Cell.file = self.multimedias[indexPath.item];
    return Cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.multimedias.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)editHomework:(id)sender {
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        if ([self.delegate respondsToSelector:@selector(didClickEditButtonWithShowHomeworkView:)]){
            [self.delegate didClickEditButtonWithShowHomeworkView:self];
        }
    }
}

- (void)setHomeworkModel:(NewhomeWorkModel *)homeworkModel{
    if (_homeworkModel != homeworkModel) {
        [_homeworkModel release];
        _homeworkModel = [homeworkModel retain];
        self.multimedias = _homeworkModel.homework_moment.multimedias;
        self.content_label.text = _homeworkModel.homework_moment.text;
        [self.collectionView reloadData];
    }
}
- (void)dealloc {
    self.photos = nil;
    [_collectionView release];
    [_content_label release];
    
    self.homeworkModel = nil;
    [super dealloc];
}
@end
