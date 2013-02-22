//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Arzoo Zehra on 2/15/13.
//  Copyright (c) 2013 TaskEdge Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int flipCount;
@property (nonatomic) int gameMode;
@property (readonly, nonatomic) NSString *status;


//designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void) flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
