//
//  StatusBar.m
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "StatusBar.h"

#define VIEW_STATUS_TAG  1

@implementation StatusBar


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{ 
		self.windowLevel = UIWindowLevelStatusBar + 1;  // seems this will add itself on the windows.
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = TRUE;
	}
    
	return self;
}


+(id)sharedStatusBar
{
    @synchronized(self)
    {
        static StatusBar *statusBar = nil;
        
        if (statusBar == nil)
        {
            statusBar = [[StatusBar alloc]initWithFrame:CGRectZero];
            
            [statusBar setExclusiveTouch:TRUE] ;
            
        }
        return statusBar;
    }
}

-(void)showMsgInStatusBar:(NSString*)strMsg
{
    if(strMsg==nil || [strMsg isEqualToString:@""]){
        return;
    }
    
    self.hidden = FALSE;
    @synchronized(self)
    {
        UIView *viewStatus = [self viewWithTag:VIEW_STATUS_TAG];
        
        if (viewStatus) {
            [viewStatus removeFromSuperview];
            
        }
        
        
        viewStatus = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 130,
                                                             0,
                                                             130,
                                                             self.frame.size.height)];
        
        viewStatus.tag = VIEW_STATUS_TAG;
        
        [viewStatus setBackgroundColor:[UIColor blackColor]];
        [viewStatus setClipsToBounds:TRUE];
        [self addSubview:viewStatus];
        [viewStatus release];
        
        UILabel *labelMsg = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     viewStatus.frame.size.width,
                                                                     0)];
        
        labelMsg.text = strMsg;
        
        labelMsg.textColor = [UIColor whiteColor];
        labelMsg.font = [UIFont boldSystemFontOfSize:12];
        labelMsg.backgroundColor = [UIColor clearColor];
        labelMsg.textAlignment = NSTextAlignmentRight;
        
        [viewStatus addSubview:labelMsg];
        [labelMsg release];
        
        [UIView animateWithDuration:0.5 animations:^
         {
             viewStatus.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 130,
                                           0,
                                           130,
                                           self.frame.size.height);
             
             labelMsg.frame = CGRectMake(0,0,viewStatus.frame.size.width, self.frame.size.height);
         }
            completion:^(BOOL finished){
                   
                [UIView animateWithDuration:0.5  delay:2.0 options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                              labelMsg.frame = CGRectMake(0,self.frame.size.height * (-1),viewStatus.frame.size.width, self.frame.size.height);
                             viewStatus.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 130,
                                                           self.frame.size.height * (-1),
                                                           130,
                                                           self.frame.size.height);
                             
            
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [viewStatus removeFromSuperview];
                             
                             [self removeFromSuperview];
                             self.hidden = TRUE;
                             
                             
                         }];
                
         }];
  

        
        
    }
    
}


-(void)showIncomingMessageOnStatus:(NSString*)msg
{
    [self showWithStatusMessage:msg withDuration:3.0f withImage:[UIImage imageNamed:@"tab_chat.png"] ];
}

-(void)showWithStatusMessage:(NSString*)msg withDuration:(CGFloat)duration withImage:(UIImage *)image
{
    self.hidden = FALSE;
    @synchronized(self)
    {
        
        if (!msg)
            return;
        
        UIView *viewStatus = [self viewWithTag:VIEW_STATUS_TAG];
        
        if (viewStatus) {
            [viewStatus removeFromSuperview];
            
        }
        
        viewStatus = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 130,
                                                             0,
                                                             130,
                                                             self.frame.size.height)];
        viewStatus.tag = VIEW_STATUS_TAG;
        
        [viewStatus setBackgroundColor:[UIColor blackColor]];
        [viewStatus setClipsToBounds:TRUE];
        [self addSubview:viewStatus];
        [viewStatus release];
        
        UIImageView *imageView = nil;
        if (image) {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2,
                                                                     self.frame.size.height,self.frame.size.height, self.frame.size.height)];
            
            imageView.image = image;
            
            [viewStatus addSubview:imageView];
            
            [imageView autorelease];
            
        }
        
        
        
        UILabel *labelMsg = [[UILabel alloc]initWithFrame:CGRectMake(2+imageView.frame.size.width,
                                                                     self.frame.size.height,
                                                                     viewStatus.frame.size.width -(4+imageView.frame.size.width) ,
                                                                     self.frame.size.height)];
        
        labelMsg.text = msg;
        
        labelMsg.textColor = [UIColor colorWithRed:0.74f green:0.74f blue:0.74f alpha:1.0f];
        labelMsg.font = [UIFont boldSystemFontOfSize:12];
        labelMsg.backgroundColor = [UIColor clearColor];
        labelMsg.textAlignment = NSTextAlignmentRight;
        
        [viewStatus addSubview:labelMsg];
        
        
        [labelMsg release];
        
        
        [UIView animateWithDuration:0.5 animations:^
         {
             imageView.frame = CGRectMake(2,0,self.frame.size.height, self.frame.size.height);
             
             
             labelMsg.frame =  CGRectMake(4+imageView.frame.size.width,
                                          0,
                                          viewStatus.frame.size.width -(8+imageView.frame.size.width) ,
                                          self.frame.size.height);
         }
                         completion:^(BOOL finished)
         {
             if (duration>0) {
                 [UIView animateWithDuration:0.5  delay:duration options:UIViewAnimationOptionLayoutSubviews
                                  animations:^
                  {
                      imageView.frame = CGRectMake(2,
                                                   self.frame.size.height*(-1),
                                                   self.frame.size.height,
                                                   self.frame.size.height);
                      
                      
                      labelMsg.frame =  CGRectMake(4+imageView.frame.size.width,
                                                   self.frame.size.height*(-1),
                                                   viewStatus.frame.size.width -(8+imageView.frame.size.width),
                                                   self.frame.size.height);
                  }
                                  completion:^(BOOL finished) {
                                      
                                      [viewStatus removeFromSuperview];
                                      
                                      self.hidden = TRUE;
                                      
                                  }];
             }
             
         }];
        
        
    }
}



@end
