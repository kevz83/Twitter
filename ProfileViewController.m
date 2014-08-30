//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/27/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageEffects.h"
#import "StatsCell.h"
#import "Client.h"
#import "Tweet.h"
#import "TweetCell.h"
#import <Mantle.h>
#import "TweetViewController.h"


@interface ProfileViewController () 

@property (strong, nonatomic) ProfileHeaderView *headerView;
@property (assign, nonatomic) CGRect cachedImageViewSize;
@property (nonatomic, strong) NSMutableArray *myList;


@end

@implementation ProfileViewController

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
    
    self.headerView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 205)];
    self.headerView.clipsToBounds = NO;
    self.tableView.tableHeaderView = self.headerView;

    self.cachedImageViewSize = self.headerView.imageBanner.frame;

    self.headerView.scrollingProfile.contentSize = CGSizeMake(640, 205);

    [self setupProfileHeader];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsCell" bundle:nil] forCellReuseIdentifier:@"StatsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    _myList = [NSMutableArray array];
    
    [self loadFromServer];
    [self.tableView reloadData];
}

- (void)loadFromServer
{
    Client *client = [Client instance];
    
    [client userTimeLineWithScreenName:self.user.screenName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *respObj = (NSArray *)responseObject;
        
        if(respObj.count == 0)
        {
            return;
        }
        
        NSError *error;
        [self.myList addObjectsFromArray:[MTLJSONAdapter modelsOfClass:Tweet.class fromJSONArray:responseObject error:&error]];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)setupProfileHeader
{
    NSLog(@"User %@",self.user);
    
    [self.headerView.imageBanner setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImage]];
    [self.headerView.profileImage setImageWithURL:[NSURL URLWithString:self.user.imageURL]];
    self.headerView.name.text = self.user.name;
    self.headerView.screenName.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    self.headerView.location.text = self.user.location;
    
    CALayer *layer = [self.headerView.profileImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5];
}

#pragma mark - Table View Delegates and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = -scrollView.contentOffset.y;
    if (y > 0) {
        self.headerView.imageBanner.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
        self.headerView.imageBanner.center = CGPointMake(self.view.center.x, self.headerView.imageBanner.center.y);
    }
}


/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ProfileHeaderView"];

    return headerView;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [_myList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        StatsCell *statsCell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell"];
        [statsCell setStats:self.user];
         
         return statsCell;
    }
    else
    {
        TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        
        Tweet *item = [_myList objectAtIndex:indexPath.row];
        tweetCell.tweet = item;
        
        return tweetCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.myList objectAtIndex:indexPath.row];
    
    TweetViewController *tweetVC = [[TweetViewController alloc] initWithTweet:tweet];
    
    [self.navigationController pushViewController:tweetVC animated:YES];
    
    NSLog(@"Selected Item %@", tweet);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
        return 100;
    else
        return 59;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
