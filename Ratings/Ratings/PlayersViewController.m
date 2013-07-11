
#import "PlayersViewController.h"
#import "Player.h"
#import "PlayerCell.h"
#import "PlayerDetailsViewController.h"
#import "RatePlayerViewController.h"

@interface PlayersViewController () <PlayerDetailsViewControllerDelegate, RatePlayerViewControllerDelegate, UIDataSourceModelAssociation>

@end

@implementation PlayersViewController
{
	BOOL _needsUpdate;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (_needsUpdate)
		[self.tableView reloadData];

	_needsUpdate = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddPlayer"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		PlayerDetailsViewController *playerDetailsViewController = [navigationController viewControllers][0];
		playerDetailsViewController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"EditPlayer"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		PlayerDetailsViewController *playerDetailsViewController = [navigationController viewControllers][0];
		playerDetailsViewController.delegate = self;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Player *player = (self.players)[indexPath.row];
		playerDetailsViewController.playerToEdit = player;
	}
	else if ([segue.identifier isEqualToString:@"RatePlayer"])
	{
		RatePlayerViewController *ratePlayerViewController = segue.destinationViewController;
		ratePlayerViewController.delegate = self;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Player *player = (self.players)[indexPath.row];
		ratePlayerViewController.player = player;
	}	
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.players count];
}

- (UIImage *)imageForRating:(int)rating
{
	switch (rating)
	{
		case 1: return [UIImage imageNamed:@"1StarSmall"];
		case 2: return [UIImage imageNamed:@"2StarsSmall"];
		case 3: return [UIImage imageNamed:@"3StarsSmall"];
		case 4: return [UIImage imageNamed:@"4StarsSmall"];
		case 5: return [UIImage imageNamed:@"5StarsSmall"];
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PlayerCell *cell = (PlayerCell *)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];

	Player *player = (self.players)[indexPath.row];
	cell.nameLabel.text = player.name;
	cell.gameLabel.text = player.game;
	cell.ratingImageView.image = [self imageForRating:player.rating];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.players removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

#pragma mark - PlayerDetailsViewControllerDelegate

- (void)playerDetailsViewControllerDidCancel:(PlayerDetailsViewController *)controller
{
	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didAddPlayer:(Player *)player
{
	[self.players addObject:player];

	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.players count] - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didEditPlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didDeletePlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];

	[self.players removeObjectAtIndex:indexPath.row];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RatePlayerViewControllerDelegate

- (void)ratePlayerViewController:(RatePlayerViewController *)controller didPickRatingForPlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIDataSourceModelAssociation
- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    Player *player = self.players[idx.row];
    return player.playerID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSUInteger index = [self indexOfPlayerWithID:identifier];
    if (index != NSNotFound) {
        return [NSIndexPath indexPathForItem:index inSection:0];
    } else
        return nil;
}

- (NSUInteger)indexOfPlayerWithID:(NSString *)playerID
{
    __block NSUInteger foundIndex = NSNotFound;
    [_players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        if ([player.playerID isEqualToString:playerID]) {
            foundIndex = idx;
            *stop = YES;
        }
    }];
    
    return foundIndex;
}

@end
