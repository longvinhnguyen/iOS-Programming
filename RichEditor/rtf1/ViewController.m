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
#import "AutoCoding.h"

@interface ViewController () <UITextViewDelegate, FontsViewControllerDelegate, ColorViewControllerDelegate, UIAlertViewDelegate>
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
    
    self.title = [[self.fileName lastPathComponent] stringByDeletingLastPathComponent];
    
    @try {
        editor.attributedText = [NSAttributedString objectWithContentsOfFile:self.fileName];
    }
    @catch (NSException *exception) {
        editor.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    @finally {
        
    }
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
    if ([editor.attributedText writeToFile:self.fileName atomically:YES]) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Note saved" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"There is an error when saving the note. Please try again." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSRange selection = editor.selectedRange;
    if (selection.length > 0) {
        NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithAttributedString:editor.attributedText];
        
        [editor.attributedText enumerateAttributesInRange:selection options:kNilOptions usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSShadow *currentShadow = attrs[NSShadowAttributeName];
            NSShadow *newShadow = [[NSShadow alloc] init];
            
            if (!currentShadow || currentShadow.shadowBlurRadius == 0) {
                newShadow.shadowColor = [UIColor redColor];
                newShadow.shadowBlurRadius = 6.0f;
            } else {
                newShadow.shadowColor = [UIColor clearColor];
                newShadow.shadowBlurRadius = 0;
            }
            
            [a addAttribute:NSShadowAttributeName value:newShadow range:range];
        }];
        
        editor.attributedText = a;
        editor.selectedRange = selection;
    } else {
        NSMutableDictionary *pendingAttrs = [[NSMutableDictionary alloc] initWithDictionary:editor.typingAttributes];
        
        NSShadow *currentShadow = pendingAttrs[NSShadowAttributeName];
        NSShadow* newShadow = [[NSShadow alloc] init];
        
        if (!currentShadow || currentShadow.shadowBlurRadius == 0) {
            newShadow.shadowColor = [UIColor redColor];
            newShadow.shadowBlurRadius = 6.0f;
        } else {
            newShadow.shadowColor = [UIColor clearColor];
            newShadow.shadowBlurRadius = 0;
        }
        
        [pendingAttrs setObject:newShadow forKey:NSShadowAttributeName];
        editor.typingAttributes = pendingAttrs;
    }
    
    
}

-(IBAction)btnColorTapped:(id)sender
{
}

-(IBAction)btnFontTapped:(id)sender
{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"fonts"] == NSOrderedSame) {
        FontsViewController *screen = segue.destinationViewController;
        screen.delegate = self;
        screen.preselectedFont = editor.typingAttributes[NSFontAttributeName];
        return;
    } else if ([segue.identifier compare:@"colors"] ==  NSOrderedSame) {
        ColorViewController *screen = segue.destinationViewController;
        screen.delegate = self;
        return;
    }
}

#pragma mark
#pragma mark - FontsViewController & ColorViewController delegate
- (void)selectedFontName:(NSString *)fontName withSize:(NSNumber *)fontSize
{
    NSDictionary *fontStyle = @{NSFontAttributeName: [UIFont fontWithName:fontName size:[fontSize floatValue]]};
    [self applyAttributesToTextArea:fontStyle];
}

- (void)selectedColor:(UIColor *)color
{
    NSDictionary *colorStyle = @{NSForegroundColorAttributeName: color};
    [self applyAttributesToTextArea:colorStyle];
}

@end
