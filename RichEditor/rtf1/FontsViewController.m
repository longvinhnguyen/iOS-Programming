//
//  FontsViewController.m
//  rtf1
//
//  Created by Marin Todorov on 07/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "FontsViewController.h"

@interface FontsViewController () <UIPickerViewDataSource>
{
    IBOutlet UIPickerView* fontPicker;
    IBOutlet UIButton* btnApply;
    
    NSArray *fontsDataSource;
    
    NSTimer *timer;
    float delta;
    NSShadow *shadow;
}

@end

@implementation FontsViewController

-(void)awakeFromNib
{
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Font picker";
    
    fontsDataSource = @[@[@12, @14, @18, @24], @[@"Arial", @"AmericanTypewriter", @"Helvetica", @"Zapfino", @"Comfortaa"]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSArray *fontSizes = fontsDataSource[0];
    
    for (int i = 0; i < fontSizes.count; i++) {
        NSNumber *size = fontSizes[i];
        if ([size floatValue] == self.preselectedFont.pointSize) {
            [fontPicker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    
    NSArray *fontNames = fontsDataSource[1];
    
    for (int i = 0; i < fontNames.count; i++) {
        NSString *name = fontNames[i];
        if ([name compare:self.preselectedFont.fontName] == NSOrderedSame) {
            [fontPicker selectRow:i inComponent:1 animated:YES];
            break;
        }
    }
    
    shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0.42 blue:0.039 alpha:1];
    shadow.shadowBlurRadius =  0.0f;
    delta = 0.2;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(glow:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
}


#pragma mark UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return fontsDataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSArray *)fontsDataSource[component]).count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id data = ((NSArray *)fontsDataSource[component])[row];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[data description]];
    if (component == 0) {
        float pointSize = [(NSNumber *)data floatValue];
        NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:pointSize]};
        
        [title setAttributes:attr range:NSMakeRange(0, title.length)];
    } else if (component == 1) {
        NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:data size:16.0]};
        [title setAttributes:attr range:NSMakeRange(0, title.length)];
    }
    return title;
}

#pragma mark button actions
-(IBAction)btnDoneTapped:(id)sender
{
    int selectedFontSizeIndex = [fontPicker selectedRowInComponent:0];
    int selectedFontNameIndex = [fontPicker selectedRowInComponent:1];
    
    NSNumber *fontSize = fontsDataSource[0][selectedFontSizeIndex];
    NSString *fontName = fontsDataSource[1][selectedFontNameIndex];
    
    [self.delegate selectedFontName:fontName withSize:fontSize];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)glow:(NSTimer *)timer
{
    shadow.shadowBlurRadius += delta;
    if (shadow.shadowBlurRadius > 6) delta = -0.2;
    if (shadow.shadowBlurRadius < 0) delta = 0.2;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@" Apply " attributes:@{NSShadowAttributeName: shadow, NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [btnApply setAttributedTitle:title forState:UIControlStateNormal];
    });
}

@end
