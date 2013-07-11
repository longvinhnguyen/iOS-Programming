
#import "RatePlayerViewController.h"
#import "Player.h"

NSString *const PlayerIDKey = @"PlayerID";
static NSString *const DelegateKey = @"delegate";

@implementation RatePlayerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.player.name;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)rateAction:(UIButton *)sender
{
	self.player.rating = sender.tag;
	[self.delegate ratePlayerViewController:self didPickRatingForPlayer:self.player];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.delegate forKey:DelegateKey];
    [coder encodeObject:self.player.playerID forKey:PlayerIDKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    self.delegate = [coder decodeObjectForKey:DelegateKey];
}

@end
