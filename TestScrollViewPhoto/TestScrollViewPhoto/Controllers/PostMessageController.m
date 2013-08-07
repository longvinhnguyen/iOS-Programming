//
//  PostMessageController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/5/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "PostMessageController.h"
#import <QuartzCore/QuartzCore.h>

@interface PostMessageController ()

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
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [attrText setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:NSMakeRange(textView.text.length-1, 1)];
        textView.attributedText = attrText;
    } else if ([text isEqualToString:@" "]) {
        [textView setTypingAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    }
    textView.selectedRange = range;
    return YES;
}

//- (void)highLightConnectText:(UITextView *)textView
//{
//    NSError *error = NULL;
//    NSString *pattern = @"@([A-z]|[0-9])+";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
//                                                                           options:NSRegularExpressionCaseInsensitive
//                                                                             error:&error];
//    NSArray *results = [regex matchesInString:textView.text options:NSMatchingReportProgress range:NSMakeRange(0, textView.text.length)];
//    if (results.count > 0) {
//        // hightlight the connect text
//        NSMutableAttributedString *copyAttr = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//        for (NSTextCheckingResult *match in results) {
//            NSRange range = match.range;
//            [textView.attributedText enumerateAttributesInRange:range options:kNilOptions usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                if (attrs[NSForegroundColorAttributeName] != [UIColor redColor]) {
//                    [copyAttr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
//                    [textView setScrollEnabled:NO];
//                    textView.attributedText = copyAttr;
//                    if ([textView.text characterAtIndex:textView.text.length-1] == ' ') {
//                        [copyAttr setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:textView.selectedRange];
//                        textView.attributedText = copyAttr;
//                    }
//                    textView.selectedRange = NSMakeRange(textView.text.length, 0);
//                    [textView setScrollEnabled:YES];
//                }
//            }];
//        }
//    }
//}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"TextViewDid change %@", [textView.attributedText string]);
//    [self highLightConnectText:textView];
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
