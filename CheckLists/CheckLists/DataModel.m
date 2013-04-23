//
//  DataModel.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "DataModel.h"
#import "CheckList.h"

@implementation DataModel

-(void)handleFirstTime
{
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    if (firstTime) {
        CheckList *checklist = [[CheckList alloc] init];
        checklist.name = @"List";
        [self.lists addObject:checklist];
        [self setIndexOfSelectedChecklist:0];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
    }
}

- (id)init
{
    if (self = [super init]) {
        [self loadCheckLists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

- (void) registerDefaults
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:-1], @"ChecklistIndex",
                                [NSNumber numberWithBool:YES], @"FirstTime",
                                nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (int)indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
}

- (void)setIndexOfSelectedChecklist:(int)index
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"ChecklistIndex"];
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

- (void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

@end
