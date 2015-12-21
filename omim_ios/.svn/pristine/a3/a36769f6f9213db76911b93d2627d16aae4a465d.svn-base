/* UIDigitButton.h
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */            
#import <UIKit/UIKit.h>



@class PhonePadVC;




@interface UIDigitButton : UIButton {
@private
	char  mDigit;

   
}

@property (nonatomic,retain) UILabel* mAddress;
@property (nonatomic,retain)  PhonePadVC* mPhonePadVC;

-(void) initWithNumber:(char)digit ;
-(void) initWithNumber:(char)digit addressField:(UILabel*) address;


-(void) initWithNumber:(char)digit addressField:(UILabel*) address controller:(PhonePadVC*) phonePadVC;

@end
