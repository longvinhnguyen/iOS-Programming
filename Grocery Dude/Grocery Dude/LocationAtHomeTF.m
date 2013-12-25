//
//  LocationAtHomeTF.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "LocationAtHomeTF.h"
#import "AppDelegate.h"
#import "LocationAtHome.h"

@implementation LocationAtHomeTF
#define debug 0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"storedIn" ascending:YES];
    request.sortDescriptors = @[sort];
    [request setFetchBatchSize:50];
    NSError *error;
    self.pickerData = [cdh.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error populating picker %@, %@", error, error.localizedDescription);
    }
    [self selectDefaultRow];
}

- (void)selectDefaultRow
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.selectedObjectID && [self.pickerData count] > 0) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        LocationAtHome *selectedObject = (LocationAtHome *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtHome* locationAtHome, NSUInteger idx, BOOL *stop) {
            if ([locationAtHome.storedIn compare:selectedObject.storedIn] == NSOrderedSame) {
                [self.picker selectRow:idx inComponent:0 animated:NO];
                [self.pickerDelegate selectedObjectID:self.selectedObjectID changedForPickerTF:self];
                *stop = YES;
            }
        }];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    LocationAtHome *locationAtHome = [self.pickerData objectAtIndex:row];
    return locationAtHome.storedIn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
