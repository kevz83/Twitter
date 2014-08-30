//
//  StatsCell.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/28/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface StatsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweetCount;

@property (weak, nonatomic) IBOutlet UILabel *followingCount;

@property (weak, nonatomic) IBOutlet UILabel *followersCount;

- (void)setStats:(User *)user;


@end
