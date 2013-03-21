//
//  BNRAssetType.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/3/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRAssetType : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSSet *items;
@end

@interface BNRAssetType (CoreDataGeneratedAccessors)

- (void)addItemsObject:(BNRItem *)value;
- (void)removeItemsObject:(BNRItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
