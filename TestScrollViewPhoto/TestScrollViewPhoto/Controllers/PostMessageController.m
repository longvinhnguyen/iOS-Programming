//
//  PostMessageController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/5/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "PostMessageController.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_TYPING_ATTRIBUTES   @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}

@interface PostMessageController ()
{
    BOOL needToResetTypingAttribute;
}

@end

@implementation PostMessageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(postMessage:)]];
    _textField.layer.borderWidth = 1.0f;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.cornerRadius = 8.0f;
    _textField.typingAttributes = DEFAULT_TYPING_ATTRIBUTES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        [_textField resignFirstResponder];
    }
}

#pragma mark - UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"@"]) {
        [textView setTypingAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    } else if ([text isEqualToString:@" "]) {
        needToResetTypingAttribute = YES;
    } else if ([text isEqualToString:@""]) {
        UITextPosition *beginning = [textView beginningOfDocument];
        UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
        UITextPosition *end = [textView positionFromPosition:beginning offset:range.location+range.length];
        UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
        end = [textView positionFromPosition:beginning offset:range.location+range.length];
        NSString *deletedText = [textView textInRange:textRange];
        
        start = [textView positionFromPosition:beginning offset:range.location - 1];
        end = [textView positionFromPosition:beginning offset:range.location - 1 + range.length];
        textRange = [textView textRangeFromPosition:start toPosition:end];
        NSString *besideText = [textView textInRange:textRange];
        if (![besideText isEqualToString:@"@"]) {
            if ([deletedText isEqualToString:@"@"]) {
                needToResetTypingAttribute = YES;
            }
        }
    }

    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (needToResetTypingAttribute) {
        textView.typingAttributes = DEFAULT_TYPING_ATTRIBUTES;
        needToResetTypingAttribute = NO;
    }
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@", textView.text);
}

#pragma mark - Action methods
- (void)postMessage:(UIButton *)sender
{
    NSLog(@"Post status to FB/Twitter");
}

@end
