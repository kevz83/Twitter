//
//  HomeTimeLineViewController.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/2/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HomeTimeLine,
    MentionsTimeLine
    
} ViewMode;

@interface HomeTimeLineViewController : UIViewController

@property ViewMode viewMode;

//- (id)initWithViewMode:(ViewMode)viewMode;

@end
