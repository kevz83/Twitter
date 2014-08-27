//
//  PersonCell.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/27/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "PersonCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PersonCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPersonCell:(User *)user
{
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.imageURL]];
    CALayer *layer = [self.profileImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5];
    
    self.name.text = user.name;
    self.screenName.text = user.screenName;
}

@end
