//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem: (BNRItem *)p;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;
- (NSArray *)allAssetTypes;

- (NSString *)itemArchivePath;
- (BOOL) saveChanges;
- (void)loadAllItems;


@end
