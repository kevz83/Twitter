//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/27/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)User *user;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
