//
//  CreateTweetViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/9/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "CreateTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "Client.h"

@interface CreateTweetViewController () <UITextViewDelegate>

@property (nonatomic, strong)User *user;
@property (nonatomic, strong)NSString *replyScreenName;

@end

@implementation CreateTweetViewController

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
    return [self initWithReplyUser:nil];
}

- (id)initWithReplyUser:(NSString *)screenName
{
    if(self = [super init])
    {
        self.replyScreenName = screenName;
    }
    return self;
}

- (IBAction)cancelTweet:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createTweet:(id)sender
{
    Client * client = [Client instance];
    [client createTweet:self.tweetText.text withReplyScreenName:self.replyScreenName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Tweeted Successfully");
        [self dismissViewControllerAnimated:YES completion:nil];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed %@", error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetText.delegate = self;
    self.tweetButton.enabled = NO;
    
    if(self.replyScreenName != nil)
    {
        self.tweetText.text = [NSString stringWithFormat:@"@%@", self.replyScreenName];
        self.tweetButton.enabled = YES;
    }
    
    NSUInteger len = self.tweetText.text.length;
    self.tweetCount.text = [NSString stringWithFormat:@"%zu", 140-len];

    
    [User verifyUserCredentialsWithSuccess:^{
        self.user = [User currentUser];
        [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.imageURL]];
        self.profileName.text = self.user.name;
        self.screenName.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
        
        CALayer *caLayer = [self.profileImage layer];
        [caLayer setMasksToBounds:YES];
        [caLayer setCornerRadius:5.0];
        
    } failure:^(NSError *error) {
        NSLog(@"Error getting user");
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger len = textView.text.length;
    self.tweetCount.text = [NSString stringWithFormat:@"%zu", 140-len];
    
    if(len > 0)
    {
        self.tweetButton.enabled = YES;
    }
    else
    {
        self.tweetButton.enabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 139)
    {
        return NO;
    }
    return YES;
}

@end
