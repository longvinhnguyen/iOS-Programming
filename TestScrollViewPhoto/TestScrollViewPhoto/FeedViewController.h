//
//  FeedViewController.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/29/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSArray *dataList;

@end
