//
//  PersonCell.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/27/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;

- (void)setPersonCell:(User *)user;

@end
