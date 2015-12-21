//
//  UILabel+Size.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UILabel+Size.h"

@implementation UILabel (Size)

+(CGFloat) labelHeight:(NSString *) text FontType:(int) type withInMaxWidth:(CGFloat)width
{
    if (text == nil) {
        return 0;
    }
    if ([text length] == 0){
		return 0;
	}
	if (IS_IOS7) {
        // Note: doesn't work with attributed string.
        CGSize maximumLabelSize = CGSizeMake(width, 9999);
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:type] forKey: NSFontAttributeName];
        CGRect size = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:Nil];
        return size.size.height;
    }
    else{
        
        CGSize maximumLabelSize = CGSizeMake(width, 9999);
        CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:type]
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:UILineBreakModeClip];
        return expectedLabelSize.height;
    }
	
}


+(CGFloat) labelWidth:(NSString *)text FontType:(int) type withInMaxWidth:(CGFloat)width
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
        CGSize maximumLabelSize = CGSizeMake(9999,type);
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:type] forKey: NSFontAttributeName];
        CGRect size = [result boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:Nil];
      //  NSLog(@"%f, %f",size.size.width,size.size.height);
        return (size.size.width< width)?size.size.width:width;
    }
    else{
        
        CGSize maximumLabelSize = CGSizeMake(9999,type); //TO CHECK ELVIS.
        CGSize expectedLabelSize = [result sizeWithFont:[UIFont systemFontOfSize:type]
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:UILineBreakModeClip ];
        
        return (expectedLabelSize.width< width)?expectedLabelSize.width:width;
    }
}

@end
