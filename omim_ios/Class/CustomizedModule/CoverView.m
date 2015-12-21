//
//  CoverView.m
//  omim
//
//  Created by elvis on 2013/05/19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "CoverView.h"
#import "RotateIcon.h"

#define ROTATEBACK_ANIMATION_DURATION 2.0f


@interface CoverView (Private)

- (void)setState:(CoverViewState)aState;
@end

@implementation CoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.coverImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        [self.coverImage setImage:[UIImage imageNamed:@"default_cover.png"]];
        [self addSubview:self.coverImage];
        
        [self setState:CoverViewNormal];
    }
    return self;
}

- (void)setState:(CoverViewState)aState{
    
    
	switch (aState) {
		case CoverViewPulling:
			break;
            
		case CoverViewNormal:
			
			break;
		case CoverViewLoading:
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods
- (void)coverViewDidScroll:(UIScrollView *)scrollView
{

    if (self.autoScroll){
        
        [self setState:CoverViewLoading];
        
        if ([_delegate respondsToSelector:@selector(coverViewDidTriggerRefresh:)]) {
			[_delegate coverViewDidTriggerRefresh:self];
		}
       
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentOffset = self.refreshContentOffset;
		[UIView commitAnimations];

    }
    else{
        if (_state == CoverViewLoading) {
            
        }
        else if (scrollView.isDragging){
            BOOL _loading = NO;
            if ([_delegate respondsToSelector:@selector(coverViewDataSourceIsLoading:)]) {
                _loading = [_delegate coverViewDataSourceIsLoading:self];
            }
            
            if (_state == CoverViewPulling && scrollView.contentOffset.y > self.refreshContentOffset.y && scrollView.contentOffset.y < self.frame.size.height && !_loading) {
                [self setState:CoverViewNormal];
            }
            else if (_state == CoverViewNormal && scrollView.contentOffset.y < self.refreshContentOffset.y && !_loading) {
                if (!draggingEnded) {
                    [self setState:CoverViewPulling];
                }
                
            }
        }
    }
}
- (void)coverViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(coverViewDataSourceIsLoading:)]) {
		_loading = [_delegate coverViewDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= self.refreshContentOffset.y && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(coverViewDidTriggerRefresh:)]) {
			[_delegate coverViewDidTriggerRefresh:self];
		}
		
		[self setState:CoverViewLoading];
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentOffset = self.refreshContentOffset;
		[UIView commitAnimations];
	}
    else{
        draggingEnded = TRUE;
        
    }
    
}

- (void)coverViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentOffset:self.initialContentOffset];
	[UIView commitAnimations];
	
    self.autoScroll = FALSE;
    
	[self setState:CoverViewNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;

    self.coverImage = nil;

    [super dealloc];
}



@end
