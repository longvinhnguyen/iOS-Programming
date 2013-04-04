//
//  CVViewController.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/3/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CVViewController.h"


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
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareButtonTapped:(id)sender
{
    
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = [self.searchResults[searchTerm] objectAtIndex:indexPath.row];
    
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.width += 35; retval.width +=35;
    return retval;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

















@end
