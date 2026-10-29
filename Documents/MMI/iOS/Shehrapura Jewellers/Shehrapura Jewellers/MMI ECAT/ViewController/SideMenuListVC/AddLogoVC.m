//
//  AddLogoVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AddLogoVC.h"
#import "SWRevealViewController.h"

@interface AddLogoVC()
{}
@end

@implementation AddLogoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Add Logo";
    
    [imgLogo.layer setCornerRadius:10.0f];
    [imgLogo.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [imgLogo.layer setBorderWidth:1];
    
    [self setUpNavigationBtn];
    [self getImageLogo];
}

-(void)getImageLogo{
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    NSString *imageLogoUrl = [NSString stringWithFormat:@"%@FIRM_LOGO/logo.jpg",ftppath];
    imageLogoUrl = [imageLogoUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"Image Logo Url: - %@", imageLogoUrl);
    [imgLogo sd_setImageWithURL:[NSURL URLWithString:imageLogoUrl]
                          placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                   options:SDWebImageRefreshCached];
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]){
        
    }else{
        SWRevealViewController *revealController = [self revealViewController];
        //[revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        UIImage *image = [UIImage imageNamed:@"menu.png"];
        CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
        [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
        [someButton1 addTarget:revealController action:@selector(revealToggle:)
              forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    }
}

#pragma mark:- Button Action Method

- (IBAction)btnGetImageAction:(UIButton *)sender{
    [self selectPhoto];
}

- (IBAction)btnSaveAction:(UIButton *)sender{
    [self sendLogoImgToServer];
}

#pragma mark -  Select photo from gallery or camera
- (void)selectPhoto {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Source"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Choose from Library"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// Open camera
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Camera not available."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// Open photo library
- (void)openPhotoLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

// UIImagePickerControllerDelegate method to handle image selection
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage]; // ✅ Cropped image
    
    if (!selectedImage) {
        selectedImage = info[UIImagePickerControllerOriginalImage]; // fallback
    }
    //UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    imgLogo.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// UIImagePickerControllerDelegate method for when the user cancels
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void) uo{
//    Multipart@POST("upload_logo.php")Call<SuccessModel>
//    UPLOAD_LOGO(        @Part MultipartBody.Part file,
//                @Part("filename") RequestBody name,
//                @Part("ip") String ip,
//                @Part("ipusername") String ipusername,
//                @Part("password") String password,
//                @Part("dbname") String dbname,
//                @Part("ftppath") String ftppath,
//                @Part("apptype") String apptyp,
//                @Part("tpre") RequestBody str_tpre1); //MEMBER_IMGS
}


- (void)sendLogoImgToServer {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE_NEW"];
    NSString *URL_Config;
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    // Setting the URL based on ECAT_TYPE value
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Config = [WEB_URL URL_Upload_Logo];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/upload_logo.php", ip];
    } else {
        URL_Config = [WEB_URL URL_Upload_Logo];
    }
    
    NSLog(@"URL_Config ******************************* %@", URL_Config);
    NSData *imageData;
    NSString *filename;
    imageData = UIImageJPEGRepresentation(imgLogo.image, 0.1f);
    filename = [NSString stringWithFormat:@"logo.jpg"];
    NSLog(@"imageData length: %lu", (unsigned long)[imageData length]);
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
    //[params setObject:ECAT_TYPE_NEW forKey:@"apptype4"];
    [params setObject:ECAT_TYPE forKey:@"apptype"];
    [params setObject:filename forKey:@"filename"];
    [params setObject:@"MEMBER_IMGS" forKey:@"tpre"];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        [params setObject:ip forKey:@"ip"];
        [params setObject:db forKey:@"dbname"];
        [params setObject:ipusername forKey:@"ipusername"];
        [params setObject:pswd forKey:@"password"];
        [params setObject:ftppath forKey:@"ftppath"];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        [params setObject:ftppath forKey:@"ftppath"];
    }
    
    NSLog(@"params = %@", params);
    
    NSMutableData *body = [NSMutableData data];
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Append the image data to the body
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];

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
