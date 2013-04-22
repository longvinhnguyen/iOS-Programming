//
//  DataModel.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init
{
    if (self = [super init]) {
        [self loadCheckLists];
        [self registerDefaults];
    }
    return self;
}

- (void) registerDefaults
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1], @"ChecklistIndex", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (NSString *)documentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"CheckLists.plist"];
}

- (void)saveCheckLists
{
    [NSKeyedArchiver archiveRootObject:self.lists toFile:[self dataFilePath]];
}

- (void)loadCheckLists
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        self.lists = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePath]];
    } else {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }

}

@end
