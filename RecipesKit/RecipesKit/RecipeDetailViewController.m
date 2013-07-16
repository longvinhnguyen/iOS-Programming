//
//  RecipeDetailViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import <Social/Social.h>

#import "RecipeDetailViewController.h"
#import "ServingsViewController.h"
#import "AppDelegate.h"
#import "Image.h"
#import "PhotosViewController.h"

@interface RecipeDetailViewController ()<UITextFieldDelegate, UIPageViewControllerDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIBarButtonItem *cameraButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *servingsButton;
@property (nonatomic, weak) IBOutlet UITextField *titleTextField;


@end

@implementation RecipeDetailViewController

#pragma mark - Properties

- (void)setRecipe:(Recipe *)newRecipe
{
    // Only set the new recipe if it's not the same one that's currently stored
    if (_recipe != newRecipe)
    {
        _recipe = newRecipe;
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionTapped)];
    self.cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(localDoneTapped)];
    
    self.navigationItem.rightBarButtonItems = @[self.actionButton, self.cameraButton];
    _pageViewController.view.backgroundColor = [UIColor clearColor];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.notesTextView.text = self.recipe.notes;
    [self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateNormal];
    [self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateHighlighted];
    self.titleTextField.text = self.recipe.title;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self localDoneTapped];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    if ([self.view window] == nil) {
        _actionButton = nil;
        _cameraButton = nil;
        _doneButton = nil;
        _imagePickerController = nil;
        _notesTextView = nil;
        _pageViewController = nil;
        _scrollView = nil;
        _servingsButton = nil;
        _titleTextField = nil;
        self.view = nil;
    }
    [super didReceiveMemoryWarning];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#else

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation *)interfaceOrientation
{
    return NO;
}

#endif


- (void)keyboardWillHide:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.cameraButton, self.actionButton];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = self.view.bounds;
}

- (void)keyboardWillShow:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.doneButton, self.actionButton];
    
    CGRect keyBoardFrame = [[userInfo.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyBoardFrame.size.height);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pageViewController"]) {
        if (self.recipe.images.count > 0) {
            self.pageViewController = (UIPageViewController *)segue.destinationViewController;
            self.pageViewController.dataSource = self;
            
            PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
            photosViewController.index = 0;
            
            Image *image = [self.recipe.images allObjects][0];
            photosViewController.image = image.image;
            
            [self.pageViewController setViewControllers:@[photosViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            
        }
    }
}

#pragma mark - RecipeDetailViewController actions
- (IBAction)doneTapped:(UIStoryboardSegue *)segue
{
    ServingsViewController *servingsViewController = (ServingsViewController *)segue.sourceViewController;
    NSNumber *servings = @(([servingsViewController.pickerView selectedRowInComponent:0] + 1));
    
    self.recipe.servings = servings;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

- (void)actionTapped
{
    NSString *titleString = [NSString stringWithFormat:@"I just made a delicious %@ recipe using Recipes Kit.", self.recipe.title];
    
    UIImage *activityImage;
    
    if (self.recipe.images.count > 0) {
        Image *image = [self.recipe.images anyObject];
        activityImage = image.image;
    }
    
    NSArray *items = @[titleString];
    if (activityImage) {
        items = @[titleString, activityImage];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)cameraTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete All Images" otherButtonTitles:@"Select Image", nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)localDoneTapped
{
    if (self.notesTextView.isFirstResponder) {
        [self.notesTextView resignFirstResponder];
    } else if (self.titleTextField.isFirstResponder) {
        [self.titleTextField resignFirstResponder];
    }
    self.recipe.title = self.titleTextField.text;
    self.recipe.notes = self.notesTextView.text;
    
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    //
    float actualHeight = selectedImage.size.height;
    float actualWidth = selectedImage.size.width;
    float imageRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/180;
    
    if (imageRatio != maxRatio) {
        if (imageRatio < maxRatio) {
            imageRatio = 180 / actualHeight;
            actualWidth = imageRatio * actualWidth;
            actualHeight = 180;
        } else {
            imageRatio = 320 / actualWidth;
            actualHeight = imageRatio * actualHeight;
            actualWidth = 320;
        }
    }
    
    CGRect rect = CGRectMake(0, 0, actualWidth, actualHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    [selectedImage drawInRect:rect];
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    image.image = croppedImage;
    [self.recipe addImagesObject:image];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Append Data Save Error = %@", error.localizedDescription);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

#pragma mark
#pragma mark - UIPageViewController datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PhotosViewController *previousViewController = (PhotosViewController *)viewController;
    
    NSUInteger pagesCount = self.recipe.images.count;
    pagesCount -- ;
    
    if (previousViewController.index == pagesCount) {
        return nil;
    }
    
    PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
    photosViewController.index = previousViewController.index + 1;
    photosViewController.image = [[[self.recipe.images allObjects] objectAtIndex:photosViewController.index] image];
    
    return photosViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PhotosViewController *previousViewController = (PhotosViewController *)viewController;
    
    if (previousViewController.index == 0) {
        return nil;
    }
    
    PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
    photosViewController.index = previousViewController.index - 1;
    photosViewController.image = [[[self.recipe.images allObjects] objectAtIndex:photosViewController.index] image];
    
    return photosViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.recipe.images.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    PhotosViewController *photosViewController = [pageViewController.viewControllers lastObject];
    
    return photosViewController.index;
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.recipe removeImages:self.recipe.images];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}


@end
