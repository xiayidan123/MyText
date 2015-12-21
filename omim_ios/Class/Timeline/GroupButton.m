//
//  GroupButton.m
//  wowtalkbiz
//
//  Created by elvis on 2013/10/03.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "GroupButton.h"
#import "UILabel+Size.h"
#import "Colors.h"

@implementation GroupButton
@synthesize buttontext = _buttontext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[Colors wowtalkbiz_blue]];
        
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:frame];
        imageview.image = [UIImage imageNamed:@"table_delete_department.png"];
        imageview.tag = 1;
        [self addSubview:imageview];
        [imageview release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 2;
        label.backgroundColor = [UIColor clearColor];

        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        label.minimumScaleFactor = 7;
        label.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:label];
        [label release];
        
        [self addTarget:self action:@selector(deleteTheGroup:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setButtontext:(NSString *)buttontext
{
    UILabel* label = (UILabel*)[self viewWithTag:2];
    UIImageView* imageview = (UIImageView*)[self viewWithTag:1];
    
    _buttontext = buttontext;

    CGFloat width = [UILabel labelWidth:buttontext FontType:17 withInMaxWidth:220];
    [label setFrame:CGRectMake(10, 0, width+10, 30)];
    label.text = buttontext;
    
    if (self.isNotEditable) {
        imageview.hidden = TRUE;
        label.textAlignment = NSTextAlignmentCenter;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, label.frame.origin.x+label.frame.size.width +10 , 30)];
    }
    else{
        imageview.hidden = FALSE;
        label.textAlignment = NSTextAlignmentLeft;
        [imageview setFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 9, 12, 12)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageview.frame.origin.x+imageview.frame.size.width +10 , 30)];
    }
}

-(NSString*)buttontext
{
    return _buttontext;
}

-(void)deleteTheGroup:(id)sender{
    if (self.isNotEditable) {
        return;
    }
    if (self.delegate&& [self.delegate respondsToSelector:@selector(deleteThisGroup:)]) {
        [self.delegate deleteThisGroup:self];
    }
}

@end