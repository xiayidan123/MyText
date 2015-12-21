//
//  PDColoredProgressView.m
//  PDColoredProgressViewDemo
//
//  Created by Pascal Widdershoven on 03-01-09.
//  Copyright 2009 Pascal Widdershoven. All rights reserved.
//  

#import "PDColoredProgressView.h"
//#import "Drawing.mm"

@implementation PDColoredProgressView

-(id) init
{
    return [self initWithProgressViewStyle:UIProgressViewStyleDefault];
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
	if(self=[super initWithCoder: aDecoder])
	{
		[self setTintColor: [UIColor colorWithRed: 43.0/255.0 green: 134.0/255.0 blue: 225.0/255.0 alpha: 1]];
	}
	return self;
}

- (id) initWithProgressViewStyle: (UIProgressViewStyle) style
{
	if(self=[super initWithProgressViewStyle: style])
	{
		[self setTintColor: [UIColor colorWithRed: 43.0/255.0 green: 134.0/255.0 blue: 225.0/255.0 alpha: 1]];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{	
	if([self progressViewStyle] == UIProgressViewStyleDefault)
	{
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		//draw first white layer
		//addRoundedRectToPath(ctx, rect, 4, 4);
   //     float fw, fh;
        // If the width or height of the corner oval is zero, then it reduces to a right angle,
        // so instead of a rounded rectangle we have an ordinary one.
        //	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(ctx, rect);
//		return;
//        //	}
//        
//        //  Save the context's state so that the translate and scale can be undone with a call
//        //  to CGContextRestoreGState.
//        CGContextSaveGState(ctx);
//        
//        //  Translate the origin of the contex to the lower left corner of the rectangle.
//        CGContextTranslateCTM(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
//        
//        //Normalize the scale of the context so that the width and height of the arcs are 1.0
//        CGContextScaleCTM(ctx, 4, 4);
//        
//        // Calculate the width and height of the rectangle in the new coordinate system.
//        fw = CGRectGetWidth(rect) / 4;
//        fh = CGRectGetHeight(rect) / 4;
//        
//        // CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
//        // corners).  It also adds a line from the path's last point to the begining of the arc, making
//        // the sides of the rectangle.
//        CGContextMoveToPoint(ctx, fw, fh/2);  // Start at lower right corner
//        CGContextAddArcToPoint(ctx, fw, fh, fw/2, fh, 1);  // Top right corner
//        CGContextAddArcToPoint(ctx, 0, fh, 0, fh/2, 1); // Top left corner
//        CGContextAddArcToPoint(ctx, 0, 0, fw/2, 0, 1); // Lower left corner
//        CGContextAddArcToPoint(ctx, fw, 0, fw, fh/2, 1); // Back to lower right
//        
//        // Close the path
//        CGContextClosePath(ctx);
//        
//        // Restore the context's state. This removes the translation and scaling
//        // but leaves the path, since the path is not part of the graphics state.
//        CGContextRestoreGState(ctx);
		CGContextClip(ctx);
		
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
		CGContextFillRect(ctx, rect);
	
		//draw lower gray line
		CGContextSetRGBStrokeColor(ctx, 178.0/255.0, 178.0/255.0, 178.0/255.0, 0.9);
		CGContextSetLineWidth(ctx, 2);
		CGContextMoveToPoint(ctx, 2.2, rect.size.height);
		CGContextAddLineToPoint(ctx, rect.size.width - 2.2, rect.size.height);
		CGContextStrokePath(ctx);
		
		//fill upperhalf with light grey
		CGRect upperhalf = rect;
		upperhalf.size.height /= 1.75;
		upperhalf.origin.y = 0;
		
		CGContextSetRGBFillColor(ctx, 202.0/255.0, 202.0/255.0, 202.0/255.0, 0.9);
		CGContextFillRect(ctx, upperhalf);
		
		//fill a part of the upper half with a somewhat darker grey
		CGRect upperhalfTop = upperhalf;
		upperhalfTop.size.height /= 2.7;
		CGContextSetRGBFillColor(ctx, 163.0/255.0, 163.0/255.0, 163.0/255.0, 0.8);
		CGContextFillRect(ctx, upperhalfTop);
	
		//fill the progress part with our tintcolor
		//if(_tintColor == nil)
		//	_tintColor = [UIColor colorWithRed: 43.0/255.0 green: 134.0/255.0 blue: 225.0/255.0 alpha: 1];
		
		CGRect progressRect = rect;
		progressRect.size.width *= [self progress];
		
		//addRoundedRectToPath(ctx, progressRect, 4, 4);
        
        //float fw, fh;
        // If the width or height of the corner oval is zero, then it reduces to a right angle,
        // so instead of a rounded rectangle we have an ordinary one.
        //	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(ctx, progressRect);
//		return;
//        //	}
//        
//        //  Save the context's state so that the translate and scale can be undone with a call
//        //  to CGContextRestoreGState.
//        CGContextSaveGState(ctx);
//        
//        //  Translate the origin of the contex to the lower left corner of the rectangle.
//        CGContextTranslateCTM(ctx, CGRectGetMinX(progressRect), CGRectGetMinY(progressRect));
//        
//        //Normalize the scale of the context so that the width and height of the arcs are 1.0
//        CGContextScaleCTM(ctx, 4, 4);
//        
//        // Calculate the width and height of the rectangle in the new coordinate system.
//        fw = CGRectGetWidth(progressRect) / 4;
//        fh = CGRectGetHeight(progressRect) / 4;
//        
//        // CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
//        // corners).  It also adds a line from the path's last point to the begining of the arc, making
//        // the sides of the rectangle.
//        CGContextMoveToPoint(ctx, fw, fh/2);  // Start at lower right corner
//        CGContextAddArcToPoint(ctx, fw, fh, fw/2, fh, 1);  // Top right corner
//        CGContextAddArcToPoint(ctx, 0, fh, 0, fh/2, 1); // Top left corner
//        CGContextAddArcToPoint(ctx, 0, 0, fw/2, 0, 1); // Lower left corner
//        CGContextAddArcToPoint(ctx, fw, 0, fw, fh/2, 1); // Back to lower right
//        
//        // Close the path
//        CGContextClosePath(ctx);
//        
//        // Restore the context's state. This removes the translation and scaling
//        // but leaves the path, since the path is not part of the graphics state.
//        CGContextRestoreGState(ctx);
		CGContextClip(ctx);
		
		CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
		CGContextFillRect(ctx, progressRect);
		
		progressRect.size.width -= 1.25;
		progressRect.origin.x += 0.625;
		progressRect.size.height -= 1.25;
		progressRect.origin.y += 0.625;
		
		//addRoundedRectToPath(ctx, progressRect, 4, 4);
        //float fw, fh;
        // If the width or height of the corner oval is zero, then it reduces to a right angle,
        // so instead of a rounded rectangle we have an ordinary one.
        //	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(ctx, progressRect);
//		return;
//        //	}
//        
//        //  Save the context's state so that the translate and scale can be undone with a call
//        //  to CGContextRestoreGState.
//        CGContextSaveGState(ctx);
//        
//        //  Translate the origin of the contex to the lower left corner of the rectangle.
//        CGContextTranslateCTM(ctx, CGRectGetMinX(progressRect), CGRectGetMinY(progressRect));
//        
//        //Normalize the scale of the context so that the width and height of the arcs are 1.0
//        CGContextScaleCTM(ctx, 4, 4);
//        
//        // Calculate the width and height of the rectangle in the new coordinate system.
//        fw = CGRectGetWidth(progressRect) / 4;
//        fh = CGRectGetHeight(progressRect) / 4;
//        
//        // CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
//        // corners).  It also adds a line from the path's last point to the begining of the arc, making
//        // the sides of the rectangle.
//        CGContextMoveToPoint(ctx, fw, fh/2);  // Start at lower right corner
//        CGContextAddArcToPoint(ctx, fw, fh, fw/2, fh, 1);  // Top right corner
//        CGContextAddArcToPoint(ctx, 0, fh, 0, fh/2, 1); // Top left corner
//        CGContextAddArcToPoint(ctx, 0, 0, fw/2, 0, 1); // Lower left corner
//        CGContextAddArcToPoint(ctx, fw, 0, fw, fh/2, 1); // Back to lower right
//        
//        // Close the path
//        CGContextClosePath(ctx);
//        
//        // Restore the context's state. This removes the translation and scaling
//        // but leaves the path, since the path is not part of the graphics state.
//        CGContextRestoreGState(ctx);
        
		CGContextClip(ctx);
		CGContextSetLineWidth(ctx, 1);
		CGContextSetRGBStrokeColor(ctx, 20.0/255.0, 20.0/255.0, 20.0/255.0, 0.6);
		CGContextStrokeRect(ctx, progressRect);
		
		//draw white linear gradient over upperhalf
	//	CGFloat colors[8] = {
	//		1, 1, 1, 0.45,
//			1, 1, 1, 0.75
//		};
		
	//	fillRectWithLinearGradient(ctx, upperhalf, colors, 2, nil);
	}
	else
	{

        NSLog(@"calling the draw rect directly in pdcolored progess");
		[super drawRect: rect];
	}
}

- (void) setTintColor: (UIColor *) aColor
{
	[_tintColor release];
	_tintColor = [aColor retain];
}

- (void) moveProgress
{
    if (self.progress < _targetProgress)
	{
        self.progress = MIN(self.progress + 0.01, _targetProgress);
    }
    else if(self.progress > _targetProgress)
    {
        self.progress = MAX(self.progress - 0.01, _targetProgress);
    }
    else
	{
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

/*
-(void)setProgress:(CGFloat)newProgress
{
     NSLog(@"progress:%f",newProgress);
  
    self.progress = newProgress;

}
*/
- (void) setProgress:(CGFloat)newProgress animated:(BOOL)animated
{
    //NSLog(@"progress:%f",newProgress);
    if (animated)
	{
        _targetProgress = newProgress;
        if (_progressTimer == nil)
		{
            _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
        }
    }
	else
	{
        self.progress = newProgress;
    }
}

- (void) dealloc
{
    [super dealloc];
	[_tintColor release];
}


@end
