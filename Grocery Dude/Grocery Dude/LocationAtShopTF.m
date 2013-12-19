//
//  LocationAtShopTF.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "LocationAtShopTF.h"
#import "AppDelegate.h"
#import "LocationAtShop.h"

@implementation LocationAtShopTF
#define debug 1

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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"aisle" ascending:YES];
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
        LocationAtShop *selectedObject = (LocationAtShop *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtShop* locationAtShop, NSUInteger idx, BOOL *stop) {
            if ([locationAtShop.aisle isEqualToString:selectedObject.aisle]) {
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
    LocationAtShop *locationAtShop = [self.pickerData objectAtIndex:row];
    return locationAtShop.aisle;
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
