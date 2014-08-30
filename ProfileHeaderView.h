//
//  ProfileHeaderView.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/28/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageBanner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollingProfile;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end
