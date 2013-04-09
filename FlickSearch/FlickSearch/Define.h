//
//  Define.h
//  FlickSearch
//
//  Created by VisiKard MacBook Pro on 4/8/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define VKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VKLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#endif

