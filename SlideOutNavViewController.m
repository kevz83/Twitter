//
//  SlideOutNavViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/26/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "SlideOutNavViewController.h"
#import "ProfileViewController.h"
#import "PersonCell.h"
#import "Client.h"
#import "LoginViewController.h"

@interface SlideOutNavViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SlideOutNavViewController

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
    
    self.listOfCellNames = @[@"Profile", @"Home", @"Mentions", @"Logout"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"PersonCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:profileVC];
}

#pragma mark - Table

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    [personCell setPersonCell:[User currentUser]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [personCell.profileImage addGestureRecognizer:tapGestureRecognizer];
    
    return personCell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOfCellNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.listOfCellNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.listOfCellNames[indexPath.row] isEqualToString:@"Logout"])
    {
        Client *instance = [Client instance];
        BOOL isRemoved = [instance.requestSerializer removeAccessToken];
        
        if(isRemoved)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"Logout failed");
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:self.listOfCells[indexPath.row]];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
