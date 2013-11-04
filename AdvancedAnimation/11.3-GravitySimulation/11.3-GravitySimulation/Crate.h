//
//  Crate.h
//  11.3-GravitySimulation
//
//  Created by VisiKard MacBook Pro on 11/4/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chipmunk.h"

@interface Crate : UIImageView

@property (nonatomic, assign) cpBody *body;
@property (nonatomic, assign) cpShape *shape;

@end
