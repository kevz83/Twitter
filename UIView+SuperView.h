//
//  UIView+SuperView.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/7/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SuperView)

- (UIView *)findSuperViewWithClass:(Class)superViewClass;

@end