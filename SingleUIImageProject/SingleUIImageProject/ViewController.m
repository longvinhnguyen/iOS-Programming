//
//  ViewController.m
//  SingleUIImageProject
//
//  Created by Jake Gundersen on 7/9/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
- (IBAction)changeSlider:(id)sender;

@end

@implementation ViewController
{
    CIImage *_image;
    EAGLContext *_context;
    CIContext *_coreImageContext;
    CIFilter *_sepiaFilter;
    CIImage *beginImage;
}

- (void)viewDidLoad
    {
    [super viewDidLoad];
        
//    NSArray *ciFilters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    for (NSString *filter in ciFilters) {
//        NSLog(@"filter name %@", filter);
//        NSLog(@"filter %@", [[CIFilter filterWithName:filter] attributes]);
//    }
        
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!_context) {
            NSLog(@"No EAGL context created");
        }
        
    _coreImageContext = [CIContext contextWithEAGLContext:_context];
        
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hubble" ofType:@"png"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    CIImage *image = [CIImage imageWithContentsOfURL:fileURL];
        
    _sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [_sepiaFilter setValue:image forKey:kCIInputImageKey];
    [_sepiaFilter setValue:@1.0 forKey:@"inputIntensity"];
        
    CGImageRef cgImg = [_coreImageContext createCGImage:_sepiaFilter.outputImage fromRect:_sepiaFilter.outputImage.extent];
    


    UIImage *uiImage = [UIImage imageWithCGImage:cgImg];
    self.imgView.image = uiImage;
        CGImageRelease(cgImg);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)changeSlider:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_sepiaFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputIntensity"];
    
    CGImageRef cgImg = [_coreImageContext createCGImage:_sepiaFilter.outputImage fromRect:_sepiaFilter.outputImage.extent];
    UIImage *uiImage = [UIImage imageWithCGImage:cgImg];
    self.imgView.image = uiImage;
    CGImageRelease(cgImg);
}

- (IBAction)loadPhoto:(id)sender
{
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)savePhoto:(id)sender
{
    CIImage *saveToSave = [_sepiaFilter outputImage];
    CGImageRef cgImg = [_coreImageContext createCGImage:saveToSave fromRect:saveToSave.extent];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg metadata:[saveToSave properties] completionBlock:^(NSURL *assetURL, NSError *error) {
        CGImageRelease(cgImg);
        NSLog(@"Finish save image to album");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    [_sepiaFilter setValue:beginImage forKey:kCIInputImageKey];
    [self changeSlider:_amountSlider];
    
}


@end
