//
//  PlayingCardDeck.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (int rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self.cards addObject:card];
            }
        }
    }

    return self;
}

@end
