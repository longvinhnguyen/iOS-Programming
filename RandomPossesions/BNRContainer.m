//
//  BNRContainer.m
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];
    if (self) {
        subItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)valueInDollars
{
    int sum = [self valueInDollars];
    for (BNRItem *item in subItems) {
        sum += [item valueInDollars];
    }
    return sum;
}

- (void)addItem:(BNRItem *)i
{
    [subItems addObject:i];
}


- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Container Name: %@ worth $%d \n %@",[self itemName],[self valueInDollars],subItems];
    return desc;
}


@end
