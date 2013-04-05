//
//  CVViewController.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/3/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CVViewController.h"
#import "FlickrPhotoCell.h"
#import "FlickrPhotoHeaderView.h"
#import "FlickrPhotoViewController.h"
#import <MessageUI/MessageUI.h>


@implementation CVViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolBar setBackgroundImage: navBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
    
    self.searches = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableDictionary alloc] init];
    self.flick = [[Flickr alloc] init];
    
    UINib *nib =[UINib nibWithNibName:@"FlickrPhotoCell" bundle:nil];
    UINib *headerNib = [UINib nibWithNibName:@"FlickrPhotoHeaderView" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FlickrCell"];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView"];
    
    self.selectedPhotos = [[[NSMutableArray alloc] init] mutableCopy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareButtonTapped:(id)sender
{
    if (!self.sharing) {
        self.sharing = YES;
        [_shareButton setStyle:UIBarButtonItemStyleDone];
        [_shareButton setTitle:@"Done"];
        [self.collectionView setAllowsMultipleSelection:YES];
    } else {
        self.sharing = NO;
        [_shareButton setStyle:UIBarButtonItemStyleBordered];
        [_shareButton setTitle:@"Share"];
        [self.collectionView setAllowsMultipleSelection:NO];
        
        if ([self.selectedPhotos count] > 0) {
            [self showMailComposerAndSend];
        }
        
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }
        [self.selectedPhotos removeAllObjects];
    }
}

- (void)showMailComposerAndSend
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Check out these Flickr photos"];
        NSMutableString *emailBody = [NSMutableString string];
        for (FlickrPhoto *photo in _selectedPhotos) {
            NSString *url = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
            NSLog(@"%@",url);
            [emailBody appendFormat:@"<div><src ='<div><img src='%@'></div><br>",url];
        }
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failure" message:@"Your device doesn't suppor in-app mail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.flick searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error){
        if (results  && [results count] > 0) {
            if (![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", [results count], searchTerm);
//                [self.searchResults setValue:results forKey:searchTerm];
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.collectionView reloadData];
                });
            }
        } else
            NSLog(@"Error searching Flickr: %@", [error localizedDescription]);
    }];
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"Sections: %d",[self.searches count]);
   return [self.searches count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *searchTerm = self.searches[section];
    NSLog(@"Sections: %d",[self.searchResults[searchTerm] count]);
    return [self.searchResults[searchTerm] count];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    [cell setPhoto:[[self.searchResults valueForKey:searchTerm] objectAtIndex: indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s %d",__PRETTY_FUNCTION__, __LINE__);
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    if (!self.sharing) {
        FlickrPhotoViewController *fpvc = [[FlickrPhotoViewController alloc] initWithPhoto:photo];
        
        [fpvc setModalPresentationStyle:UIModalPresentationFormSheet];
        [fpvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentViewController:fpvc animated:YES completion:nil];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
    } else {
        [self.selectedPhotos addObject:photo];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = [self.searchResults[searchTerm] objectAtIndex:indexPath.row];
    
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    NSLog(@"Size: %f %f",retval.width, retval.height);
    retval.width += 35; retval.height +=35;
    NSLog(@"Size Modify: %f %f",retval.width, retval.height);
    return retval;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];
    [header setBounds:CGRectMake(0, 0, 100, 50)];
    NSString *searchTerm = self.searches[indexPath.section];
    [header setSearchText:searchTerm];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(50, 50);
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"_______%@ %d", [error localizedDescription], result);
    [controller dismissViewControllerAnimated:YES completion:nil];
}


















@end
