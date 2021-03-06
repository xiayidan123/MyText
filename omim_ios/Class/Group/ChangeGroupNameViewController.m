//
//  ChangeGroupNameViewController.m
//  omim
//
//  Created by elvis on 2013/05/28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ChangeGroupNameViewController.h"
#import "WTHeader.h"
#import "Constants.h"
#import "PublicFunctions.h"

@interface ChangeGroupNameViewController ()
{
    UITextField* textfield;
}

@end

@implementation ChangeGroupNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    
    [self.tb_change setBackgroundView:nil];
    [self.tb_change setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 290, 44)];
    textfield.tag = 1;
    textfield.backgroundColor = [UIColor clearColor];
    textfield.textAlignment = NSTextAlignmentLeft;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.placeholder = self.oldGroupName;
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_change setFrame:CGRectMake(0, 0, self.tb_change.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [textfield becomeFirstResponder];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    [textfield resignFirstResponder];
}

-(void)confirm
{
    if ([NSString isEmptyString:textfield.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Group name can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeGroupNameTo:withRequestor:)]) {
        [self.delegate didChangeGroupNameTo:textfield.text withRequestor:self];
    }
    [self goBack];
    
}

-(void)configNav
{
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
//    UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(confirm)];
    UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavDoneButtonWithTarget:self selector:@selector(confirm)];
       [self.navigationItem addRightBarButtonItem:barButtonRight];
    [barButtonRight release];
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Group name",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return FALSE;
}


/*
 -(void)didChangeText:(UITextField*)textfield{
 self.nickname = textfield.text;
 }
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"editcell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editcell"] autorelease];
        [cell.contentView addSubview:textfield];
    }

    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
