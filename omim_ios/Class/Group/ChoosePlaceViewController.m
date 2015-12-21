//
//  ChoosePlaceViewController.m
//  dev01
//
//  Created by jianxd on 14-6-25.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ChoosePlaceViewController.h"
#import "PublicFunctions.h"
#import "UISize.h"
@interface ChoosePlaceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *places;
@end

@implementation ChoosePlaceViewController

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
    [self configNavigationBar];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Place" ofType:@"plist"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    self.places = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[userInfo count]; i++) {
        [self.places addObject:[userInfo objectForKey:[NSString stringWithFormat:@"Item%d",i]]];
    }
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [UISize screenHeight] - 20 - 44)];

    }
}

- (void)configNavigationBar
{
    UIBarButtonItem *backButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"nav_back.png"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backButton];
    [backButton release];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"Choose Place", nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
    [label release];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(didChoosePlace:)]) {
        [_delegate didChoosePlace:[self.places objectAtIndex:indexPath.row]];
    }
}


#pragma mark -- Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell] autorelease];
    }
    cell.textLabel.text = [self.places objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
