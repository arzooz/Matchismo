//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Arzoo Zehra on 2/15/13.
//  Copyright (c) 2013 TaskEdge Inc. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

@end

@implementation CardGameViewController

- (CardMatchingGame *) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        self.game.gameMode = self.gameModeControl.selectedSegmentIndex;
    }
    return _game;
}

- (IBAction)deal:(UIButton *)sender {
    int newGameMode = self.gameModeControl.selectedSegmentIndex;
    self.game = nil;
    self.gameModeControl.enabled = YES;
    self.gameModeControl.selectedSegmentIndex = newGameMode;
    [self updateUI];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    self.game.gameMode = self.gameModeControl.selectedSegmentIndex;
}

-(void)setCardButtons:(NSArray *)cardButtons {
  
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI {
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLable.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.game.flipCount];
    self.statusLabel.text = self.game.status;
    self.gameModeControl.selectedSegmentIndex = self.game.gameMode;
}



- (IBAction)flipCard:(UIButton *)sender {
    if (self.game.flipCount == 0){
        self.gameModeControl.enabled = NO;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
}


@end
