//
//  PostMessageController.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/5/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostMessageController : UIViewController<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textField;
@property (nonatomic, strong) UIPickerView *datePickerView;

@end
