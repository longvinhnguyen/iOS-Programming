//
//  ListViewController.m
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ListViewController.h"


@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (PendingOperations *)pendingOperations
{
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
}

- (NSMutableArray *)photos
{
    if (!_photos) {
        NSURL *datasourceurl = [NSURL URLWithString:kDatasourceString];
        NSURLRequest *request = [NSURLRequest requestWithURL:datasourceurl];
        
        AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *datasource_date = (NSData *)responseObject;
            CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)datasource_date, kCFPropertyListImmutable, NULL);
            NSDictionary *datasource_dictionary = (__bridge NSDictionary *)plist;
            
            NSMutableArray *records = [NSMutableArray array];
            
            for (NSString *key in datasource_dictionary.allKeys) {
                PhotoRecord *photoRecord = [[PhotoRecord alloc] init];
                photoRecord.name = key;
                photoRecord.URL = [NSURL URLWithString:[datasource_dictionary objectForKey:key]];
                [records addObject:photoRecord];
                photoRecord = nil;
            }
            _photos = records;
            CFRelease(plist);
            [self.tableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        //
        [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
    }
    return _photos;
}

- (void)startOperationForPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
    }
    
    if (!record.isFiltered) {
        [self startImageFiltrationForRecord:record atIndexPath:indexPath];
    }
}

- (void)startImageDownloadingForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)startImageFiltrationForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{
    if (![self.pendingOperations.filtrationInProgress.allKeys containsObject:indexPath]) {
        ImageFiltration *imageFiltration = [[ImageFiltration alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        ImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency) {
            [imageFiltration addDependency:dependency];
        }
        [self.pendingOperations.filtrationInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Classic Photos";
    self.tableView.rowHeight = 80.0f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self cancelAllOperations];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count = self.photos.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.accessoryView = activityIndicatorView;
        cell.imageView.layer.cornerRadius = 8.0f;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    PhotoRecord *aRecord = [_photos objectAtIndex:indexPath.row];
    
    if (aRecord.hasImage) {
        [(UIActivityIndicatorView *)cell.accessoryView stopAnimating];
        cell.imageView.image = aRecord.image;
        cell.textLabel.text = aRecord.name;
    } else if (aRecord.isFailed) {
        [(UIActivityIndicatorView *)cell.accessoryView stopAnimating];
        cell.imageView.image = [UIImage imageNamed:@"Failed.png"];
        cell.textLabel.text = @"Fail to load";
    } else {
        [(UIActivityIndicatorView *)cell.accessoryView startAnimating];
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        cell.textLabel.text = @"";
        if (!(tableView.dragging || tableView.decelerating)) {
            [self startOperationForPhotoRecord:aRecord atIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - ImageDownloader delegate
- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark - ImageFiltration delegate
- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration
{
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.pendingOperations.filtrationInProgress removeObjectForKey:indexPath];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOneScreenCells];
        [self resumeAllOperations];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOneScreenCells];
    [self resumeAllOperations];
}

#pragma mark - Cancelling, Suspending, resuming queues / operations
- (void)suspendAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}

- (void)resumeAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
}


- (void)loadImagesForOneScreenCells
{
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations addObjectsFromArray:self.pendingOperations.filtrationInProgress.allKeys];
    
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    NSMutableSet *toBeCanceled = [pendingOperations mutableCopy];
    
    [toBeStarted minusSet:pendingOperations];
    [toBeCanceled minusSet:visibleRows];
    
    for (NSIndexPath *indexPath in toBeCanceled) {
        ImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
        
        ImageFiltration *pendingFiltration = [self.pendingOperations.filtrationInProgress objectForKey:indexPath];
        [pendingFiltration cancel];
        [self.pendingOperations.filtrationInProgress removeObjectForKey:indexPath];
    }
    toBeCanceled = nil;
    
    for (NSIndexPath *anIndexPath in toBeStarted) {
        PhotoRecord *photoRecord = [self.photos objectAtIndex:anIndexPath.row];
        [self startOperationForPhotoRecord:photoRecord atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
}

#pragma mark - iCarousel delegate








@end
