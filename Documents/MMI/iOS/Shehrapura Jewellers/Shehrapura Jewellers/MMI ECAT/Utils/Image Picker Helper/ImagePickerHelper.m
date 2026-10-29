//
//  ImagePickerHelper.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ImagePickerHelper.h"

@interface ImagePickerHelper ()
@property (nonatomic, weak) UIViewController *presentingController;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) ImagePickedBlock completionBlock;
@end

@implementation ImagePickerHelper

- (instancetype)initWithPresentingController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.presentingController = controller;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES; // ✅ Built-in cropping
    }
    return self;
}

- (void)showImagePickerOptionsWithCompletion:(ImagePickedBlock)completion {
    self.completionBlock = completion;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Image"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self.presentingController presentViewController:alert animated:YES completion:nil];
}

- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self.presentingController presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"Camera not available");
    }
}

- (void)openGallery {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = YES;
    [self.presentingController presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock(editedImage);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

