//
//  AddBanner.m
//  Jewel Desk
//
//  Created by App Dev on 10/03/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AddBanner.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"

@interface AddBanner (){
    NSString *str_type;
    NSString *str_img1;
    NSString *str_img2;
    NSString *str_img3;
}
@end

@implementation AddBanner

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Banner";
    //img_1.contentMode = UIViewContentModeScaleAspectFit;
    str_img1 = @"";
    str_img2 = @"";
    str_img3 = @"";

    UITapGestureRecognizer *singleTapBusiness = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected_img1)];
    singleTapBusiness.numberOfTapsRequired = 1;
    [img_1 setUserInteractionEnabled:YES];
    [img_1 addGestureRecognizer:singleTapBusiness];
    [img_1.layer setMasksToBounds:YES];
    [img_1.layer setCornerRadius:10.0f];
    [img_1.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [img_1.layer setBorderWidth:1];
    //[self.view addSubview:img_1];
    
    UITapGestureRecognizer *singleTapBusiness2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected_img2)];
    singleTapBusiness2.numberOfTapsRequired = 1;
    [img_2 setUserInteractionEnabled:YES];
    [img_2 addGestureRecognizer:singleTapBusiness2];
    [img_2.layer setMasksToBounds:YES];
    [img_2.layer setCornerRadius:10.0f];
    [img_2.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [img_2.layer setBorderWidth:1];
    //[self.view addSubview:img_2];
    
    UITapGestureRecognizer *singleTapBusiness3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected_img3)];
    singleTapBusiness3.numberOfTapsRequired = 1;
    [img_3 setUserInteractionEnabled:YES];
    [img_3 addGestureRecognizer:singleTapBusiness3];
    [img_3.layer setMasksToBounds:YES];
    [img_3.layer setCornerRadius:10.0f];
    [img_3.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [img_3.layer setBorderWidth:1];
    //[self.view addSubview:img_3];
}

