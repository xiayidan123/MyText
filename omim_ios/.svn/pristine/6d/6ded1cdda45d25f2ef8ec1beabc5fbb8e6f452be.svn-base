//
//  TextFieldAlertView.m
//  omim
//
//  Created by elvis on 2013/05/07.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "TextFieldAlertView.h"

@implementation TextFieldAlertView
@synthesize textField;
@synthesize enteredText;


- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder message:(NSString *)message delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle {
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        self.title      = title;
        self.message      = [NSString stringWithFormat:@"%@\n\n\n",message];
        self.delegate    = delegate;
        
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0f, 260.0, 30.0)];
        [theTextField setBackgroundColor:[UIColor clearColor]];
        theTextField.borderStyle = UITextBorderStyleRoundedRect;
        theTextField.textColor = [UIColor whiteColor];
        theTextField.font = [UIFont systemFontOfSize:18.0];
        theTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        theTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        theTextField.returnKeyType = UIReturnKeyDone;
        theTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        theTextField.placeholder = placeholder;
        theTextField.delegate = self;
        [self insertSubview:theTextField atIndex:0];
        self.textField = theTextField;
        [theTextField release];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -10);
        [self setTransform:translate];
    }
    return self;
}

- (void)show{
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText{
    return textField.text;
}

- (void)dealloc{
    [textField resignFirstResponder];
    [textField release];
    [super dealloc];
}


@end
