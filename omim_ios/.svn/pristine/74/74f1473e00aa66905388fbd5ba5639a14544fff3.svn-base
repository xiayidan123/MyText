//
//  ScrollButton.m
//  wallpapers
//
//  Created by Harry on 12-10-4.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import "ScrollButton.h"
#import "Constants.h"

@implementation ScrollButton

@synthesize delegate;
@synthesize selected;
@synthesize titleLabel;
@synthesize contentImage;
@synthesize isAnime;
@synthesize isExpression;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        contentImage.backgroundColor = [UIColor clearColor];
        [self addSubview:contentImage];
        [contentImage release];
        
         isAnime = NO;
    }
    
    
    
    return self;
}

- (void)setSelected:(BOOL)select
{
    selected = select;
    
    if (selected)
    {
        
        self.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Colors blueColor];
       //    self.backgroundColor = [Theme sharedInstance].currentTileColor;
        
     //   titleLabel.textColor = [Theme sharedInstance].currentThemeColor;
    }
    else
    {
      //  self.backgroundColor = [Theme sharedInstance].currentBGColorForButtonInOperationContainer;
     //   titleLabel.textColor = [Theme sharedInstance].currentNormalTextColor;
        if (self.isExpression) {
            titleLabel.textColor = [UIColor blackColor]; 
        }
        else{
            titleLabel.textColor = [Colors grayColorFour];
        }
        self.backgroundColor = [UIColor clearColor];
       
    }
}

- (void)longPress
{
    isLongPress = YES;
    [delegate longPressScrollButton:self];
    [timer invalidate];
    timer = nil;
}

- (void)releaseButton
{
    [delegate releaseScrollButton:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isAnime)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(longPress) userInfo:nil repeats:NO];
    
    
    if (isExpression) {
    //     self.backgroundColor = [Colors blueColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    if (isExpression) {
   //     self.backgroundColor = [Colors grayColorThree];
    }
    
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (!isLongPress)
    {
        [delegate selectScrollButton:self];
    }
    else
    {
        isLongPress = NO;
        [self performSelector:@selector(releaseButton) withObject:nil afterDelay:0.0f];
    }
    
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isExpression) {
   //     self.backgroundColor = [Colors grayColorThree];
    }
    
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (isLongPress)
    {
        isLongPress = NO;
        [delegate releaseScrollButton:self];
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

@end
