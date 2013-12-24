//
//  Thumbnailer.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/24/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface Thumbnailer : NSObject

+ (void)createMissingThumbnailsForEntityName:(NSString *)entityName withThumbnailAttributeName:(NSString *)thumbnailAttributeName withPhotoRelationshipName:(NSString *)photoRelationshipName withPhotoAttributeName:(NSString *)photoAttributeName withSortDescriptors:(NSArray *)sortDescriptors withImportContext:(NSManagedObjectContext *)importContext;

@end
