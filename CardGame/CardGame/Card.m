//
//  Card.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contens isEqualToString:self.contens]) {
            score = 1;
        }
    }
    return score;
}

@end
