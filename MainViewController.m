//
//  MainViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/26/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "MainViewController.h"
#import "HomeTimeLineViewController.h"
#import "SlideOutNavViewController.h"
#import "ProfileViewController.h"

@interface MainViewController ()

@property (nonatomic, strong)SlideOutNavViewController *slideOutNavVC;
@property (nonatomic, assign)BOOL showPanel;
@property (nonatomic, assign)BOOL isHamburgerOpen;

/* New declarations */

@property (nonatomic, strong)NSArray *viewControllers;
@property (nonatomic, strong)ContainerViewController *containerViewController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        HomeTimeLineViewController *homeViewController = [[HomeTimeLineViewController alloc] init];
        homeViewController.viewMode = HomeTimeLine;
        
        HomeTimeLineViewController *mentionsViewController = [[HomeTimeLineViewController alloc] init];
        mentionsViewController.viewMode = MentionsTimeLine;
        
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        profileViewController.user = [User currentUser];
        
        self.viewControllers = @[profileViewController, homeViewController, mentionsViewController];
        
        self.containerViewController = [[ContainerViewController alloc] init];
        self.containerViewController.viewControllers = self.viewControllers;
        
        [self addChildViewController:self.containerViewController];
        [self.view addSubview:self.containerViewController.view];
        [self.containerViewController didMoveToParentViewController:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSelectMenuItem:) name:@"menuSelected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHamburgerIconClicked:) name:@"hamburgerClicked" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    [self setupGestures];
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (UIView *)getNavView
{
    if(self.slideOutNavVC == nil)
    {
        self.slideOutNavVC = [[SlideOutNavViewController alloc] init];
        self.slideOutNavVC.listOfCells = self.viewControllers;
        [self.view addSubview:self.slideOutNavVC.view];
        [self addChildViewController:self.slideOutNavVC];
        [self.slideOutNavVC didMoveToParentViewController:self];
        self.slideOutNavVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self showContainerViewWithShadow:YES withOffset:-2];
    }
    
    return self.slideOutNavVC.view;
}

- (void)showContainerViewWithShadow:(BOOL)value withOffset:(double)offset
{
    [self.containerViewController.view.layer setCornerRadius:3];
    [self.containerViewController.view.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.containerViewController.view.layer setShadowOpacity:0.8];
    [self.containerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    UIView *view = panGestureRecognizer.view;
        
    // Make sure to not be able to slide it from right to left.
    if((velocity.x < 0) && (_containerViewController.view.frame.origin.x == 0))
    {
        return;
    }
    
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if(velocity.x > 0)
        {
            self.showPanel = YES;
        }
        else
        {
            self.showPanel = NO;
        }
        
        UIView *childView = [self getNavView];
        [self.view sendSubviewToBack:childView];
    }
    else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if(velocity.x > 0)
        {
            self.showPanel = YES;
        }
        else
        {
            self.showPanel = NO;
        }
        
        _containerViewController.view.center = CGPointMake(view.center.x + point.x, view.center.y);
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.showPanel == YES)
        {
            [self movePanelRight];
            self.isHamburgerOpen = YES;
        }
        else
        {
            [self movePanelOriginalPosition];
            self.isHamburgerOpen = NO;
        }
    }
}

- (void)movePanelRight
{
    UIView *childView = [self getNavView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:1 animations:^{
        
        _containerViewController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            self.isHamburgerOpen = YES;
        }
    }];
}

- (void)movePanelOriginalPosition
{
    [UIView animateWithDuration:1 animations:^{
        _containerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished)
     {
         if(finished)
         {
             self.isHamburgerOpen = NO;
             
             [self resetMainView];
         }
     }];
}

- (void)resetMainView
{
    if(self.slideOutNavVC != nil)
    {
        [self.slideOutNavVC.view removeFromSuperview];
        self.slideOutNavVC = nil;
    }
}

- (void)onSelectMenuItem:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"menuSelected"])
    {
        [self movePanelOriginalPosition];
    }
}

- (void)onHamburgerIconClicked:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"hamburgerClicked"])
    {
        [self toggleMenu];
    }
}

- (void)toggleMenu
{
    if(self.isHamburgerOpen == YES)
    {
        [self movePanelOriginalPosition];
    }
    else
    {
        [self movePanelRight];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
