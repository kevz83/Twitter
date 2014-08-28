//
//  ContainerViewController.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/27/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong)UINavigationController *navigationController;

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSelectMenuItem:) name:@"menuSelected" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

-(UINavigationController*) navigationController {
    if(_navigationController == nil) {
        _navigationController = [[UINavigationController alloc] init];
    }
    return _navigationController;
}

- (void)displayContentController:(UIViewController *)content
{
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)onSelectMenuItem:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"menuSelected"])
    {
        [self.navigationController setViewControllers:@[(UIViewController *)notification.object]];
        [self displayContentController:self.navigationController];
    }
}

- (void)setupUI
{
    [self.navigationController setViewControllers:@[self.viewControllers[1]]];
    [self displayContentController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
