
#import "AppDelegate.h"
#import "Player.h"
#import "PlayersViewController.h"
#import "RankingsViewController.h"
#import "RatePlayerViewController.h"

static NSString *const VersionKey = @"VersionKey";

@implementation AppDelegate
{
	NSMutableArray* _players;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadPlayers];
    
	self.playersViewController.players = _players;
	self.rankingsViewController.players = _players;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self savePlayers];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self savePlayers];
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    NSString *bundleVersion = [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey];
    NSLog(@"Bundle verison = %@", bundleVersion);
    
    NSString *myVersion = [coder decodeObjectForKey:VersionKey];
    NSLog(@"My version = %@", myVersion);
    
    return [myVersion isEqualToString:bundleVersion];
}

- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:@"1.0" forKey:VersionKey];
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"viewControllerWithRestorationIdentifierPath %@", identifierComponents);
    
    UIViewController *viewController = nil;
    NSString *identifier = [identifierComponents lastObject];
    
    if ([identifier isEqualToString:@"RatePlayerViewController"]) {
        UIStoryboard *storyBoard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
        if (storyBoard) {
            viewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
            if (viewController != nil) {
                RatePlayerViewController *ratePlayerViewController = (RatePlayerViewController *)viewController;
                NSString *playerID = [coder decodeObjectForKey:PlayerIDKey];
                
                if (playerID) {
                    ratePlayerViewController.player = [self playerWithID:playerID];
                }
            }
        }
    }
    
    return viewController;
}

- (PlayersViewController *)playersViewController
{
	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController = [tabBarController viewControllers][0];
	PlayersViewController *playersViewController = [navigationController viewControllers][0];
	return playersViewController;
}

- (RankingsViewController *)rankingsViewController
{
	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController = [tabBarController viewControllers][1];
	RankingsViewController *rankingsViewController = [navigationController viewControllers][0];
	return rankingsViewController;
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:@"Players.plist"];
}

- (void)loadPlayers
{
    NSString *path = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		NSData *data = [[NSData alloc] initWithContentsOfFile:path];
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		_players = [unarchiver decodeObjectForKey:@"Players"];
		[unarchiver finishDecoding];
	}
	else
	{
		_players = [NSMutableArray arrayWithCapacity:20];
		[self addDefaultPlayers];
	}
}

- (void)savePlayers
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_players forKey:@"Players"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)addDefaultPlayers
{
	Player *player;

	player = [[Player alloc] init];
	player.name = @"Bill Evans";
	player.game = @"Tic-Tac-Toe";
	player.rating = 4;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Oscar Peterson";
	player.game = @"Spin the Bottle";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Dave Brubeck";
	player.game = @"Texas Hold'em Poker";
	player.rating = 2;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Slim Pickens";
	player.game = @"Texas Hold'em Poker";
	player.rating = 1;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Tom Waits";
	player.game = @"Russian Roulette";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Chet Baker";
	player.game = @"Mahjong";
	player.rating = 3;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Duke Ellington";
	player.game = @"Hide and Seek";
	player.rating = 3;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Bill Evans";
	player.game = @"Hide and Seek";
	player.rating = 2;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Miles Davis";
	player.game = @"Yahtzee";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Nina Simone";
	player.game = @"Tic-Tac-Toe";
	player.rating = 1;
	[_players addObject:player];
}

- (Player *)playerWithID:(NSString *)playerID
{
    for (Player *player in _players) {
        if ([playerID compare:player.playerID] == NSOrderedSame) {
            return player;
        }
    }
    return nil;
}

@end
