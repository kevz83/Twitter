//
//  User.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/1/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "User.h"
#import "Client.h"

@implementation User

static User *currentUser = nil;

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name" : @"name",
             @"imageURL" : @"profile_image_url",
             @"screenName" : @"screen_name",
             @"profileBackgroundImage" : @"profile_banner_url",
             @"followersCount" : @"followers_count",
             @"friendsCount" : @"friends_count",
             @"location" : @"location",
             @"statusesCount" : @"statuses_count"
             };
}

+ (User *)currentUser
{
    if(currentUser == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *userData = [defaults objectForKey:@"user"];
        
        if(userData)
            currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    
    return currentUser;
}

+ (void)setCurrentUser:(User *)user
{
    currentUser = user;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [defaults setObject:userData forKey:@"user"];
    
}

+ (void)verifyUserCredentialsWithSuccess:(void (^)())success
                                 failure:(void(^)(NSError *error))failure
{
    [[Client instance] userCredentialsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"UserCredentials got successfully");
        
        NSError *error;
        User *user = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:responseObject error:&error];
        
        [self setCurrentUser:user];
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure to get the User credentials");
        failure(error);
        
    }];
}

@end
