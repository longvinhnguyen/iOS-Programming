//
//  BNRItem.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/3/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRAssetType;

@interface BNRItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image;

@end
