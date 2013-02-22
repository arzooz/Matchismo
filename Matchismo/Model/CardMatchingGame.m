//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Arzoo Zehra on 2/15/13.
//  Copyright (c) 2013 TaskEdge Inc. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) int flipCount;
@property (readwrite, nonatomic) NSString *status;
@property (strong, nonatomic) NSMutableArray *cards; // of Card

@end


@implementation CardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

#define TWO_CARDS_GAME_MODE 0
#define THREE_CARDS_GAME_MODE 1


- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


- (void)updateMatchScore:(NSArray *)otherCards card:(Card *)card {

    int matchScore = [card match:otherCards];
    if (matchScore) {
        card.unplayable = YES;
        for (Card *anotherCard in otherCards) anotherCard.unplayable = YES;
        
        self.status = [NSString stringWithFormat:@"Matched %@", card.contents];
        if (self.gameMode == THREE_CARDS_GAME_MODE) {
            self.status = [self.status stringByAppendingFormat:@", %@", [[otherCards lastObject] contents]];
        }
        self.status = [self.status stringByAppendingFormat:@" & %@ for %d points!", [[otherCards objectAtIndex:0] contents], matchScore * MATCH_BONUS];
        
        self.score += matchScore * MATCH_BONUS;
        
    } else {
        for (Card *anotherCard in otherCards) anotherCard.faceUp = NO;
        int penaltyValue = 1;
        
        self.status = [NSString stringWithFormat:@"%@", card.contents];
        if (self.gameMode == THREE_CARDS_GAME_MODE) {
            self.status = [self.status stringByAppendingFormat:@", %@", [[otherCards lastObject] contents]];
            penaltyValue = 2;
        }
        self.status = [self.status stringByAppendingFormat:@" & %@ don't match, %d points penalty!",
                       [[otherCards objectAtIndex:0] contents], MISMATCH_PENALTY];
        
        self.score -= penaltyValue * MISMATCH_PENALTY;
    }
}

- (void)flipCardAtIndex:(NSUInteger)index {
    
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            BOOL isFirstFlippedCard = YES;
            
            if (self.gameMode == TWO_CARDS_GAME_MODE){
                
                for (Card *otherCard in self.cards){
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        [self updateMatchScore:@[otherCard] card:card];             
                        isFirstFlippedCard = NO;
                        break;
                    }
                }
                
            } else { // THREE CARDS GAME MODE
                
                NSMutableArray *otherCards = [NSMutableArray array];
                
                for (int i = 0; i < [self.cards count]; i++){
                    Card *anothercard = [self.cards objectAtIndex:i];
                    if (anothercard.isFaceUp && !anothercard.isUnplayable){
                        [otherCards addObject:anothercard];
                        if ([otherCards count] == 2){
                            isFirstFlippedCard = NO;
                            break;
                        }
                    }
                }
                
                if (!isFirstFlippedCard){
                    [self updateMatchScore:otherCards card:card];
                }

            }
            
            self.score -= FLIP_COST;
            if (isFirstFlippedCard) {
                self.status = [NSString stringWithFormat:@"Flipped up %@! ", card.contents];
            }
            
        }
        self.flipCount++;
        card.faceUp = !card.isFaceUp;
    }
}


- (Card *)cardAtIndex:(NSUInteger)index {
    
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
        self.gameMode = TWO_CARDS_GAME_MODE;
        self.status = @"Flip a card!";
    }
    
    return self;
}

@end
