//
//  SlideOutNavViewController.h
//  TwitterClient
//
//  Created by Kevin Shah on 8/26/14.
//  Copyright (c) 2014 KS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideOutNavViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *listOfCells;
@property (nonatomic, strong)NSArray *listOfCellNames;

@end
