//
//  CustomNavigationBar.m
//  wowcard
//
//  Created by coca on 12/05/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AppDelegate.h"
@implementation CustomNavigationBar

+ (UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)aRootViewController
{ 

        
    //! load nib named the same as our custom class
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    //! get navigation controller from our xib and pass it the root view controller
    UINavigationController *navigationController = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    [navigationController setViewControllers:[NSArray arrayWithObject:aRootViewController] animated:NO];
    

   // navigationController.navigationBar.tintColor = [UIColor redColor];
    return navigationController;

}

- (void)drawRect:(CGRect)rect
{
    


    UIColor *color = [[AppDelegate sharedAppDelegate].tabbarVC getSelectedTabColor];
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color  CGColor]));
    CGContextFillRect(context, rect);
     
//    UIImage *image = [PublicFunctions strecthableImage:NAVIGATIONBAR_BACKGROUND_IMAGE];
//    [image drawInRect:rect];
    

}



@end
