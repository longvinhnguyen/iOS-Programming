//
//  BNRContainer.h
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *subItems;
}

- (void)addItem:(BNRItem *)i;

@end
