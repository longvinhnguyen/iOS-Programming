//
//  Define.h
//  FlickSearch
//
<<<<<<< HEAD
//  Created by VisiKard MacBook Pro on 4/8/13.
=======
//  Created by Long Vinh Nguyen on 4/9/13.
>>>>>>> Baby & PinchLayout
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

<<<<<<< HEAD
#if DEBUG
#define VKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VKLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#endif

=======
#define VLLog(...) NSLog (@"%s [%d]",__PRETTY_FUNCTION__,__LINE__,__VA_ARGS__)

@protocol Define <NSObject>

@end
>>>>>>> Baby & PinchLayout
