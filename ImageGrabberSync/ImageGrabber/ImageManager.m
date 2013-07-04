//
//  ImageManager.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageManager.h"
#import "ImageInfo.h"
#import "ZipArchive.h"
#import "ASIHTTPRequest.h"

@implementation ImageManager
@synthesize html;
@synthesize delegate;

char const*STRING_BGQUEUE_NAME = "com.razeware.imagegrabber.bgqueue";

- (void)processZip:(NSData *)data sourceURL:(NSURL *)sourceURL {
    
    // Write file to disk
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    NSString *zipFilePath = [documentDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    NSError *error;
    NSLog(@"Processing zip file... %@", zipFilePath);
    [data writeToFile:zipFilePath atomically:YES];
    
    // Open zip
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL success = [zip UnzipOpenFile:zipFilePath];    
    if (!success) {
        NSLog(@"Failed to open zip");
        return;
    }
    
    
    
    // Unzip
    NSString *zipDirName = [sourceURL.lastPathComponent substringWithRange:NSMakeRange(0, sourceURL.lastPathComponent.length - sourceURL.pathExtension.length - 1)];
    NSString *zipDirPath = [documentDirectory stringByAppendingPathComponent:zipDirName];
    NSLog(@"Unzipping to %@", zipDirPath);
    
    success = [zip UnzipFileTo:zipDirPath overWrite:YES];
    if (!success) {
        NSLog(@"Failed to unzip zip");
        return;
    }
    
    // Enumerate directory
    NSArray * items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:zipFilePath error:&error];
    if (error) {
        NSLog(@"Could not enumerate %@", zipFilePath);
        return;
    }
    
    
    NSMutableArray *imageInfos = [NSMutableArray array];
    for (NSString *file in items) {
        if ([file.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [file.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            NSString *imagePath = [zipFilePath stringByAppendingPathComponent:file];
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            NSLog(@"Found image in zip: %@", file);
            
            ImageInfo *info = [[ImageInfo alloc] initWithSourceURL:sourceURL imageName:file image:image];
            [imageInfos addObject:info];            
        }        
    }
    
    pendingZips--;
    
    [delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
        
}


- (void)retrieveZip:(NSURL *)sourceURL {
    
    NSLog(@"Getting %@...", sourceURL);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setCompletionBlock:^{
        NSLog(@"Zip file downloaded.");
        NSData *data = [request responseData];
        dispatch_async(backGroundQueue, ^{
            [self processZip:data sourceURL:sourceURL];
        });
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error downloading zip file: %@", error.localizedDescription);
    }];
    [request startAsynchronous];
}

- (void)processHtml {
    
    NSLog(@"Processing HTML...");
    
    // Simple regex to search for links
    NSError *error = nil;
    NSString *pattern = @"(href|src)=\"([\\w:\\/\\.-]*)";
    NSLog(@"Searching HTML with pattern: %@", pattern);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    // Search for links and add to set
    NSMutableSet *linkURLs = [NSMutableSet set];
    [regex enumerateMatchesInString:html options:0 range:NSMakeRange(0, html.length-1) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSString *link = [html substringWithRange:[result rangeAtIndex:2]];
        NSURL *linkURL = [NSURL URLWithString:link];
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {               
            [linkURLs addObject:linkURL];
        }
        
    }];
    
    // Create an image info for each link (except zip)
    NSMutableArray * imageInfos = [NSMutableArray array];
    for(NSURL *linkURL in linkURLs) {
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//            [self retrieveZip:linkURL];
//            pendingZips++;
        } else {
            ImageInfo *info = [[ImageInfo alloc] initWithSourceURL:linkURL];
            NSLog(@"Image info %@ %@", info.sourceURL, info.imageName);
            [imageInfos addObject:info];
        }
    }
    
    // Notify delegate in main thread that new image infos
    // available
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
    });
}

- (void)process {
    dispatch_async(backGroundQueue, ^{
        NSLog(@"process HTML %@", html);
        [self processHtml];
    });
}

- (id)initWithHTML:(NSString *)theHtml delegate:(id<ImageManagerDelegate>) theDelegate {
    
    if ((self = [super init])) {
        html = theHtml;      
        delegate = theDelegate;
        backGroundQueue = dispatch_queue_create(STRING_BGQUEUE_NAME, NULL);
    }
    return self;
}

- (void)dealloc {
    dispatch_release(backGroundQueue);
    [super dealloc];
}

@end
