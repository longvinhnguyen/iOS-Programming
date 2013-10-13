//
//  main.m
//  6.11-TileCutter
//
//  Created by Long Vinh Nguyen on 10/13/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        if (argc > 2) {
            NSLog(@"TileCutter arguments: inputfile");
            
            return 0;
        }
        
        NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        CGFloat tileSize = 256;
        
        NSString *outputPath = [inputFile stringByDeletingPathExtension];
        
        // load image
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
        NSSize size = [image size];
        NSArray *representations = [image representations];
        if ([representations count]) {
            NSBitmapImageRep *representation = representations[0];
            size.width = representation.size.width;
            size.height = representation.size.height;
        }
        
        NSRect rect = NSMakeRect(0, 0, size.width, size.height);
        CGImageRef imageRef = [image CGImageForProposedRect:&rect context:NULL hints:nil];
        
        // calculate rows and columns
        NSInteger rows = ceil(size.height / tileSize);
        NSInteger columns = ceil(size.width / tileSize);
        
        for (int y = 0 ; y < rows; y++) {
            for (int x = 0 ; x < columns; x++) {
                CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
                CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
                
                // convert to jpeg data
                NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithCGImage:tileImage];
                NSData *data = [image representationUsingType:NSJPEGFileType properties:nil];
                CGImageRelease(tileImage);
                
                
                // save file
                NSString *path = [outputPath stringByAppendingFormat:@"_%02i_%02i.jpg", x, y];
                [data writeToFile:path atomically:NO];
            }
        }
        
    }
    return 0;
}

