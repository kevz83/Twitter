//
//  Tweet.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/2/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"user" : @"user",
             @"tweetId" : @"id",
             @"message" : @"text",
             @"dateTimeTweet" : @"created_at",
             @"retweetCount" : @"retweet_count",
             @"favoritesCount" : @"favorite_count",
             @"retweeted" : @"retweeted",
             @"favorited" : @"favorited",
             @"originalUser" : @"retweeted_status.user"
             };
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    return dateFormatter;
}

+ (NSValueTransformer *)dateTimeTweetJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *str)
            {
                return [self.dateFormatter dateFromString:str];
            }];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)originalUserJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

@end
