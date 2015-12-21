

#import "PicVoiceMsgProgressView.h"

@implementation PicVoiceMsgProgressView

-(id) init
{
    return [self initWithProgressViewStyle:UIProgressViewStyleDefault];
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
	if(self=[super initWithCoder: aDecoder])
	{
        self.alpha = 0.6;
        self.trackTintColor = [UIColor whiteColor];
        self.progressTintColor = [UIColor greenColor];
		[self setTintColor: [UIColor whiteColor]];
	}
	return self;
}

- (id) initWithProgressViewStyle: (UIProgressViewStyle) style
{
	if(self=[super initWithProgressViewStyle: style])
	{
        self.alpha = 0.6;
        self.trackTintColor = [UIColor whiteColor];
        self.progressTintColor = [UIColor greenColor];
        [self setTintColor: [UIColor whiteColor]];

	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{	
	if([self progressViewStyle] == UIProgressViewStyleDefault)
	{
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		

		CGContextAddRect(ctx, rect);
		CGContextClip(ctx);
		
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
		CGContextFillRect(ctx, rect);
	
		//draw lower gray line
		CGContextSetRGBStrokeColor(ctx, 255.0/255.0, 255/255.0, 255/255.0, 0.9);
		CGContextSetLineWidth(ctx, 2);
		CGContextMoveToPoint(ctx, 2.2, rect.size.height);
		CGContextAddLineToPoint(ctx, rect.size.width - 2.2, rect.size.height);
		CGContextStrokePath(ctx);
		
		//fill upperhalf with light grey
		CGRect upperhalf = rect;
		upperhalf.size.height /= 1.75;
		upperhalf.origin.y = 0;
		
		CGContextSetRGBFillColor(ctx, 255.0/255.0, 255.0/255.0, 255/255.0, 0.9);
		CGContextFillRect(ctx, upperhalf);
		
		//fill a part of the upper half with a somewhat darker grey
		CGRect upperhalfTop = upperhalf;
		upperhalfTop.size.height /= 2.7;
		CGContextSetRGBFillColor(ctx, 255.0/255.0, 255/255.0, 255.0/255.0, 0.8);
		CGContextFillRect(ctx, upperhalfTop);
	
			
		CGRect progressRect = rect;
		progressRect.size.width *= [self progress];
		
			CGContextAddRect(ctx, progressRect);
		CGContextClip(ctx);
		
		CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
		CGContextFillRect(ctx, progressRect);
		
		progressRect.size.width -= 1.25;
		progressRect.origin.x += 0.625;
		progressRect.size.height -= 1.25;
		progressRect.origin.y += 0.625;
		
			CGContextAddRect(ctx, progressRect);
        
		CGContextClip(ctx);
		CGContextSetLineWidth(ctx, 1);
		CGContextSetRGBStrokeColor(ctx, 255/255.0, 255/255.0, 255/255.0, 0.6);
		CGContextStrokeRect(ctx, progressRect);
		
		}
	else
	{

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

- (void) setProgress:(CGFloat)newProgress animated:(BOOL)animated
{
 //   NSLog(@"progress:%f",newProgress);
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
