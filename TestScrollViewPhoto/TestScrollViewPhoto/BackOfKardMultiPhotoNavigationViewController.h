//
//  BackOfKardMultiPhotoNavigationViewController.h
//  VISIKARD
//
//  Created by VisiKard MacBook Pro on 5/31/13.
//
//

#import <UIKit/UIKit.h>



@interface BackOfKardMultiPhotoNavigationViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (id)initWithPhotoUrls:(NSArray *)photoUrls withIndex:(NSInteger)index andHeight:(int)height;

@end
