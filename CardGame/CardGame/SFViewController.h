//
//  SFViewController.h
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@class PlayingCardDeck;

@interface SFViewController : UIViewController<PKAddPassesViewControllerDelegate>

@property (nonatomic, strong) PlayingCardDeck *cardDeck;

@end
