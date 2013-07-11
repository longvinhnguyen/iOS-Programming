
#import "PlayerDetailsViewController.h"
#import "GamePickerViewController.h"
#import "Player.h"
#import "AppDelegate.h"

static NSString *const DelegateKey = @"Delegate";
static NSString *const GameKey = @"Game";
static NSString *const PlayerNameKey = @"PlayerName";
static NSString *const PlayerIDKey = @"PlayerIDKey";

@interface PlayerDetailsViewController () <GamePickerViewControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation PlayerDetailsViewController
{
	NSString* _game;
    UIActionSheet *_actionSheet;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		_game = @"Chess";
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.playerToEdit != nil)
	{
		self.title = @"Edit Player";
		self.nameTextField.text = self.playerToEdit.name;
		_game = self.playerToEdit.game;
	}
	else
	{
		self.deleteButton.hidden = YES;
	}

	self.detailLabel.text = _game;

	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	recognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:recognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickGame"])
	{
		GamePickerViewController *gamePickerViewController = segue.destinationViewController;
		gamePickerViewController.delegate = self;
		gamePickerViewController.game = _game;
	}
}

- (IBAction)cancel:(id)sender
{
	[self.delegate playerDetailsViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	if (self.playerToEdit != nil)
	{
		self.playerToEdit.name = self.nameTextField.text;
		self.playerToEdit.game = _game;

		[self.delegate playerDetailsViewController:self didEditPlayer:self.playerToEdit];
	}
	else
	{
		Player *player = [[Player alloc] init];
		player.name = self.nameTextField.text;
		player.game = _game;
		player.rating = 1;

		[self.delegate playerDetailsViewController:self didAddPlayer:player];
	}
}

- (void)registerBackgroundNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)unregisterBackgroundNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:NO];
}


- (IBAction)deletePressed:(id)sender
{
	_actionSheet = [[UIActionSheet alloc]
		initWithTitle:@"Are you sure?"
		delegate:self
		cancelButtonTitle:@"Cancel"
		destructiveButtonTitle:@"Delete"
		otherButtonTitles:nil];

	[_actionSheet showFromRect:self.deleteButton.frame inView:self.view animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		[self.nameTextField becomeFirstResponder];
}

#pragma mark - GamePickerViewControllerDelegate

- (void)gamePickerViewController:(GamePickerViewController *)controller didSelectGame:(NSString *)game
{
	self.detailLabel.text = _game = game;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[self.delegate playerDetailsViewController:self didDeletePlayer:self.playerToEdit];
	}
    
    _actionSheet = nil;
}

#pragma mark - Preservation & Restoration methods
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.delegate forKey:DelegateKey];
    [coder encodeObject:_game forKey:GameKey];
    [coder encodeObject:self.nameTextField.text forKey:PlayerNameKey];
    [coder encodeObject:self.playerToEdit.playerID forKey:PlayerIDKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    self.delegate = [coder decodeObjectForKey:DelegateKey];
    _game = [coder decodeObjectForKey:GameKey];
    
    if (_game == nil || _game.length == 0) {
        _game = @"Chess";
    }
    self.detailLabel.text = _game;
    
    NSString *playerName = [coder decodeObjectForKey:PlayerNameKey];
    if (playerName) {
        self.nameTextField.text = [coder decodeObjectForKey:PlayerNameKey];
    }
    
    [self.view layoutIfNeeded];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.restorationClass = [self class];
    [self registerBackgroundNotifications];
}

- (void)dealloc
{
    [self unregisterBackgroundNotifications];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    PlayerDetailsViewController *viewController = nil;
    NSString *identifier = [identifierComponents lastObject];
    
    UIStoryboard *storyBoard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    
    if (storyBoard != nil) {
        viewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
        
        if (viewController) {
            NSString *playerID = [coder decodeObjectForKey:PlayerIDKey];
            if (playerID) {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                viewController.playerToEdit = [appDelegate playerWithID:playerID];
            }
            
        }
    }
    return viewController;
}

@end
