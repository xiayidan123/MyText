//
//  ClassMessageViewController.h
//  dev01
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyclassinformationCell;
@protocol  ClassMessageViewControllerDelegate <NSObject>

-(void)textWithTerm:(NSString *)term andGrade:(NSString*)grade andSubject:(NSString *)subject andDate:(NSString *)date andTime:(NSString *)time andPlace:(NSString *)place;

@end

@interface ClassMessageViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *term;
@property (retain, nonatomic) IBOutlet UITextView *grade;

@property (retain, nonatomic) IBOutlet UITextView *subject;
@property (retain, nonatomic) IBOutlet UITextView *date;
@property (retain, nonatomic) IBOutlet UITextView *time;
@property (retain, nonatomic) IBOutlet UITextView *place;
@property(nonatomic,assign)id<ClassMessageViewControllerDelegate>delegate;
@end
