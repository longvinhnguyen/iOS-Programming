//
//  SFViewController.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SFViewController.h"
#import "PlayingCardDeck.h"
#import <PassKit/PassKit.h>

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

- (IBAction)createPass: (UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://localhost/pass/bayroast.pkpass"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    __block NSData *data;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *dt, NSError *error){
//        NSLog(@"Finish loading, %@", [response MIMEType]);
//        data = dt;
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost/pass/bayroast.pkpass"]];
//        if (data) {
//            NSLog(@"Start creating pass");
//            BOOL written = [data writeToFile:@"/tmp/bestBuy.pkpass" options:NSDataWritingAtomic error:&error];
//            if (written) {
//                NSLog(@"save the pkpass file successfully");
//            }
//            PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
//            PKAddPassesViewController *pvc = [[PKAddPassesViewController alloc] initWithPass:pass];
//            pvc.delegate = self;
//    
//            pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:pvc animated:YES completion:nil];
//        }
    //}];
    
    
    CGRect screenFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIView *newView = [[UIView alloc] initWithFrame:screenFrame];
    newView.backgroundColor = [UIColor greenColor];
    
    // add Button
    UIButton *passButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    passButton.frame = CGRectMake(0, 0, 100, 40);
    passButton.center = CGPointMake(newView.bounds.size.width / 2, newView.bounds.size.height / 2);
    passButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [passButton setTitle:@"Create Pass" forState:UIControlStateNormal];
    [passButton addTarget:self action:@selector(addPass:) forControlEvents:UIControlEventTouchUpInside];
    [newView addSubview:passButton];

    
    [self.view addSubview:newView];
    screenFrame.origin.y = 35;
    [UIView animateWithDuration:0.5 animations:^{
        newView.frame = screenFrame;
    }];

    

}

- (void)addPass: (id)sender
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost/pass/bayroast.pkpass"]];
        if (data) {
            NSLog(@"Start creating pass");
            BOOL written = [data writeToFile:@"/tmp/bestBuy.pkpass" options:NSDataWritingAtomic error:&error];
            if (written) {
                NSLog(@"save the pkpass file successfully");
            }
            PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
            PKAddPassesViewController *pvc = [[PKAddPassesViewController alloc] initWithPass:pass];
            pvc.delegate = self;

            pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:pvc animated:YES completion:nil];
        }
}

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    NSLog(@"Finish add pass");
    [self dismissViewControllerAnimated:YES completion:nil];
}


















@end
