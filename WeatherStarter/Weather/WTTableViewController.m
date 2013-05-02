//
//  WTTableViewController.m
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "WTTableViewController.h"
#import "WeatherAnimationViewController.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "UIImageView+AFNetworking.h"

//static NSString *const BaseURLString = @"http://raywenderlich.com/downloads/weather_sample/";

static NSString *const BaseURLString = @"http://localhost/";


@interface WTTableViewController ()

@property(strong) NSDictionary *weather;
@property (strong) NSMutableDictionary *xmlWeather;
@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
@property (nonatomic, strong) NSString *previousElement;
@property (nonatomic, strong) NSString *elementName;
@property (nonatomic, strong) NSMutableString *outString;

@end

@implementation WTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    
    _manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        WeatherAnimationViewController *wac = (WeatherAnimationViewController *)segue.destinationViewController;
        
        NSDictionary *w;
        switch (indexPath.section) {
            case 0:{
                w = self.weather.currentCondition;
                break;
            }
            case 1:{
                w = [[self.weather upcomingWeather] objectAtIndex:indexPath.row];
                break;
            }
            default:{
                break;
            }
        }
        
        wac.weatherDictionary = w;
    }
}

#pragma mark Actions

- (IBAction)clear:(id)sender {
    self.title = @"";
    self.weather = nil;
    [self.tableView reloadData];
}

- (IBAction)jsonTapped:(id)sender
{
    // 1
    NSString *weatherURL = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:weatherURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        // 3
        self.weather = (NSDictionary *)JSON;
        self.title = @"JSON Retrieved";
        [self.tableView reloadData];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         // 4
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [av show];
     }];
    
    // 5
    [operation start];
}

- (IBAction)plistTapped:(id)sender
{
    NSString *weatherURL = [NSString stringWithFormat:@"%@weather.php?format=plist", BaseURLString];
    NSURL *url = [NSURL URLWithString:weatherURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFPropertyListRequestOperation *operation = [AFPropertyListRequestOperation propertyListRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id propertyList) {
        self.weather = propertyList;
        self.title = @"PLIST Retrieved";
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id propertyList) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather Data" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

- (IBAction)xmlTapped:(id)sender
{
    NSString *weatherUrl = [NSString stringWithFormat:@"%@weather.php?format=xml", BaseURLString];
    NSURL *url = [NSURL URLWithString:weatherUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        self.xmlWeather = [NSMutableDictionary dictionary];
        XMLParser.delegate = self;
        [XMLParser setShouldProcessNamespaces:YES];
        [XMLParser parse];
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather Data" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

- (IBAction)httpClientTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"AFHTTPClient" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"HTTP POST",@"HTTP GET", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)apiTapped:(id)sender
{
    [self.manager startUpdatingLocation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.weather) {
        return 0;
    }
    switch (section) {
        case 0: {
            return 1;
        }
        case 1:
        {
            return [self.weather upcomingWeather].count;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *daysWeather;
    
    switch (indexPath.section) {
        case 0:
            daysWeather = self.weather.currentCondition;
            break;
        case 1:
            daysWeather = [[self.weather upcomingWeather] objectAtIndex:indexPath.row];
        default:
            break;
    }
    cell.textLabel.text = [daysWeather weatherDescription];
    // Configure the cell...
    
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:daysWeather.weatherIconURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
    }];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Current Weather";
    } else
        return @"Upcomming Weather";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark - NSXMLParser delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.previousElement = elementName;
    if (qName) {
        self.elementName = qName;
    }
    
    if ([qName isEqualToString:@"current_condition"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    } else if ([qName isEqualToString:@"weather"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    } else if ([qName isEqualToString:@"request"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outString = [NSMutableString string];
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName) {
        return;
    }
    [self.outString appendFormat:@"%@",string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([qName isEqualToString:@"current_condition"] || [qName isEqualToString:@"request"]) {
        [self.xmlWeather setObject:[NSArray arrayWithObject:self.currentDictionary] forKey:qName];
        self.currentDictionary = nil;
    } else if ([qName isEqualToString:@"weather"]) {
        // Initialize a list of weather items if it does not exist
        NSMutableArray *array = [self.xmlWeather objectForKey:@"weather"];
        if (!array) {
            array = [NSMutableArray array];
        }
        [array addObject:self.currentDictionary];
        [self.xmlWeather setObject:array forKey:@"weather"];
        self.currentDictionary = nil;
    } else if ([qName isEqualToString: @"value"]) {
        // Ignore the value tags they only appear in condition belows
    } else if ([qName isEqualToString: @"weatherDesc"] || [qName isEqualToString:@"weatherIconUrl"]) {
        [self.currentDictionary setObject:[NSArray arrayWithObject:[NSDictionary dictionaryWithObject:self.outString forKey:@"value"]] forKey:qName];
    } else {
        [self.currentDictionary setObject:self.outString forKey:qName];
    }
    self.elementName = nil;
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.weather = [NSDictionary dictionaryWithObject:self.xmlWeather forKey:@"data"];
    self.title = @"XML Retrieved";
    [self.tableView reloadData];
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"json" forKey:@"format"];
    
    // 2
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    // 3
    if (buttonIndex == 0) {
        [client postPath:@"weather.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.weather = responseObject;
            self.title = @"HTTP POST";
            [self.tableView reloadData];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving weather" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    } else if (buttonIndex == 1) {
        [client getPath:@"weather.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            self.weather = responseObject;
            self.title = @"HTTP GET";
            [self.tableView reloadData];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving weather" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    if ([newLocation.timestamp timeIntervalSinceNow] < 300) {
        [self.manager stopUpdatingLocation];
        CLGeocoder *myCity = [[CLGeocoder alloc] init];
        [myCity reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placeMark, NSError *error){
            NSString *city = [[placeMark lastObject] locality];
            NSLog(@"%@",city);
            self.title = [NSString stringWithFormat:@"%@",city];
        }];
        
        WeatherHTTPClient *client = [WeatherHTTPClient shareWeatherHTTPClient];
        client.delegate = self;
        [client updateWeatherAtLocation:newLocation forNumberDays:5];
    }
}

#pragma mark - WeatherHTTPClient delegate
- (void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather
{
    self.weather = weather;
    [self.tableView reloadData];
}

- (void)weatherHTTPClient:(WeatherHTTPClient *)client didFailWithError:(id)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}












@end