-(void)tapDetected_img1 {
    str_type = @"image1";
    str_img1 = @"YES";
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Please Select image" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CameraButton = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        self->pickerControllerCamera = [[UIImagePickerController alloc] init];
        self->pickerControllerCamera.delegate = self;
        self->pickerControllerCamera.allowsEditing = YES;
        self->pickerControllerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self->pickerControllerCamera animated:YES completion:NULL];
    }];
    
    UIAlertAction* GalleryButton = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //Handle no, thanks button
        self->pickerControllerGallery = [[UIImagePickerController alloc] init];
        self->pickerControllerGallery.delegate = self;
        self->pickerControllerGallery.allowsEditing = YES;
        self->pickerControllerGallery.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:self->pickerControllerGallery animated:YES completion:NULL];
    }];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
    }];
    
    //Add your buttons to alert controller
    [alert addAction:CameraButton];
    [alert addAction:GalleryButton];
    [alert addAction:CancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tapDetected_img2 {
    str_type = @"image2";
    str_img2 = @"YES";

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Please Select image"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CameraButton = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        self->pickerControllerCamera = [[UIImagePickerController alloc] init];
        self->pickerControllerCamera.delegate = self;
        self->pickerControllerCamera.allowsEditing = YES;
        self->pickerControllerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self->pickerControllerCamera animated:YES completion:NULL];
    }];
    
    UIAlertAction* GalleryButton = [UIAlertAction
                                    actionWithTitle:@"Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
        //Handle no, thanks button
        
        self->pickerControllerGallery = [[UIImagePickerController alloc] init];
        self->pickerControllerGallery.delegate = self;
        self->pickerControllerGallery.allowsEditing = YES;
        self->pickerControllerGallery.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:self->pickerControllerGallery animated:YES completion:NULL];
    }];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
    }];
    
    //Add your buttons to alert controller
    [alert addAction:CameraButton];
    [alert addAction:GalleryButton];
    [alert addAction:CancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tapDetected_img3 {
    str_type = @"image3";
    str_img3 = @"YES";

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Please Select image"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CameraButton = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        self->pickerControllerCamera = [[UIImagePickerController alloc] init];
        self->pickerControllerCamera.delegate = self;
        self->pickerControllerCamera.allowsEditing = YES;
        self->pickerControllerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self->pickerControllerCamera animated:YES completion:NULL];
    }];
    
    UIAlertAction* GalleryButton = [UIAlertAction
                                    actionWithTitle:@"Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
        //Handle no, thanks button
        
        self->pickerControllerGallery = [[UIImagePickerController alloc] init];
        self->pickerControllerGallery.delegate = self;
        self->pickerControllerGallery.allowsEditing = YES;
        self->pickerControllerGallery.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:self->pickerControllerGallery animated:YES completion:NULL];
    }];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
    }];
    
    //Add your buttons to alert controller
    [alert addAction:CameraButton];
    [alert addAction:GalleryButton];
    [alert addAction:CancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if (picker == pickerControllerGallery) {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
           
            if ([self->str_type isEqualToString:@"image1"]) {
                self->filename = [representation filename];
                NSLog(@"fileName : %@",self->filename);
                
                self->img_1.image = [info objectForKey:UIImagePickerControllerEditedImage];
                self->img_1.image = [info objectForKey:UIImagePickerControllerOriginalImage];
                CGSize imageSize = self->img_1.image.size;
                [self->img_1 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_1.center;
                [self->img_1 setCenter:imageViewCenter];
            }else if ([self->str_type isEqualToString:@"image2"]) {
                self->filename2 = [representation filename];
                NSLog(@"fileName : %@",self->filename2);
                
                self->img_2.image = [info objectForKey:UIImagePickerControllerEditedImage];
                self->img_2.image = [info objectForKey:UIImagePickerControllerOriginalImage];
                CGSize imageSize = self->img_2.image.size;
                [self->img_2 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_2.center;
                [self->img_2 setCenter:imageViewCenter];
            }else if ([self->str_type isEqualToString:@"image3"]) {
                self->filename3 = [representation filename];
                NSLog(@"filename3 : %@",self->filename3);
                
                self->img_3.image = [info objectForKey:UIImagePickerControllerEditedImage];
                self->img_3.image = [info objectForKey:UIImagePickerControllerOriginalImage];
                CGSize imageSize = self->img_3.image.size;
                [self->img_3 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_3.center;
                [self->img_3 setCenter:imageViewCenter];
            }
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        NSLog(@"imageURL=%@",imageURL);
    }else if (picker == pickerControllerCamera) {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            if ([self->str_type isEqualToString:@"image1"]) {
                self->filename = [representation filename];
                NSLog(@"fileName : %@",self->filename);
                UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
                self->img_1.image = chosenImage;
                CGSize imageSize = self->img_1.image.size;
                [self->img_1 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_1.center;
                [self->img_1 setCenter:imageViewCenter];
            }else if ([self->str_type isEqualToString:@"image2"]) {
                self->filename2 = [representation filename];
                NSLog(@"fileName2 : %@",self->filename2);
                UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
                self->img_2.image = chosenImage;
                CGSize imageSize = self->img_2.image.size;
                [self->img_2 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_2.center;
                [self->img_2 setCenter:imageViewCenter];
            }else if ([self->str_type isEqualToString:@"image3"]) {
                self->filename3 = [representation filename];
                NSLog(@"filename3 : %@",self->filename3);
                UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
                self->img_3.image = chosenImage;
                CGSize imageSize = self->img_3.image.size;
                [self->img_3 sizeThatFits:imageSize];
                CGPoint imageViewCenter = self->img_3.center;
                [self->img_3 setCenter:imageViewCenter];
            }
            [picker dismissViewControllerAnimated:YES completion:NULL];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        NSLog(@"imageURL=%@",imageURL);
    }
}

- (IBAction)btn_save:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self send_memberimg_ToServer];
    });
}

- (void)send_memberimg_ToServer {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE_NEW"];
    NSString *URL_Config;
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    // Setting the URL based on ECAT_TYPE value
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Config = [WEB_URL URL_SAVE_BANNER_IOS];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/save_banner_ios.php", ip];
    } else {
        URL_Config = [WEB_URL URL_SAVE_BANNER_IOS];
    }
    
    NSLog(@"URL_Config ******************************* %@", URL_Config);
    NSData *imageData;
    NSString *filename;
    if (str_img1.length !=0) {
        imageData = UIImageJPEGRepresentation(img_1.image, 0.1f);
        filename = [NSString stringWithFormat:@"Slider1.jpg"];
    }
    
    NSLog(@"filename :: %@", filename);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_Config]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Prepare the parameters
    NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:ECAT_TYPE_NEW forKey:@"apptype4"];
    [params setObject:ECAT_TYPE forKey:@"apptype"];
    [params setObject:filename forKey:@"filename"];
    NSLog(@"params = %@", params);
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        [params setObject:ip forKey:@"ip"];
        [params setObject:db forKey:@"dbname"];
        [params setObject:ipusername forKey:@"ipusername"];
        [params setObject:pswd forKey:@"password"];
        [params setObject:ftppath forKey:@"ftppath"];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        [params setObject:ftppath forKey:@"ftppath"];
    }
    
    NSMutableData *body = [NSMutableData data];
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Append the image data to the body
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"myfile\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Set the body of the request
    [request setHTTPBody:body];
    
    // Create the session and data task
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[BusyIndicator sharedInstance] stopIndicator];
            });
            return;
        }
        
        // Convert the response data to string
        NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"returnString=%@", returnString);
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSString *success = jsonDict[@"success"];
        NSString *message = jsonDict[@"message"];
        
        // Log or use the values
        NSLog(@"Success: %@", success);
        NSLog(@"Message: %@", message);
        
        // Show the alert with the response
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert1:message success:success];
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            [[BusyIndicator sharedInstance] stopIndicator];
        });
    }];
    // Start the task
    [dataTask resume];
}

- (void)showAlert1:(NSString *)message success:(NSString *)success {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([success isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
