//
//  BNRItem.m
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize valueInDollars, serialNumber, dateCreated, containedItem, container;

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [[NSArray alloc] initWithObjects:@"Fluffy",@"Rusty",@"Shiny", nil];
    
    // Create an array of three nouns
    NSArray *randomNounList = [[NSArray alloc] initWithObjects:@"Bear",@"Spork", @"Mac",nil];
    
    // Get the index of a random adjective/noun from the lists
    // Note: The % oprator, called the modulo operator, gives you the reminder, So ajectives is a random number from 0 to 2 inclusive
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",'0' + rand() % 10, 'A' + rand() % 26,'0' + rand() % 10, 'A' + rand() % 26, '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", itemName, serialNumber, valueInDollars, dateCreated];

    return descriptionString;
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // Call the superclass 's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
    }

    
    return self;
}

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (id)init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@",self);
}

- (void)setContainedItem:(BNRItem *)i
{
    containedItem = i;
    [i setContainer:self];
}









@end
