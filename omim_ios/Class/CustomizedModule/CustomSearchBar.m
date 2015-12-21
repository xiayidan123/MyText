//
//  CustomSearchBar.m
//  omim
//
//  Created by coca on 2012/11/03.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "CustomSearchBar.h"
#import "Constants.h"

#import "WTHeader.h"

@implementation CustomSearchBar

@synthesize isBarShort;
@synthesize isActive;
@synthesize cancelButton;
@synthesize inputTextfield;
@synthesize customDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)layoutSubviews
{
    UITextField *searchField = nil;
    
    NSUInteger numViews = [self.subviews count];
    int pos;
    BOOL found = NO;
    for(int i = 0; i < numViews; i++)
    {
        if ([[self.subviews objectAtIndex:i] isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            pos = i;
            found = YES;
        }
        
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
        {
            searchField = [self.subviews objectAtIndex:i];
        }
        else
        {
            [[self.subviews objectAtIndex:i] setBackgroundColor:CURRENT_THEME_COLOR];
        }
        
    }
    
    if (found)
        [[self.subviews objectAtIndex:pos] removeFromSuperview];
    
    [super layoutSubviews];   // have to layout the super's  subviews here. otherwise the searchfield will be resized.
    
    self.cancelButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SEARCHBAR_CANCEL_BUTTON_WIDTH, SEARCHBAR_CANCEL_BUTTON_HEIGHT)] autorelease];
    [self.cancelButton setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    for(UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            self.cancelButton.frame = CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height);   // cover the default cancel button.
            [subView  addSubview:self.cancelButton];
        }
    }
    
    if(searchField != nil)
    {
        UIImage *image = [UIImage imageNamed:INPUT_FIELD_IMAGE];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width / 2) topCapHeight:floorf(image.size.height / 2)];
        
        if (self.isActive)
        {
            searchField.frame = CGRectMake(10, 3, self.frame.size.width - self.cancelButton.frame.size.width - 20, 38);
        }
        else
        {
            searchField.frame = CGRectMake(10, 3, self.frame.size.width - 38, 38);
        }
        
        [searchField setBackground:image];
        [searchField setBorderStyle:UITextBorderStyleNone];
        
        [searchField setValue:[Colors darkgrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        self.inputTextfield = searchField;
    }
}

- (void)cancelAction
{
    [self.customDelegate hitCustomCancelButton];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 
 UITextField *searchField;
 NSUInteger numViews = [self.subviews count];
 
 for(int i = 0; i < numViews; i++) {
 
 if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
 searchField = [self.subviews objectAtIndex:i];
 }
 }
 
 }
 */

@end
