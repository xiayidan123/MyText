//
//  CommentListVC.h
//  dev01
//
//  Created by Huan on 15/5/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@protocol CommentListVCDelegate <NSObject>

- (void)getCommentContent:(NSString *)comment;

@end



@interface CommentListVC : OMViewController
@property (assign, nonatomic) id<CommentListVCDelegate> delegate;
@end
