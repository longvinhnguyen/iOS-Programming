//
//  DetailViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/29/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface DetailViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *assetTypeButton;
    
    UIPopoverController *imagePickerPopover;
}

@property (nonatomic, strong)BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)takePicture:(id)sender;
- (IBAction)backGroundTapped:(id)sender;
- (id)initForNewItem:(BOOL)isNew;
- (IBAction)showAssetTypePicker:(id)sender;
                              

@end
