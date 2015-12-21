/* UIDigitButton.m
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */             

#import "UIDigitButton.h"
//#import "ABUtil.h"
#import "WowTalkVoipIF.h"
//#import "PhonePadVC.h"
//#import "WowtalkAppDelegate.h"
#import "UICallButton.h"
@implementation UIDigitButton

@synthesize mAddress,mPhonePadVC;



-(void) touchDown:(id) sender {

	
	if (self.mAddress) 
    {
//        if ([[[[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] call] titleLabel] text] != @"") {
//              [[[[wowtalkAppDelegate sharedAppDelegate] myPhonePadVC] call] setTitle:@"" forState:UIControlStateNormal];
//        }
      
		NSString* newAddress = [NSString stringWithFormat:@"%@%c",self.mAddress.text,mDigit];
		[self.mAddress setText:newAddress];
        
//        if (self.mPhonePadVC != nil && [self.mPhonePadVC respondsToSelector:@selector(inputtextDidChanged)]) {
//            
//            [self.mPhonePadVC inputtextDidChanged];
//            
//        }
        
        //? what is this?  Elvis
        [WowTalkVoipIF fPlayDTMF:mDigit];
        
		if (mDigit == '0') {
			//start timer for +
			[self performSelector:@selector(doKeyZeroLongPress) withObject:nil afterDelay:0.5];
		}
		
	} 
	
//      [self setBackgroundColor:[Theme sharedInstance].currentTileColor];
		
}

-(void) touchUp:(id) sender {
	

	[WowTalkVoipIF fStopDTMP];
	

//    [self setBackgroundColor:[Theme sharedInstance].currentDigitButtonColor];
    
	
	if (mDigit == '0') {
		//cancel timer for +
		[NSObject cancelPreviousPerformRequestsWithTarget:self 
												 selector:@selector(doKeyZeroLongPress)
												   object:nil];
	} 
	
	
}

-(void)doKeyZeroLongPress {
	NSString* newAddress = [[self.mAddress.text substringToIndex: [self.mAddress.text length]-1]  stringByAppendingString:@"+"];
	[self.mAddress setText:newAddress];
    
    if (self.mPhonePadVC != nil && [self.mPhonePadVC respondsToSelector:@selector(inputtextDidChanged)]) {
        
//        [self.mPhonePadVC inputtextDidChanged];
        
    }
	
}

-(void) initWithNumber:(char)digit {
	[self initWithNumber:digit addressField:nil];
}

-(void) initWithNumber:(char)digit  addressField:(UILabel*) address{
	mDigit=digit ;
	self.mAddress=address;
    
    
//	[self setImage:[[Theme sharedInstance] pngImageWithName:[NSString stringWithFormat:@"%c",digit]] forState:UIControlStateNormal];
//    [self setBackgroundColor:[Theme sharedInstance].currentDigitButtonColor];
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];

}


-(void) initWithNumber:(char)digit addressField:(UILabel*) address controller:(PhonePadVC*) phonePadVC
{
    self.mPhonePadVC = phonePadVC;
    [self initWithNumber:digit  addressField:address];
    
}


- (void)dealloc {
	[mAddress release];
    [mPhonePadVC release];

    [super dealloc];

}


@end
