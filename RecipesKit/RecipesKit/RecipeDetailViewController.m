//
//  RecipeDetailViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "ServingsViewController.h"
#import "AppDelegate.h"

@interface RecipeDetailViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIBarButtonItem *cameraButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.notesTextView.text = self.recipe.notes;
    [self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateNormal];
    [self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateHighlighted];
    self.titleTextField.text = self.recipe.title;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self localDoneTapped];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
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

#pragma UITextField delegaet
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}


@end
