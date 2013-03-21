//
//  BNRItem.h
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    
}

+ (id)randomItem;


- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;


@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;





@end
