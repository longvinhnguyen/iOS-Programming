//
//  main.m
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Create a mutable array object, store its address in items varibale
        //NSMutableArray *items = [[NSMutableArray alloc] init];
        
        BNRItem *backpack = [[BNRItem alloc] init];
        [backpack setItemName:@"Backpack"];
        //[items addObject:backpack];
        
        BNRItem *calculator = [[BNRItem alloc] init];
        [calculator setItemName:@"Caculator"];
        //[items addObject:calculator];
        
        [backpack setContainedItem:calculator];
        
        
        
//        BNRContainer *container1 = [[BNRContainer alloc] initWithItemName:@"SysContainer" valueInDollars:190 serialNumber:@"BC2000"];
//        for (int i = 0; i < 5; i++)
//        {
//            BNRItem *p = [BNRItem randomItem];
//            [container1 addItem:p];
//        }
//        
//        NSLog(@"%@",container1);
//        
//        BNRContainer *container2 = [[BNRContainer alloc] initWithItemName:@"WorldContainer" valueInDollars:300 serialNumber:@"GA6789"];
//        [container2 addItem:container1];
//        [container2 addItem:q];
//        NSLog(@"%@",container2);
        
        
        // Destroy the array pointed to by items
        //items = nil;
        
        backpack = nil;
        
        NSLog(@"%@",[calculator container]);
        
        calculator = nil;
        
        
        
        
    }
    return 0;
}

