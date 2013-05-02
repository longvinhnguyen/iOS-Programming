//
//  CheckListItem.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CheckListItem.h"
#import "DataModel.h"

@implementation CheckListItem
@synthesize text, checked;

- (id)init
{
    if (self = [super init]) {
        self.itemID = [DataModel nextCheckListItemId];
        self.checked = NO;
    }
    return self;
}

- (void)toggleChecked
{
    self.checked = !checked;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"ItemID"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.itemID = [aDecoder decodeIntegerForKey:@"ItemID"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
    }
    return self;
}

- (void)scheduleNotification
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification) {
        NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        NSLog(@"We should schedule a local notification");
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.alertBody = self.text;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.itemID] forKey:@"itemID"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        VLog(@"Scheduled notification %@ for itemId %d",localNotification, self.itemID);
    }
}

- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"itemID"];
        if (number !=nil && number.intValue == self.itemID) {
            return notification;
        }
    }
    return nil;
}

- (void)dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification) {
        NSLog(@"Removing existing notification %@",existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}

- (NSComparisonResult)compare:(CheckListItem *)anotherItem
{
    return [self.dueDate compare:anotherItem.dueDate];
}



@end
