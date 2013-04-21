//
//  Define.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/20/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLog(fmt,...) NSLog(@"%s [LINE %d]"fmt,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

@protocol Define <NSObject>


@end
