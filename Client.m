//
//  Client.m
//  TwitterClient
//
//  Created by Kevin Shah on 7/15/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "Client.h"

@implementation Client

+ (Client *)instance
{
    static Client *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                                       consumerKey:@"gBVppx3D86cOCjvy8MrxtVG5P"
                                    consumerSecret:@"zDVNx2BvcsmHS2a24hWoN2v2IhEXHvNrvFEOaXETvaiFFy7xYh"];
    });
    
    return instance;
}

- (void)login
{
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Failure");
    }];
}

- (AFHTTPRequestOperation *)destroyTweetWithId:(NSNumber *)tweetId
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)homeTimeLineWithSinceId:(NSNumber *)sinceId
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameters;
    NSNumber *maxCount = [NSNumber numberWithInt:25];

    if(sinceId != 0)
    {
        parameters = @{@"count" : maxCount,
                   @"since_id" : sinceId };
    }
    else
    {
        parameters = @{@"count" : maxCount};
    }
    
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)retweetWithId:(NSNumber *)tweetId
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)destroyFavoriteWithId:(NSNumber *)tweetId
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self POST:@"1.1/favorites/destroy.json" parameters:@{@"id" : tweetId} success:success failure:failure];
}

- (AFHTTPRequestOperation *)createFavoriteWithId:(NSNumber *)tweetId
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self POST:@"1.1/favorites/create.json" parameters:@{@"id" : tweetId} success:success failure:failure];
}


- (AFHTTPRequestOperation *)userCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)createTweet:(NSString *)tweet
                    withReplyScreenName:(NSString *)screenName
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(screenName != nil)
    {
        [parameters setObject:screenName forKey:@"in_reply_to_status_id"];
    }
    
    [parameters setObject:tweet forKey:@"status"];
    
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}


@end
