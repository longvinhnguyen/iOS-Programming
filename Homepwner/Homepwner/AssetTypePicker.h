//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/3/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

@interface AssetTypePicker : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BNRItem *item;

@end
