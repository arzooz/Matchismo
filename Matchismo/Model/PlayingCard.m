//
//  PlayingCard.m
//  Matchismo
//
//  Created by Arzoo Zehra on 2/15/13.
//  Copyright (c) 2013 TaskEdge Inc. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int) match:(NSArray *) otherCards {
    
    int score = 0;
    if ([otherCards count] == 1) { // TWO_CARDS_GAME_MODE
        PlayingCard *anotherCard = [otherCards lastObject];
        if ([anotherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (anotherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) { // THREE_CARDS_GAME_MODE
        PlayingCard *card1 = [otherCards objectAtIndex:0];
        PlayingCard *card2 = [otherCards objectAtIndex:1];
        if ([card1.suit isEqualToString:self.suit] && [card2.suit isEqualToString:self.suit]) {
            score = 2;
        } else if (card1.rank == self.rank && card2.rank == self.rank) {
            score = 8;
        }
    }
    
    return score;
}

- (NSString *) contents {
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString: self.suit];
}

@synthesize suit = _suit;

+ (NSArray *) validSuits {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *) suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger) maxRank {
    return [self rankStrings].count-1;
}

- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
