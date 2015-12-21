//
//  TextFieldAlertView.h
//  omim
//
//  Created by elvis on 2013/05/07.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldAlertView : UIAlertView <UITextFieldDelegate>
{
    UITextField *textField;
     NSString *enteredText;
}
@property(nonatomic,retain) UITextField *textField;
@property (nonatomic, retain, readonly) NSString *enteredText;

- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder message:(NSString *)message delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle;



@end