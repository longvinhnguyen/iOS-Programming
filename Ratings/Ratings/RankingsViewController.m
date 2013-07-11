
#import "RankingsViewController.h"
#import "Player.h"
#import "RatePlayerViewController.h"

static NSString *const RequiredRatingKey = @"RequiredRating";

@interface RankingsViewController () <UITableViewDataSource, UITableViewDelegate, RatePlayerViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation RankingsViewController
{
	NSMutableArray *_rankedPlayers;
	int _requiredRating;
	BOOL _needsUpdate;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_requiredRating = 5;
	_needsUpdate = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (_needsUpdate || _rankedPlayers == nil)
		[self updateRankedPlayers];

	_needsUpdate = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender
{
	_requiredRating = (sender.selectedSegmentIndex == 0) ? 5 : 1;
	[self updateRankedPlayers];
}

- (void)updateRankedPlayers
{
	_rankedPlayers = [self playersWithRating:_requiredRating];
	[self.tableView reloadData];
}

- (NSMutableArray *)playersWithRating:(int)rating
{
	NSMutableArray *rankedPlayers = [NSMutableArray arrayWithCapacity:[self.players count]];

	for (Player *player in self.players)
	{
		if (player.rating == rating)
			[rankedPlayers addObject:player];
	}

	[rankedPlayers sortUsingComparator:^NSComparisonResult(Player *player1, Player* player2)
	{
		return [player1.name localizedStandardCompare:player2.name];
	}];
	
	return rankedPlayers;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"RatePlayer"])
	{
		RatePlayerViewController *ratePlayerViewController = segue.destinationViewController;
		ratePlayerViewController.delegate = self;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Player *player = _rankedPlayers[indexPath.row];
		ratePlayerViewController.player = player;
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_rankedPlayers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	Player *player = _rankedPlayers[indexPath.row];
	cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.game;

    return cell;
}

#pragma mark - RatePlayerViewControllerDelegate

- (void)ratePlayerViewController:(RatePlayerViewController *)controller didPickRatingForPlayer:(Player *)player
{
	NSUInteger index = [_rankedPlayers indexOfObject:player];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

	if (player.rating != _requiredRating)
	{
		[_rankedPlayers removeObjectAtIndex:index];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else
	{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

	_needsUpdate = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Preservation Restoration methods
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInt:_requiredRating forKey:RequiredRatingKey];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    _requiredRating = [coder decodeIntForKey:RequiredRatingKey];
    if (_requiredRating < 1 || _requiredRating > 5) {
        _requiredRating = 5;
    }
    self.segmentedControl.selectedSegmentIndex = (_requiredRating == 5) ? 0 : 1;
}


@end
