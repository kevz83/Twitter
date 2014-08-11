//
//  HomeTimeLineViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/2/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "HomeTimeLineViewController.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import <Mantle.h>
#import "Client.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIView+SuperView.h"
#import "TweetViewController.h"
#import "CreateTweetViewController.h"



@interface HomeTimeLineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSNumber *sinceId;
@property (nonatomic, strong) NSMutableArray *myList;

@end

@implementation HomeTimeLineViewController

TweetCell *_stubCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    _myList = [NSMutableArray array];
    _sinceId = 0;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor colorWithRed:0.251 green:0.6 blue:1 alpha:1];
    navBar.tintColor = [UIColor whiteColor];
    
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     navBar.topItem.title = @"Home";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signout:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self loadFromServer];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        self.tableView.showsInfiniteScrolling = YES;
        weakSelf.sinceId = 0;
        [weakSelf.myList removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf loadFromServer];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFromServer];
    }];
}

- (void)signout:(id)sender
{
    Client *instance = [Client instance];
    BOOL isRemoved = [instance.requestSerializer removeAccessToken];
    
    if(isRemoved)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSLog(@"Logout failed");
    }
}

- (void)newTweet:(id)sender
{
    CreateTweetViewController *createTweetVM = [[CreateTweetViewController alloc] initWithReplyUser:nil];
    [self presentViewController:createTweetVM animated:YES completion:nil];
}

- (void)loadFromServer
{
    Client *client = [Client instance];
    [client homeTimeLineWithSinceId:_sinceId success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSArray *respObj = (NSArray *)responseObject;
        
        if(respObj.count == 0)
        {
            self.tableView.showsInfiniteScrolling = NO;
            return;
        }
        
        int currentRow = (int)[self.myList count];
        
        NSError *error;
        [self.myList addObjectsFromArray:[MTLJSONAdapter modelsOfClass:Tweet.class fromJSONArray:responseObject error:&error]];
        
        NSLog(@"List count %ld", self.myList.count);
        
        Tweet *lastTweet =  (Tweet *)[self.myList lastObject];
        self.sinceId = lastTweet.tweetId;
        
        [self reloadTableView:currentRow];
        
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.showsInfiniteScrolling = NO;
        NSLog(@"error %@", error);
    }];
}

- (void)reloadTableView:(int)startingRow
{
    int endingRow = (int)[self.myList count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for(; startingRow < endingRow; startingRow++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.myList objectAtIndex:indexPath.row];
    
    TweetViewController *tweetVC = [[TweetViewController alloc] initWithTweet:tweet];
    
    [self.navigationController pushViewController:tweetVC animated:YES];
    
    NSLog(@"Selected Item %@", tweet);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TweetCell";
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [tweetCell.retweetButton addTarget:self action:@selector(retweetClicked:) forControlEvents:UIControlEventTouchDown];
    [tweetCell.replyButton addTarget:self action:@selector(replyClicked:) forControlEvents:UIControlEventTouchDown];
    [tweetCell.favoriteButton addTarget:self action:@selector(favoriteClicked:) forControlEvents:UIControlEventTouchDown];
    
    Tweet *item = [_myList objectAtIndex:indexPath.row];
    tweetCell.tweet = item;
    
    return tweetCell;
}

- (void)retweetClicked:(id)sender
{
    Client *instance = [Client instance];
    
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Tweet *tweet = [self.myList objectAtIndex:indexPath.row];
    NSNumber *tweetId = tweet.tweetId;
    
    if(tweet.retweeted)
    {
        if(tweet.retweetStatus)
            tweetId = tweet.retweetStatus.tweetId;

        // Call REST API to unretweet.
        [instance destroyTweetWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSError *error;
            Tweet * t = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            tweet.retweetCount = t.retweetCount;
            tweet.retweeted = t.retweeted;
            tweet.retweetStatus = t.retweetStatus;
            
            [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
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
            tweet.retweetStatus = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            tweet.retweeted = tweet.retweetStatus.retweeted;
            tweet.retweetCount = tweet.retweetStatus.retweetCount;
            [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
            
            NSLog(@"Retweet Success");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure %@", error);
        }];
    }
}

- (void)replyClicked:(id)sender
{
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Tweet *tweet = [self.myList objectAtIndex:indexPath.row];
    
    CreateTweetViewController *createTweetVM = [[CreateTweetViewController alloc] initWithReplyUser:tweet.user.screenName];
    [self presentViewController:createTweetVM animated:YES completion:nil];
}

- (void)favoriteClicked:(id)sender
{
    Client *instance = [Client instance];
    
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Tweet *tweet = [self.myList objectAtIndex:indexPath.row];
    NSNumber *tweetId = tweet.tweetId;
    
    if(tweet.favorited)
    {
        [instance destroyFavoriteWithId:tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error;
            Tweet * t = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:&error];
            
            tweet.favorited = t.favorited;
            tweet.favoritesCount = t.favoritesCount;
            
            [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            
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
            
            tweet.favorited = t.favorited;
            tweet.favoritesCount = t.favoritesCount;
            
            [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            
            NSLog(@"Success favorited %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed favorited %@", error);
        }];
    }    
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 100;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
