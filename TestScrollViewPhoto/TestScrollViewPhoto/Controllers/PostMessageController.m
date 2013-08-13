//
//  PostMessageController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/5/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "PostMessageController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIImage+GIF.h>

#define DEFAULT_TYPING_ATTRIBUTES   @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}

@interface PostMessageController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL needToResetTypingAttribute;
}

@property (nonatomic, weak) IBOutlet UIButton *avatarImageView;

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

- (IBAction)changeProfileImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture", @"Choose from Photo Library", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgPicker;
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imgPicker = [[UIImagePickerController alloc] init];
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgPicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
                imgPicker.delegate = self;
                imgPicker.allowsEditing = YES;
                [self presentViewController:imgPicker animated:YES completion:nil];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"There is no camera for this device." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
            }
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imgPicker = [[UIImagePickerController alloc] init];
                imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imgPicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
                imgPicker.delegate = self;
                imgPicker.allowsEditing = YES;
                [self presentViewController:imgPicker animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage]?info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    NSLog(@"Image original data %d", [UIImagePNGRepresentation(image) length]);
    UIImage *compressedImage = [self scaleImage:image withSize:CGSizeMake(50, 50)];
    NSLog(@"Image compressed data %d", [UIImagePNGRepresentation(compressedImage) length]);
    [_avatarImageView setImage:compressedImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize )size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), YES, 1.0);
    CGRect proRect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:proRect];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
