//
//  Tweet.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/2/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <Mantle.h>
#import "User.h"

@interface Tweet : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)User *user;
@property (nonatomic, strong)NSNumber *tweetId;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSDate *dateTimeTweet;
@property (nonatomic, strong)NSNumber *retweetCount;
@property (nonatomic, strong)NSNumber *favoritesCount;
@property (nonatomic, strong)User *originalUser;
@property (nonatomic, strong)Tweet *retweetStatus;
@property BOOL retweeted;
@property BOOL favorited;

@end
