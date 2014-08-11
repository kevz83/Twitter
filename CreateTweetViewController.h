//
//  CreateTweetViewController.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/9/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTweetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;

- (id)initWithReplyUser:(NSString *)screenName;

@end
