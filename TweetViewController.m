//
//  TweetViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/8/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"
#import "Client.h"
#import "Tweet.h"
#import "CreateTweetViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    return [self initWithTweet:nil];
}

- (id)initWithTweet:(Tweet *)tweet
{
    if(self = [super init])
    {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor colorWithRed:0.251 green:0.6 blue:1 alpha:1];
    navBar.tintColor = [UIColor whiteColor];
    
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Tweet";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;    
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.tweet.originalUser == nil)
    {
        self.retweetLabel.hidden = YES;
        self.retweetImage.hidden = YES;
    }
    else
    {
        self.retweetImage.hidden = NO;
        self.retweetLabel.hidden = NO;
        self.retweetLabel.text = self.tweet.originalUser.name;
    }
    
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.message;
    self.retweetCount.text = [self.tweet.retweetCount stringValue];
    self.favoritesCount.text = [self.tweet.favoritesCount stringValue];
    
    CALayer *caLayer = [self.profileImage layer];
    [caLayer setMasksToBounds:YES];
    [caLayer setCornerRadius:5.0];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.imageURL]];
    
    self.timeLabel.text = [MHPrettyDate prettyDateFromDate:self.tweet.dateTimeTweet withFormat:MHPrettyDateFormatWithTime];
    
    if(self.tweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    
    if(self.tweet.favorited)
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyClick:(id)sender
{
    CreateTweetViewController *createTweetVM = [[CreateTweetViewController alloc] initWithReplyUser:self.tweet.user.screenName];
    [self presentViewController:createTweetVM animated:YES completion:nil];
}

// TODO: refactor the code to pull it in a method on TweetCell.
- (IBAction)retweetClick:(id)sender
{
    Client *instance = [Client instance];
    
    NSNumber *tweetId = self.tweet.tweetId;
    
    if(self.tweet.retweeted)
    {
        if(self.tweet.retweetStatus)
            tweetId = self.tweet.retweetStatus.tweetId;
        
        // Call REST API to unretweet.
        [instance destroyTweetWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             Tweet * t = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
             self.tweet.retweetCount = t.retweetCount;
             self.tweet.retweeted = t.retweeted;
             self.tweet.retweetStatus = t.retweetStatus;
             
             [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
             
             self.retweetCount.text = [self.tweet.retweetCount stringValue];
             
             NSLog(@"Success unretweet %@", responseObject);
         }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Failure %@", error);
         }];
    }
    else
    {
        // Call REST API to retweet.
        [instance retweetWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error;
            self.tweet.retweetStatus = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            self.tweet.retweeted = self.tweet.retweetStatus.retweeted;
            self.tweet.retweetCount = self.tweet.retweetStatus.retweetCount;
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
            
            self.retweetCount.text = [self.tweet.retweetCount stringValue];
            
            NSLog(@"Retweet Success");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure %@", error);
        }];
    }
}

// TODO: refactor the code to pull it in a method on TweetCell.
- (IBAction)favoritesClick:(id)sender
{
    Client *instance = [Client instance];
    
    NSNumber *tweetId = self.tweet.tweetId;
    
    if(self.tweet.favorited)
    {
        [instance destroyFavoriteWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error;
            Tweet * t = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            
            self.tweet.favorited = t.favorited;
            self.tweet.favoritesCount = t.favoritesCount;
            
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            
            self.favoritesCount.text = [self.tweet.favoritesCount stringValue];
            
            NSLog(@"Success unfavorited %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed %@", error);
        }];
    }
    else
    {
        [instance createFavoriteWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error;
            Tweet * t = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            
            self.tweet.favorited = t.favorited;
            self.tweet.favoritesCount = t.favoritesCount;
            
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            
            self.favoritesCount.text = [self.tweet.favoritesCount stringValue];
            
            NSLog(@"Success favorited %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed favorited %@", error);
        }];
    }
}

@end
