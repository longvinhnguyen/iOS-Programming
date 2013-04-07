//
//  PlayingCard.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()


@end

@implementation PlayingCard
@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♥",@"♠",@"♣",@"♦"] ;
}


-(NSString *)contens
{
    NSArray *rankingStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return [rankingStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *)rankingStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankingStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    } else _rank = [PlayingCard maxRank];
}

- (NSString *)description
{
    return self.contens;
}



@end
