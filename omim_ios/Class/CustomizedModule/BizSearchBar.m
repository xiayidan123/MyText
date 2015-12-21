//
//  BizSearchBar.m
//  dev01
//
//  Created by elvis on 2013/08/30.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "BizSearchBar.h"
#import "Colors.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "PublicFunctions.h"

@implementation BizSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    
    UITextField *searchField = nil;
    
    NSUInteger numViews = [self.subviews count];
    int pos;
    BOOL Found = FALSE;
    for(int i = 0; i < numViews; i++) {
        if ([[self.subviews objectAtIndex:i] isKindOfClass:NSClassFromString
             (@"UISearchBarBackground")]){
            pos = i;
            Found = TRUE;
        }
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]){
            searchField = [self.subviews objectAtIndex:i];
        }
        else{
   
            [[self.subviews objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];
           
        }
     //   [[[self.subviews objectAtIndex:i] layer] setBorderWidth:0];
    }
    
    if (Found){
        [[self.subviews objectAtIndex:pos] removeFromSuperview];
    }
    
    [super layoutSubviews];   // have to layout the super's  subviews here. otherwise the searchfield will be resized.
    self.backgroundColor = [Colors wowtalkbiz_searchbar_bg];
  //  UIButton* btn_cancle = nil;
    for(UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView setBackgroundColor:[UIColor clearColor]];
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [newLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [newLabel setBackgroundColor:[Colors wowtalkbiz_searchbar_cancle_btn_bg ]];
            [newLabel setTextColor:[UIColor whiteColor]];
         
            [newLabel.layer setCornerRadius:4.0];

            [newLabel setText:NSLocalizedString(@"Cancel",nil)];

            [newLabel setTextAlignment:NSTextAlignmentCenter];
            [newLabel setUserInteractionEnabled:NO];
            [subView addSubview:newLabel];
            [newLabel release];
            
        }
        
        [[subView layer] setBorderWidth:0];
    }
    
  
    if(searchField != nil) {
   /*     if (btn_cancle) {
            searchField.frame = CGRectMake(10,3,self.frame.size.width - self.btn_cancel.frame.size.width - 20,38);
        }
        else
        {
            searchField.frame = CGRectMake(10,3,self.frame.size.width - 38,38);
        }
     */   
        //  searchField.textColor = [Colors whiteColor];
        [searchField setBackground:[PublicFunctions strecthableImage:SMS_TEXT_INPUT_BG]];
        //  [searchField setBackgroundColor:[UIColor blackColor]];
        //    [searchField set]
        [searchField setBorderStyle:UITextBorderStyleNone];
        
        
        //  searchField.layer.borderWidth = 1;
        //  searchField.layer.borderColor = [[Colors darkgrayColor] CGColor];
        
        [searchField setValue:[Colors darkgrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        self.tf_inputbox = searchField;
        
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
-(void)cancelAction {
    [self.delegate customCancelButtonHit];
}
*/
@end
