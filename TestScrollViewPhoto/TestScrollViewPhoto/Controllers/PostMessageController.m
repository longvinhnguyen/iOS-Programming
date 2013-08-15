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

#define DEFAULT_TYPING_ATTRIBUTES   @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}

@interface PostMessageController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    BOOL needToResetTypingAttribute;
}

@property (nonatomic, weak) IBOutlet UIButton *avatarImageView;
@property (nonatomic, weak) IBOutlet UITextField *dateField;

@end

@implementation PostMessageController
{
    NSArray *_months;
    NSArray *_years;
    NSMutableString *_dateString;
    NSString *month, *year;
}

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
    
    _dateField.inputView = self.datePickerView;
    
    _months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    _years = @[@"2013", @"2014", @"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2025", @"2026", @"2027", @"2028", @"2029", @"2030"];
    _dateString = [NSMutableString new];
    month = @"";
    year = @"";
    _dateField.delegate = self;
    NSLog(@"%.2d %d", 6, 2012);
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
        if (_textField.isFirstResponder) {
            [_textField resignFirstResponder];
        } else if (_dateField.isFirstResponder) {
            [_dateField resignFirstResponder];
        }
    }
}

#pragma mark - Accessor methods
- (UIPickerView *)datePickerView
{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc] init];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
        _datePickerView.showsSelectionIndicator = YES;
    }
    return _datePickerView;
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

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        NSLog(@"dateField y: %f", _datePickerView.frame.size.height);
        self.view.frame = CGRectMake(0, 0 - _datePickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
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

#pragma mark - UIImagePickerController delegate
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

#pragma mark - UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (component) {
        case 0:
            title = _months[row];
            break;
        case 1:
            title = _years[row];
            break;
        default:
            break;
    }
    return title;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *title;
    switch (component) {
        case 0:
            title = [[NSAttributedString alloc] initWithString:_months[row] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:12.0f], NSForegroundColorAttributeName: [UIColor blueColor]}];
            break;
        case 1:
            title = [[NSAttributedString alloc] initWithString:_years[row] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]}];
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _months.count;
    } else {
        return _years.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        month = _months[row];
    } else if (component == 1) {
        year = _years[row];
    }
    _dateField.text = [NSString stringWithFormat:@"%@/%@", month, year];
}



@end
