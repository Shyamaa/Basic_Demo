//
//  ImagePickerHelper.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImagePickedBlock)(UIImage *image);

@interface ImagePickerHelper : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWithPresentingController:(UIViewController *)controller;
- (void)showImagePickerOptionsWithCompletion:(ImagePickedBlock)completion;

@end

