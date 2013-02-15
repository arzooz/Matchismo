//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Arzoo Zehra on 2/15/13.
//  Copyright (c) 2013 TaskEdge Inc. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()

@property (strong,nonatomic) PlayingCardDeck *deck;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck {
    if (!_deck || [_deck isEmpty]) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    //    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender {

    Card *card = [self.deck drawRandomCard];
    [sender setTitle:card.contents forState:UIControlStateSelected];
    sender.selected = !sender.isSelected;
    self.flipCount++;
}


@end
