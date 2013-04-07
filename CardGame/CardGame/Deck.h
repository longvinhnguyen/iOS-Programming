//
//  Deck.h
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

@interface Deck : NSObject

@property (nonatomic, strong) NSMutableArray *cards;

- (void)addCard:(Card *)card atTop:(BOOL) atTop;
- (Card *)drawRandomCard;


@end
