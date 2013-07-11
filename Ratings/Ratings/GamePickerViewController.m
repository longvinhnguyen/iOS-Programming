
#import "GamePickerViewController.h"

static NSString *const DelegateKey = @"DelegateKey";
static NSString *const SelectedIndex = @"SelectedRow";

@implementation GamePickerViewController
{
	NSArray *_games;
	NSInteger _selectedIndex;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_games = @[
		@"Angry Birds",
		@"Backgammon",
		@"Battleship",
		@"Checkers",
		@"Chess",
		@"Go",
		@"Hearts",
		@"Hide and Seek",
		@"Mahjong",
		@"Master Mind",
		@"Monopoly",
		@"Risk",
		@"Rummy",
		@"Russian Roulette",
		@"Snakes and Ladders",
		@"Snap!",
		@"Spin the Bottle",
		@"Tag",
		@"Texas Hold'em Poker",
		@"Tic-Tac-Toe",
		@"Twister",
		@"Video Poker",
		@"Yahtzee",
		];

	_selectedIndex = [_games indexOfObject:self.game];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
	cell.textLabel.text = _games[indexPath.row];

	if (indexPath.row == _selectedIndex)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (_selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	_selectedIndex = indexPath.row;

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;

	NSString *game = _games[indexPath.row];
	[self.delegate gamePickerViewController:self didSelectGame:game];
}

#pragma mark - Preservation & Restoration methods
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.delegate forKey:DelegateKey];
    [coder encodeInteger:_selectedIndex forKey:SelectedIndex];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    self.delegate = [coder decodeObjectForKey:DelegateKey];
    _selectedIndex = [coder decodeIntegerForKey:SelectedIndex];
    
    [self.tableView reloadData];
}

@end
