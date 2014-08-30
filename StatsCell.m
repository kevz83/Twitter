//
//  StatsCell.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/28/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "StatsCell.h"

@implementation StatsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStats:(User *)user
{
    self.tweetCount.text = [NSString stringWithFormat:@"%@", user.statusesCount];
    self.followersCount.text = [NSString stringWithFormat:@"%@", user.followersCount];
    self.followingCount.text = [NSString stringWithFormat:@"%@", user.friendsCount];
}

@end
