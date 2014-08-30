//
//  ProfileHeaderView.m
//  TwitterClient
//
//  Created by Kevin Shah on 8/28/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        
        UIView *subView = objects[0];
        subView.frame = CGRectMake(0, 0, 320, 205);
        self.frame = subView.frame;
        [self addSubview:subView];
        
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
