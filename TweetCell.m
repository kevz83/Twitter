//
//  TweetCell.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/2/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtons:(NSString *)buttonName state:(BOOL)newState
{
    if([buttonName isEqualToString:@"retweet"])
    {
        if(newState)
        {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        }
        else
        {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        }
    }
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    
    if(tweet.originalUser == nil)
    {
        self.retweetLabel.hidden = YES;
        self.retweetImage.hidden = YES;
        
      //  [self.retweetImageConstraint setConstant:-15];
      //  [self.retweetUserConstraint setConstant:-15];
        self.reTweetHeight.constant = 0.0f;
    }
    else
    {
        self.retweetImage.hidden = NO;
        self.retweetLabel.hidden = NO;
        self.retweetLabel.text = tweet.originalUser.name;
        
      //  [self.retweetImageConstraint setConstant:1.0];
      //  [self.retweetUserConstraint setConstant:1.0];
        self.reTweetHeight.constant = 16.0f;
    }
    
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.tweetLabel.text = tweet.message;
    
    CALayer *caLayer = [self.profileImage layer];
    [caLayer setMasksToBounds:YES];
    [caLayer setCornerRadius:5.0];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.imageURL]];

    self.timeLabel.text = [MHPrettyDate prettyDateFromDate:tweet.dateTimeTweet withFormat:MHPrettyDateShortRelativeTime];
    
    if(tweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    
    if(tweet.favorited)
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    
}

@end
