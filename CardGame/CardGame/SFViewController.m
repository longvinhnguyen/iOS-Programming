//
//  SFViewController.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SFViewController.h"
#import "PlayingCardDeck.h"

static int currentIndex = 0;

@interface SFViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (nonatomic) NSUInteger flipCount;




@end

@implementation SFViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _cardDeck = [[PlayingCardDeck alloc] init];
    NSLog(@"Number of cards: %d",_cardDeck.cards.count);
}

- (void)setFlipCount:(NSUInteger)flipCount
{
    _flipCount = flipCount;
    [self.flipLabel setText:[NSString stringWithFormat:@"Flip Count: %d",_flipCount]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [sender setTitle:[NSString stringWithFormat:@"%@",_cardDeck.cards[currentIndex]] forState:UIControlStateSelected];
        if (currentIndex < 51) {
            currentIndex ++;
        } else currentIndex = 0;
    }
    self.flipCount++;

}



















@end
