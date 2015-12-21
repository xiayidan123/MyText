//
//  ExplainView.h
//  dev01
//
//  Created by Huan on 15/5/19.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ExplainViewDelegate <NSObject>

- (void)getExplainText:(UITextView *)textView;

@end



@interface ExplainView : UIView

@property (assign, nonatomic) id<ExplainViewDelegate> delegate;

@property (copy, nonatomic) NSString * old_text;

@end
