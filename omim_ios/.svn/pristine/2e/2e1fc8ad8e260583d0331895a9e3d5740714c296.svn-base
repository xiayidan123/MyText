//
//  UITextView+Size.m
//  dev01
//
//  Created by coca on 14-6-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//


#import "UITextView+Size.h"

@implementation UITextView (Size)

+(CGFloat) txtWidth:(NSString *)text fontType:(int) type withInMaxWidth:(CGFloat)width
{
    if (text == nil) {
        return 0;
    }
    if ([text length] == 0) {
		return 0;
	}
	
    NSString* result;
    
    NSArray* strings = [text componentsSeparatedByString:@"\n"];
    
    if ([strings count] > 1) {
        NSInteger pos = 0;
        for (int i = 1; i<[strings count]; i++) {
            if ([(NSString*)[strings objectAtIndex:pos] length] < [(NSString*)[strings objectAtIndex:i] length]){
                pos = i;
            }
        }
        result = [strings objectAtIndex:pos];
    }
    
    else{
        result = text;
    }
    
    if (IS_IOS7) {
        // Note: doesn't work with attributed string.
        CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX,type);
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:type] forKey: NSFontAttributeName];
        CGRect rect = [result boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:Nil];
        float value =rect.size.width+16.0;
        return (value< width)?value:width;
    }
    else{
        
        CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX,type);
        CGSize expectedLabelSize = [result sizeWithFont:[UIFont systemFontOfSize:type+3]
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:UILineBreakModeClip ];
        
        return (expectedLabelSize.width< width)?expectedLabelSize.width:width;
    }
}

+(CGFloat) txtHeight:(NSString *)text fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    UITextView *detailTextView = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)] autorelease];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = text;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

@end
