//
//  SimpleFlowLayout.h
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleFlowLayout : UICollectionViewFlowLayout
{
    NSMutableArray *_insertedIndexPaths;
    NSMutableArray *_deletedIndexPaths;
}

@end
