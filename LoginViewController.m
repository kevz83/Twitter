//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 7/15/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "LoginViewController.h"
#import "Client.h"

@interface LoginViewController ()
- (IBAction)onLoginButton:(id)sender;

@end

@implementation LoginViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.251 green:0.6 blue:1 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender
{
    [[Client instance ] login];
}
@end
