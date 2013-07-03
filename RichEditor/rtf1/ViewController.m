//
//  ViewController.m
//  rtf1
//
//  Created by Marin Todorov on 07/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "ViewController.h"
#import "FontsViewController.h"
#import "ColorViewController.h"

@interface ViewController () <UITextViewDelegate>
{
    IBOutlet UITextView* editor;
    IBOutlet UIView* toolbar;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    toolbar.center = CGPointMake(160, 480);
    editor.allowsEditingTextAttributes = YES;
    [editor becomeFirstResponder];
}

- (void)applyAttributesToTextArea:(NSDictionary *)attrs
{
    NSRange selection = editor.selectedRange;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:editor.attributedText];
    
    [text addAttributes:attrs range:selection];
    editor.attributedText = text;
    editor.selectedRange = selection;
}

-(IBAction)btnSaveTapped:(id)sender
{
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.4 animations:^{
        toolbar.center = CGPointMake(160, 180);
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.4 animations:^{
        toolbar.center = CGPointMake(160, 440);
    }];
    return YES;
}

-(IBAction)btnBTapped:(id)sender
{
    NSRange selection = editor.selectedRange;
    
    if (selection.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Select text to highlight first" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        return;
    }
    UIColor *bgColor = [editor.attributedText attribute:NSBackgroundColorAttributeName atIndex:selection.location effectiveRange:nil];
    
    
    UIColor *newColor;
    if (CGColorGetAlpha(bgColor.CGColor) == 0.0) {
        newColor = [UIColor yellowColor];
    } else {
        newColor = [UIColor clearColor];
    }
    
    NSDictionary *bgStyle = @{NSBackgroundColorAttributeName: newColor};
    [self applyAttributesToTextArea:bgStyle];

}


-(IBAction)btnITapped:(id)sender
{
}

-(IBAction)btnColorTapped:(id)sender
{
}

-(IBAction)btnFontTapped:(id)sender
{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
