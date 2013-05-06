//
//  NSMutableString+AddText.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 5/4/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "NSMutableString+AddText.h"

@implementation NSMutableString (AddText)

- (void)addText:(NSString *)text withSeparator:(NSString *)separator
{
    if (self != nil) {
        if (self.length > 0) {
            [self appendString:separator];
        }
        if (text != nil && text.length > 0) {
            [self appendString:text];
        }
    }
}

@end
