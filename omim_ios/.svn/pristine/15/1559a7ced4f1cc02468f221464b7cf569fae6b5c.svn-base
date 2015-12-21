//
//  CustomActionSheet.m
//  omim
//
//  Created by Harry on 14-1-31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "CustomActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDateFormatterGregorianCalendar.h"
#define kDuration 0.3
#define TAG_GROUPTYPE_PICKER 15

@implementation CustomActionSheet

@synthesize array;
@synthesize genderPicker;
@synthesize datePicker;
@synthesize selectedGender;
@synthesize isPicker;
@synthesize age;
@synthesize grouptypePicker = _grouptypePicker;
@synthesize isGroupTypePicker = _isGroupTypePicker;
@synthesize chosenType = _chosenType;
@synthesize initialDate = _initialDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title isDatePicker:(BOOL)isDatePicker delegate:(id)delegate
{
    self.isPicker = isDatePicker;
    self.selectedGender = @"0";
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    
    //创建工具栏
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
	UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"OK",nil) style:UIBarButtonItemStyleDone target:self action:@selector(locate:)];
    [confirmBtn setTintColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1]];
    
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Cancel",nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    [cancelBtn setTintColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1]];
    
    [items addObject:cancelBtn];
    [items addObject:flexibleSpaceItem];
    [items addObject:confirmBtn];
    
    [cancelBtn release];
    [flexibleSpaceItem release];
    [confirmBtn release];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolBar.hidden = NO;
    toolBar.items = items;
    [items release];
    items = nil;
    toolBar.barTintColor = [UIColor whiteColor];
    toolBar.translucent = NO;
    [self addSubview:toolBar];
    [toolBar release];
    
    if (isDatePicker) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        [datePicker setTag:11];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        if (IS_IOS7) {
            datePicker.backgroundColor = [UIColor whiteColor];
        }
        [self addSubview:datePicker];
    } else {
        genderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        genderPicker.showsSelectionIndicator = YES;
        
        if (IS_IOS7) {
            genderPicker.backgroundColor = [UIColor whiteColor];
        }
        
        [genderPicker setTag:12];
        self.genderPicker.dataSource = self;
        self.genderPicker.delegate = self;
        [self addSubview:genderPicker];
    }
    
    self.delegate = delegate;
    
    self.array = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Male",nil), NSLocalizedString(@"Female",nil) , NSLocalizedString(@"Secret",nil), nil];
    
    return self;
}

-  (id)initGroupPickerWithInitialChoice:(NSString*)choice  delegate:(id)delegate
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    
    //创建工具栏
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
	UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"OK",nil) style:UIBarButtonItemStyleDone target:self action:@selector(locate:)];
    
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Cancel",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    
    [items addObject:cancelBtn];
    [items addObject:flexibleSpaceItem];
    [items addObject:confirmBtn];
    
    [cancelBtn release];
    [flexibleSpaceItem release];
    [confirmBtn release];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolBar.hidden = NO;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = items;
    [items release];
    items = nil;
    
    [self addSubview:toolBar];
    [toolBar release];
    
    _grouptypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    _grouptypePicker.showsSelectionIndicator = YES;
    
    [_grouptypePicker setTag:TAG_GROUPTYPE_PICKER];
    _grouptypePicker.dataSource = self;
    _grouptypePicker.delegate = self;
    [self addSubview:_grouptypePicker];
    [_grouptypePicker release];
    
    
    if (IS_IOS7) {
        _grouptypePicker.backgroundColor = [UIColor whiteColor];
    }
    
    self.isGroupTypePicker = TRUE;

    self.delegate = delegate;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GroupType" ofType:@"plist"];
    NSDictionary *usertypeDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    
    
    self.array = [usertypeDict allValues];
    self.chosenType = choice;
    
    return self;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)] autorelease];
    
    [label setText:[self.array objectAtIndex:row]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"CustomActionSheet"];
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
}

-(NSString *)initialDate{
    return _initialDate;
}

-(void)setInitialDate:(NSString *)initialDate{
    _initialDate = initialDate;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate* myDate = [dateFormatter dateFromString:initialDate];
    [datePicker setDate:myDate];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [array count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [array objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.isGroupTypePicker) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GroupType" ofType:@"plist"];
        NSDictionary *usertypeDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        self.chosenType = [[usertypeDict allKeys] objectAtIndex:row];

    }
    else{
        
        switch (row) {
            case 0:
                self.selectedGender = @"0";
                break;
            case 1:
                self.selectedGender = @"1";
                break;
            default:
                self.selectedGender = @"2";
                break;
        }
    }
}


#pragma mark - Button lifecycle

- (void)cancel:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"CustomActionSheet"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:2];
    }
    
}

- (void)locate:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"CustomActionSheet"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    
    
    if (isPicker) {
        self.age = [self age:[self.datePicker date]];
        if(self.delegate) {
            [self.delegate actionSheet:self clickedButtonAtIndex:4];
        }
    }
    else if (self.isGroupTypePicker){
        if(self.delegate) {
            [self.delegate actionSheet:self clickedButtonAtIndex:5];
        }
    }
    else {
        if(self.delegate) {
            [self.delegate actionSheet:self clickedButtonAtIndex:3];
        }
    }
}

- (NSString *)age:(NSDate *)theDate
{
    // NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] initWithGregorianCalendar] autorelease];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *ageYear = [dateFormatter stringFromDate:theDate];
    //   NSString *nowYear = [dateFormatter stringFromDate:nowDate];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *ageMonth = [dateFormatter stringFromDate:theDate];
    //  NSString *nowMonth = [dateFormatter stringFromDate:nowDate];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *ageDay = [dateFormatter stringFromDate:theDate];
    //  NSString *nowDay = [dateFormatter stringFromDate:nowDate];
    
    
    return [NSString stringWithFormat:@"%@-%@-%@", ageYear, ageMonth, ageDay];
    
}

- (void)dealloc
{
    [selectedGender release];
    [age release];
    [datePicker release];
    [array release];
    [genderPicker release];
    [super dealloc];
}

@end
