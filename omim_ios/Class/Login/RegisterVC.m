//
//  RegisterVC.m
//

#import "RegisterVC.h"
#import "WTHeader.h"

#import "Constants.h"
#import "AppDelegate.h"

@implementation RegisterVC

@synthesize lblLogo;
@synthesize imgBG;
@synthesize accountTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize centerView;
@synthesize imgLogo ;
@synthesize authBackGroudImageView;

@synthesize btnBack;
@synthesize btnCreateAccount;
#pragma mark - View Handler

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(fResignFirstResponder:)];
    [tapRecognizer setDelegate:self];
    imgBG.userInteractionEnabled = YES;
    [imgBG addGestureRecognizer:tapRecognizer];
    
    
    self.oldCenterViewFrame = self.centerView.frame;
    
    
    lblLogo.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

    [authBackGroudImageView setImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [btnBack setBackgroundImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btnCreateAccount setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    [btnBack setTitle:NSLocalizedString(@"Return", nil) forState:UIControlStateNormal];
    [btnCreateAccount setTitle:NSLocalizedString(@"Create Account", nil) forState:UIControlStateNormal];
    [accountTextField setPlaceholder:NSLocalizedString(@"Username", nil)];
    [passwordTextField setPlaceholder:NSLocalizedString(@"Please input password", nil)];
    [confirmPasswordTextField setPlaceholder:NSLocalizedString(@"Please input password again", nil)];

    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [accountTextField becomeFirstResponder];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)dealloc
{
    [accountTextField release];
    [passwordTextField release];
    [confirmPasswordTextField release];
    [authBackGroudImageView release];
    [centerView release];
    [imgLogo release];
    [super dealloc];
}

- (IBAction)fResignFirstResponder:(id)sender
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}


#pragma mark - Functions

- (IBAction)fBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

- (IBAction)fCreateAccount:(id)sender
{
    BOOL rlt=YES;
    NSString* errMsg=@"";
    
    if (self.accountTextField.text == nil || self.accountTextField.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@ "Username can't be empty",nil);
    }
    else if (self.accountTextField.text.length < 2){
        rlt = NO;
        errMsg = NSLocalizedString(@ "Username needs to be 2 digits at least",nil);
    }
    else if (self.accountTextField.text.length > 20){
        rlt = NO;
        errMsg = NSLocalizedString(@ "Username needs to be 20 digits at most",nil);
    }
    else if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0 ){
        rlt = NO;
        errMsg = NSLocalizedString(@"Password can't be empty",nil);
    }
    else if (self.passwordTextField.text.length < 6){
        rlt = NO;
        errMsg = NSLocalizedString(@"Password needs to be 6 digits at leaset",nil);
    }
    else  if (self.confirmPasswordTextField.text == nil || ![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"Two passwords are different",nil);
    }else if (self.passwordTextField.text.length > 20){
        rlt = NO;
        errMsg = NSLocalizedString(@ "Password needs to be 20 digits at most",nil);
    }
    
    if(rlt==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
  //  [WTUserDefaults setWTID:self.accountTextField.text];

    [WowTalkWebServerIF registerWithUserid:self.accountTextField.text password:self.passwordTextField.text withCallback:@selector(fRegisterFinished:) withObserver:self];
}

- (void)fRegisterFinished:(NSNotification *)notification
{
    if(notification==nil) return;
    
    NSDictionary *dict = [notification userInfo];
    
    if (dict==nil) return;

    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR && [[dict objectForKey:WT_ERROR] code] != NETWORK_IS_NOT_AVAILABLE){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register",nil) message:[NSString stringWithFormat:@"%ld", (long)[[dict objectForKey:WT_ERROR] code]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Register success!",nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];    }
}




#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
    int new_y_of_centerview = SCREEN_HEIGHT -STATUS_BAR_HEIGHT- KEYBOARD_HEIGHT - self.oldCenterViewFrame.size.height-20;
    
    if (new_y_of_centerview > self.oldCenterViewFrame.origin.y){
        //do nothing ,cuz we should not move down the center view
    }else{
        [self.centerView setFrame:CGRectMake(self.oldCenterViewFrame.origin.x, new_y_of_centerview, self.oldCenterViewFrame.size.width,self.oldCenterViewFrame.size.height)];
    }

	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    
    [self.centerView setFrame:self.oldCenterViewFrame];
	// commit animations
	[UIView commitAnimations];
}


@end
