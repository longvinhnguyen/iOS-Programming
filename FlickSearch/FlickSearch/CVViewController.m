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
#import "SimpleFlowLayout.h"

@interface CVViewController()
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;


@end
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
    
    self.layout1 = [[UICollectionViewFlowLayout alloc] init];
    self.layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout1.headerReferenceSize = CGSizeMake(0.0f, 90.0f);
    
    self.layout2 = [[SimpleFlowLayout alloc] init];
    self.layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // Add Gestures
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    
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
    [self.flick searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (results && [results count] > 0) {
            if (![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                [self.searches addObject:searchTerm];
                self.searchResults[searchTerm] = results;
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				// RUN AFTER SEARCH HAS FINISHED
				if (self.collectionView.collectionViewLayout == self.layout2) {
                    NSLog(@"%d", self.searches.count-1);
					[self.collectionView performBatchUpdates:^{
						[self.collectionView insertItemsAtIndexPaths:@[
						 [NSIndexPath indexPathForItem:(self.searches.count-1)
											 inSection:0]]];
					} completion:nil];
				} else {
                    [self.collectionView performBatchUpdates:^{
                    NSInteger newSection = self.searches.count - 1;
                    for (int i = 0; i < results.count; i ++) {
                        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:newSection]]];
                        }
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:newSection]];
                    }completion:nil];
				}
			});
		} else {
			NSLog(@"Error searching Flickr: %@", error.localizedDescription);
		}
	}];
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_collectionView == collectionView) {
        if (collectionView.collectionViewLayout == self.layout2) {
            return 1;
        } else
            return [self.searches count];
    }
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        if (collectionView.collectionViewLayout == self.layout2) {
            return [self.searches count];
        } else {
            NSString *searchTerm = self.searches[section];
            return [self.searchResults[searchTerm] count];
        }
    } 
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    FlickrPhoto *photo = nil;
    if (collectionView == self.collectionView) {
        if (self.collectionView.collectionViewLayout == self.layout2) {
            NSString *searchTerm = self.searches[indexPath.item];
            photo = self.searchResults[searchTerm][0];
        } else {
            NSString *searchTerm = self.searches[indexPath.section];
            photo = self.searchResults[searchTerm][indexPath.item];
        }
    } 
    cell.photo = photo;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s %d",__PRETTY_FUNCTION__, __LINE__);

    if (!self.sharing) {
        FlickrPhoto *photo = nil;
        if (collectionView == _collectionView) {
            if (collectionView.collectionViewLayout == self.layout2) {
                NSString *searchTerm = self.searches[indexPath.item];
                photo = self.searchResults[searchTerm][0];
            } else {
                NSString *searchTerm = self.searches[indexPath.section];
                photo = self.searchResults[searchTerm][indexPath.item];
            }
        }
        FlickrPhotoViewController *fpvc = [[FlickrPhotoViewController alloc] initWithPhoto:photo];
        
        [fpvc setModalPresentationStyle:UIModalPresentationFormSheet];
        [fpvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentViewController:fpvc animated:YES completion:nil];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
    } else {
        NSString *searchTerm = self.searches[indexPath.section];
        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.item];
        
        [self.selectedPhotos addObject:photo];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sharing) {
        [self.selectedPhotos removeObject:self.searches[indexPath.section][indexPath.item]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    FlickrPhoto *photo = nil;
    
    if (collectionView == _collectionView) {
        if (_collectionView.collectionViewLayout == self.layout2) {
            NSString *searchTerm = self.searches[indexPath.item];
            photo = self.searchResults[searchTerm][0];
        } else {
            NSString *searchTerm = self.searches[indexPath.section];
            photo = self.searchResults[searchTerm][indexPath.item];
        }
    }
    
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.width += 35; retval.height +=35;
    return retval;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 40, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    [header setSearchText:searchTerm];
    return header;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)layoutSelectionTapped:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    NSLog(@"%d",segControl.selectedSegmentIndex);
    switch (segControl.selectedSegmentIndex) {
        case 0:
            self.collectionView.collectionViewLayout = self.layout1;
            [self.collectionView removeGestureRecognizer:self.longPressGestureRecognizer];
            break;
        case 1:
            self.collectionView.collectionViewLayout = self.layout2;
            [self.collectionView addGestureRecognizer:self.longPressGestureRecognizer];
            break;
            
        default: self.collectionView.collectionViewLayout = self.layout1;
            break;
    }
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recog
{
    if (recog.state == UIGestureRecognizerStateRecognized) {
        CGPoint tapPoint = [recog locationInView:self.collectionView];
        NSIndexPath *item = [self.collectionView indexPathForItemAtPoint:tapPoint];
        
        if (item) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:item];
            cell.backgroundColor = [UIColor cyanColor];
            NSString *searchTerm = self.searches[item.item];
            [self.searches removeObjectAtIndex:item.item];
            [self.searchResults removeObjectForKey:searchTerm];
            [self.collectionView performBatchUpdates:^(){
                [self.collectionView deleteItemsAtIndexPaths:@[item]];
            }completion:nil];
        }
    }
}


















@end
