//
//  AddBanner.h
//  Jewel Desk
//
//  Created by App Dev on 10/03/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "webUrlconstant.h"
#import <Photos/Photos.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddBanner : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *img_1;
    IBOutlet UIImageView *img_2;
    IBOutlet UIImageView *img_3;
    UIImagePickerController *pickerControllerGallery;
    UIImagePickerController *pickerControllerCamera;
    NSString *filename;
    NSString *filename2;
    NSString *filename3;

}

- (IBAction)btn_save:(id)sender;


@end

NS_ASSUME_NONNULL_END
