//
//  ViewController.m
//  StoreSearch
//
//  Created by Long Vinh Nguyen on 5/8/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
static NSString *const CellIdentifier = @"SearchResultCell";
static NSString *const NothingFoundCellIdentifer = @"NothingFoundCell";


@implementation SearchViewController
{
    NSMutableArray *searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    self.tableView.rowHeight = 80;
    cellNib  = [UINib nibWithNibName:NothingFoundCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifer];
    
    [self.searchBar becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!searchResults) {
        return 0;
    } else if (searchResults.count == 0) return 1;
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (searchResults.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifer];
    } else {
        SearchResult *searchResult = searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        NSString *artistName = searchResult.artistName;
        if (searchResult.artistName == nil) {
            artistName = @"Unknown";
        }
        
        NSString *kind = [self kindForDisplay:searchResult.kind];
        cell.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",artistName, kind];
    }
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchResults.count == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

#pragma mark - UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchResults = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSURL *url = [self urlWithString:searchBar.text];
    
    NSString *jsonString = [self performStoreRequestWithURL:url];
    if (jsonString == nil) {
        [self showNetworkError];
    }
    
    NSDictionary *dictionary = [self parseJSON:jsonString];
    if (dictionary == nil) {
        [self showNetworkError];
    }
    [self parseDictionary:dictionary];
    [searchResults sortUsingSelector:@selector(compareName:)];

    [self.tableView reloadData];
}

#pragma mark - Controller methods
- (NSURL *)urlWithString:(NSString *)searchText
{
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@",escapedSearchText];
    VLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (NSString *)performStoreRequestWithURL:url
{
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (resultString == nil) {
        VLog(@"Download Error: %@",error);
        return nil;
    }
    return resultString;
}

- (NSDictionary *)parseJSON:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (resultObject == nil) {
        VLog(@"JSON Error:%@",error);
        return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
        VLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    return resultObject;
}

- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"There was an error reading from the iTunes Store. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *array = [dictionary objectForKey:@"results"];
    if (array == nil) {
        VLog(@"Expected results array");
        return;
    }
    for (NSDictionary *resultDict in array) {
        SearchResult *searchResult;
        NSString *wrapperType = [resultDict objectForKey:@"wrapperType"];
        if ([wrapperType isEqualToString:@"track"]) {
            searchResult = [self parseTrack:resultDict];
        } else if ([wrapperType isEqualToString:@"audiobook"]) {
            searchResult = [self parseAudioBook:resultDict];
        } else if ([wrapperType isEqualToString:@"software"]) {
            searchResult = [self parseSoftware:resultDict];
        } else if ([resultDict[@"kind"] isEqualToString:@"ebook"]) {
            searchResult = [self parseEbook:resultDict];
        }
        if (searchResult) {
            [searchResults addObject:searchResult];
        }
    }
}

- (SearchResult *)parseTrack:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artWorkURL60 = dictionary[@"artWorkUrl60"];
    searchResult.artWorkURL100 = dictionary[@"artWorkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
    
}

- (SearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artWorkURL60 = dictionary[@"artWorkUrl60"];
    searchResult.artWorkURL100 = dictionary[@"artWorkUrl100"];
    searchResult.storeURL = dictionary[@"collectionViewUrl"];
    searchResult.kind = dictionary[@"audiobook"];
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artWorkURL60 = dictionary[@"artWorkUrl60"];
    searchResult.artWorkURL100 = dictionary[@"artWorkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseEbook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artWorkURL60 = dictionary[@"artWorkUrl60"];
    searchResult.artWorkURL100 = dictionary[@"artWorkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = (NSArray *)[dictionary[@"genres"] componentsJoinedByString:@", "];
    return searchResult;
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if ([kind isEqualToString:@"album"]) {
        return @"Album";
    } else if ([kind isEqualToString:@"audiobook"]) {
        return @"Audio Book";
    } else if ([kind isEqualToString:@"book"]) {
        return @"Book";
    } else if ([kind isEqualToString:@"ebook"]) {
        return @"Ebook";
    } else if ([kind isEqualToString:@"feature-movie"]) {
        return @"Movie";
    } else if ([kind isEqualToString:@"music-video"]) {
        return @"Music Video";
    } else if ([kind isEqualToString:@"podCast"]) {
        return @"Podcast";
    } else if ([kind isEqualToString:@"software"]) {
        return @"App";
    } else if ([kind isEqualToString:@"song"]) {
        return @"Song";
    } else if ([kind isEqualToString:@"tv-episode"]) {
        return @"TV Episode";
    } else {
        return kind;
    }
}

@end
