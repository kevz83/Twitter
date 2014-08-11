//
//  User.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/1/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *screenName;


+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)verifyUserCredentialsWithSuccess:(void (^)())success failure:(void(^)(NSError *error))failure;

@end
