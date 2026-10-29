//
//  AddDesign.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/10/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "AddItemActivity.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "HomeBannerCell.h"

@interface AddItemActivity ()

@end

@implementation AddItemActivity
@synthesize str_imgurl,str_tag,str_activity,str_wt,str_gst,str_gwt,str_mrp,str_tgno,str_tpre,str_idesc,str_stamp,str_sdiawt,str_sstnwt,str_imgurl2,str_imgurl3,str_imgurl4,str_imgurl5,str_remarks,str_salemrp,str_tgimage,str_min_stock;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Design";
    lbl_tag.text = str_tag;
    NSLog(@"str_imgurl ******************** %@",str_imgurl);
    NSURL *URL = [NSURL URLWithString:str_imgurl];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
   
    [btn_item.layer setMasksToBounds:YES];
    [btn_item.layer setCornerRadius:10.0f];
    [btn_item.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_item.layer setBorderWidth:1];
    scrollview.delegate = self;
    scrollview.userInteractionEnabled = YES;
    [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, 2000)];
    [self.view addSubview:scrollview];
    [self->btn_item setTitle:self->str_tgno forState:UIControlStateNormal];
    self.imagesArray = [NSMutableArray array];
    [btn_item setTintColor: UIColor.blackColor];
    self->btn_item.userInteractionEnabled = true;
    txt_tgno.userInteractionEnabled = false;
    NSArray *stampData = @[@"18K", @"22K"];
    [txt_stamp addPickerWithData:stampData searchEnabled:NO];
    if (str_tgno.length>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpViewData];
        });
    }else{
        [self scrollData_Com];
    }
}

- (void)setUpViewData{
    // Load remote images and append only after they finish downloading
    if (str_imgurl.length>0) {
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:str_imgurl]
                             placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArray addObject:image];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.bannerCollectionView reloadData];
//                });
            }
        }];
    }
    if (str_imgurl2.length>0) {
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:str_imgurl2]
                             placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArray addObject:image];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.bannerCollectionView reloadData];
//                });
            }
        }];
    }
    if (str_imgurl3.length>0) {
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:str_imgurl3]
                             placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArray addObject:image];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.bannerCollectionView reloadData];
//                });
            }
        }];
    }
    if (str_imgurl4.length>0) {
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:str_imgurl4]
                             placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArray addObject:image];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.bannerCollectionView reloadData];
//                });
            }
        }];
    }
    if (str_imgurl5.length>0) {
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:str_imgurl5]
                             placeholderImage:[UIImage imageNamed:@"plusitem.png"]
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArray addObject:image];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.bannerCollectionView reloadData];
//                });
            }
        }];
    }
    [btn_item setTitle:self->str_idesc forState:UIControlStateNormal];
    [btn_item setBackgroundColor:UIColor.lightGrayColor];
    btn_item.userInteractionEnabled = false;
    [txt_tgno setBackgroundColor:UIColor.lightGrayColor];
    txt_tgno.text = str_tgno;
    txt_stamp.text = SafeString(str_stamp).length > 0 ? str_stamp : @"";
    txt_gwt.text = str_gwt;
    txt_nwt.text = str_wt;
    txt_stonewt.text = str_sstnwt;
    txt_diawt.text = str_sdiawt;
    txt_mrp.text = str_mrp;
    txt_gst.text = str_gst;
    txt_remark.text = str_remarks;
    //txt_youtube.text = str_activity;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bannerCollectionView reloadData];
    });
    itemDetailsView.userInteractionEnabled = true;
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    if (![softid isEqualToString:@"SQLECAT"] && softid.length > 0){//&& ![softid isEqualToString:@"SQLQR"]) {
        itemDetailsView.userInteractionEnabled = false;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_tgno) {
        [txt_stamp becomeFirstResponder];
    }else if (textField == txt_stamp) {
        [txt_gwt becomeFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    }else if (textField == txt_gwt) {
        [txt_nwt becomeFirstResponder];
    }else if (textField == txt_nwt) {
        [txt_stonewt becomeFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);
    }else if (textField == txt_stonewt) {
        [txt_diawt becomeFirstResponder];
    }else if (textField == txt_diawt) {
        [txt_mrp becomeFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-150, 0, 0, 0);
    }else if (textField == txt_mrp) {
        [txt_gst becomeFirstResponder];
    }else if (textField == txt_gst) {
        [txt_remark becomeFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-200, 0, 0, 0);
    }else if (textField == txt_remark) {
        [txt_youtube becomeFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-250, 0, 0, 0);
    }else if (textField == txt_youtube) {
        [txt_youtube resignFirstResponder];
        scrollview.contentInset = UIEdgeInsetsMake(-0, 0, 0, 0);
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)tapDetected_member{
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
    UIAlertAction * CancelButton = [UIAlertAction
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

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    return cropped;
}

#pragma mark:- Api methods

- (void)send_memberimg_ToServer {
    [[BusyIndicator sharedInstance]startIndicator];
    NSString * idesc = str_tgno;
    NSString * tgno = txt_tgno.text;
    NSString * gwt = txt_gwt.text;
    NSString * nwt = txt_nwt.text;
    NSString * dwt = txt_diawt.text;
    NSString * stonewt = txt_stonewt.text;
    NSString * mrp = txt_mrp.text;
    NSString * stamp = txt_stamp.text;
    NSString * gst = txt_gst.text;
    NSString * billamt = @"";
    NSString * remarks = txt_remark.text;
    NSString * remarks2 = @"";
    NSString * tgimage = @"";
    NSString * tpre = str_tpre;
    NSString * vtgno = @"";
    NSString * category = @"";
    NSString * activity = str_activity;
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *URL_Config;
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Config =[WEB_URL URL_SAVE_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/save_item_ios.php",ip];
    }else{
        URL_Config = [WEB_URL URL_SAVE_ITEM];
    }
    tpre = [tpre stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tpre = [tpre stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tpre = [tpre stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //img_add.image = self.imagesArray.firstObject;
    UIImage *croppedImage = [self imageByCropping:img_add.image toRect:CGRectMake(10, 10, 200, 100)];
    NSData *imageData = UIImageJPEGRepresentation(img_add.image, 0.1f);
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate=[dateFormatter stringFromDate:[NSDate date]];
    
    NSString *stringWithoutSpaces = [curDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *stringWithoutSpaces1 = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *currentdate = [stringWithoutSpaces1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //filename = [NSString stringWithFormat:@"%@.jpg", tgno];
    //NSLog(@"filename :: %@",filename);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_Config]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",ECAT_TYPE_NEW] forKey:@"apptype4"];
    [_params setObject:[NSString stringWithFormat:@"%@",ECAT_TYPE] forKey:@"apptype"];
    [_params setObject:[NSString stringWithFormat:@"%@",ip] forKey:@"ip"];
    [_params setObject:[NSString stringWithFormat:@"%@",db] forKey:@"dbname"];
    [_params setObject:[NSString stringWithFormat:@"%@",ipusername] forKey:@"ipusername"];
    [_params setObject:[NSString stringWithFormat:@"%@",pswd] forKey:@"password"];
    [_params setObject:[NSString stringWithFormat:@"%@",ftppath] forKey:@"ftppath"];
    //[_params setObject:[NSString stringWithFormat:@"%@",filename] forKey:@"filename"];
    [_params setObject:[NSString stringWithFormat:@"%@",idesc] forKey:@"idesc"];
    [_params setObject:[NSString stringWithFormat:@"%@",tgno] forKey:@"tgno"];
    [_params setObject:[NSString stringWithFormat:@"%@",gwt] forKey:@"gwt"];
    [_params setObject:[NSString stringWithFormat:@"%@",nwt] forKey:@"nwt"];
    [_params setObject:[NSString stringWithFormat:@"%@",dwt] forKey:@"dwt"];
    [_params setObject:[NSString stringWithFormat:@"%@",stonewt] forKey:@"stonewt"];
    [_params setObject:[NSString stringWithFormat:@"%@",mrp] forKey:@"mrp"];
    [_params setObject:[NSString stringWithFormat:@"%@",stamp] forKey:@"stamp"];
    [_params setObject:[NSString stringWithFormat:@"%@",gst] forKey:@"gst"];
    [_params setObject:[NSString stringWithFormat:@"%@",billamt] forKey:@"billamt"];
    [_params setObject:[NSString stringWithFormat:@"%@",remarks] forKey:@"remarks"];
    [_params setObject:[NSString stringWithFormat:@"%@",remarks2] forKey:@"remarks2"];
    [_params setObject:[NSString stringWithFormat:@"%@",tgimage] forKey:@"tgimage"];
    [_params setObject:[NSString stringWithFormat:@"%@",tpre] forKey:@"tpre"];
    [_params setObject:[NSString stringWithFormat:@"%@",vtgno] forKey:@"vtgno"];
    [_params setObject:[NSString stringWithFormat:@"%@",category] forKey:@"category"];
    [_params setObject:[NSString stringWithFormat:@"%@",activity] forKey:@"activity"];
    NSLog(@"_params = %@", _params);
    NSMutableData *body = [NSMutableData data];
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   // [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"myfile\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // now lets make the connection to the web
    
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"returnString=%@",returnString);
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[BusyIndicator sharedInstance]stopIndicator];
            });
            return;
        }
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
            // Upload additional images one-by-one (including index 0)
            //NSString *imageURL = [WEB_URL URL_UpLoadImage];
            NSString *imageUploadURL = [WEB_URL URL_UpLoadImage];
            if ([ECAT_TYPE isEqualToString:@"2"]) {
                NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
                imageUploadURL = [NSString stringWithFormat:@"http://%@/jwellyecat/upload_image.php", ip];
            }

            [self uploadImagesSequentiallyWithURL:imageUploadURL baseTag:tgno index:0 successCount:0 completion:^(NSInteger successCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[BusyIndicator sharedInstance]stopIndicator];
                    if (successCount == self.imagesArray.count) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                       message:@"All images uploaded successfully!"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Incomplete"
                                                                                       message:[NSString stringWithFormat:@"Only %ld out of %ld images uploaded.", (long)successCount, (long)self.imagesArray.count]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            }];
        }
    }];
    [dataTask resume];
}

// Add a completion block to uploadImage
- (void)uploadImage:(UIImage *)image
              toURL:(NSString *)url
           fileName:(NSString *)strFileName
         completion:(void (^)(BOOL success))completion {

    //UIImage *croppedImage = [self imageByCropping:image toRect:CGRectMake(10, 10, 100, 100)];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4f);
    if (!imageData) {
        NSLog(@"Image conversion failed.");
        if (completion) completion(NO);
        return;
    }

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSURL *imageURL = [NSURL URLWithString:url];
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];

    // Helper block to add form field
    void (^appendFormField)(NSString *, NSString *) = ^(NSString *key, NSString *value) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
    };

    // Add POST parameters
    appendFormField(@"apptype", ECAT_TYPE ?: @"");

    // Add optional params for ECAT_TYPE == 1
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        appendFormField(@"ip", [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"] ?: @"");
        appendFormField(@"ipusername", [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"] ?: @"");
        appendFormField(@"password", [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"] ?: @"");
        appendFormField(@"dbname", [[NSUserDefaults standardUserDefaults]stringForKey:@"db"] ?: @"");
        appendFormField(@"ftppath", [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"] ?: @"");
    }

    // Add tpre and type (optional or based on config)
    appendFormField(@"tpre", @"");    // Add logic here if you want dynamic tpre
    appendFormField(@"type", @"");    // or "1", "2" if needed
    appendFormField(@"filename", strFileName);

    // Add image with correct field name: "image"
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", strFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Final boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    NSURLSessionDataTask *uploadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Upload failed: %@", error.localizedDescription);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Status: %ld", (long)httpResponse.statusCode);
            
//            if (data) {
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"Response: %@", responseString);
//                
//                NSError *jsonError = nil;
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//                if (!jsonError) {
//                    NSLog(@"Upload success: %@", json);
//                } else {
//                    NSLog(@"JSON parse error: %@", jsonError.localizedDescription);
//                }
//            }
            if (data) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    BOOL success = [[json objectForKey:@"success"] isEqualToString:@"1"];
                NSLog(@"Response: %@", json);
                    if (completion) completion(success);
                } else {
                    if (completion) completion(NO);
                }
        }

        if (completion) completion(NO);
    }];

    [uploadTask resume];
}


// Sequential uploader to avoid concurrency issues on server
- (void)uploadImagesSequentiallyWithURL:(NSString *)imageURL
                                baseTag:(NSString *)tgno
                                  index:(NSInteger)index
                          successCount:(NSInteger)successCount
                             completion:(void (^)(NSInteger successCount))completion {

    if (index >= [self.imagesArray count]) {
        NSLog(@"✅ All images uploaded.");
        if (completion) completion(successCount);
        return;
    }

    NSString *suffix = (index == 0) ? @"" : [NSString stringWithFormat:@"%c", (char)('A' + (int)index - 1)];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg", tgno, suffix];
    UIImage *image = self.imagesArray[index];

    NSLog(@"📤 Uploading image %ld: %@", (long)index + 1, fileName);

    [self uploadImage:image toURL:imageURL fileName:fileName completion:^(BOOL success) {
        NSInteger newSuccessCount = success ? successCount + 1 : successCount;
        [self uploadImagesSequentiallyWithURL:imageURL baseTag:tgno index:index+1 successCount:newSuccessCount completion:completion];
    }];
}



-(void)Alertswid {
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width-10, 400);
    [controller setPreferredContentSize:rect.size];
    
    [alertTableView reloadData];
    alertTableView  = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [alertTableView setTag:1000];
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    [alertTableView setUserInteractionEnabled:YES];
    [alertTableView setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_item setTitle:self->str_tgno forState:UIControlStateNormal];
        self->txt_tgno.text = self->str_tpre;
        NSLog(@"swid text done ==%@",self->str_tgno);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->str_tgno =@"";
        self->str_tpre =@"";
    }];
  
    [alertController addAction:yesAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)scrollData_Com {
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = [NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&ECAT_TYPE_NEW=%@",apptype,ip,db,ipusername,pswd,ftppath,ECAT_TYPE_NEW];
        URL_API = [WEB_URL URL_GET_CATEGORY1];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_item.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&ECAT_TYPE_NEW=%@",apptype,ftppath,ECAT_TYPE_NEW];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ECAT_TYPE_NEW=%@",apptype,ECAT_TYPE_NEW];
        URL_API = [WEB_URL URL_GET_CATEGORY1];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_com:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void) parseResponse_com:(NSData *) data {
    @try {
        array_idesc = [[NSMutableArray alloc]init];
        array_tpre = [[NSMutableArray alloc]init];
        
        [[BusyIndicator sharedInstance]stopIndicator];
    
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            [[BusyIndicator sharedInstance]stopIndicator];
            NSMutableArray *arrayResponse1 = [pDict objectForKey:@"data"];

            NSLog(@"arrayResponse1 :: %@",arrayResponse1);
           
            for (int i = 0; i < [arrayResponse1 count]; i++) {
                NSDictionary * dictObject = [arrayResponse1 objectAtIndex:i];
                NSString *idesc = [dictObject objectForKey:@"idesc"];
                NSString *tpre = [dictObject objectForKey:@"tpre"];

                [array_idesc addObject:idesc];
                [array_tpre addObject:tpre];
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->alertTableView reloadData];
                });
            }
                    
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark: - UITableView Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array_idesc count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    
    cell = [alertTableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }

    UILabel *lbl_date = [[UILabel alloc] init];
    lbl_date.frame = CGRectMake(15,2, self.view.frame.size.width-25, 56);
    lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:15];
    lbl_date.text = [array_idesc objectAtIndex:indexPath.row];
    lbl_date.textColor=[UIColor blackColor];
    [cell.contentView addSubview:lbl_date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    str_tgno = [array_idesc objectAtIndex:indexPath.row];
    str_tpre = [array_tpre objectAtIndex:indexPath.row];
}

#pragma mark: - Button Action Method

- (IBAction)txt_item:(id)sender {
    [self Alertswid];
}

- (IBAction)btn_ImgSelect:(UIButton *)sender{
}

- (IBAction)btn_save:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want save?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self send_memberimg_ToServer];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btn_item:(id)sender {
    [self Alertswid];
}

#pragma mark - Banner Collection View Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
    
    // Set the default image
    bannerCell.bannerImageView.image = nil;
    //bannerCell.bannerImageView.image = [UIImage imageNamed:@"banner_Default.png"];
    bannerCell.bannerImageView.image = [UIImage imageNamed:@"plusitem.png"];
    if (([self.imagesArray count] > 0) && (indexPath.row < [self.imagesArray count])) {
        bannerCell.bannerImageView.image = self.imagesArray[indexPath.row];
    }
    // Apply border radius and drop shadow to the cell content view
    bannerCell.contentView.layer.cornerRadius = 10;
    bannerCell.contentView.layer.masksToBounds = YES;
    // Set background color to white and add border
    bannerCell.contentView.backgroundColor = [UIColor whiteColor];
    bannerCell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bannerCell.contentView.layer.borderWidth = 1.0;
    // Add shadow to the cell content view
    bannerCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    bannerCell.contentView.layer.shadowOpacity = 1.7;
    bannerCell.contentView.layer.shadowRadius = 10.0;
    bannerCell.contentView.layer.shadowOffset = CGSizeMake(3, 3);
    return bannerCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    if ([self.imagesArray count] >= self.selectedIndexPath.row){
        [self selectPhoto];
    }
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

// UIImagePickerControllerDelegate method to handle image selection
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage]; // ✅ Cropped image

       if (!selectedImage) {
           selectedImage = info[UIImagePickerControllerOriginalImage]; // fallback
       }
    //UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    // Enforce max 5 images and correct replacement/add behavior
    if (self.selectedIndexPath && self.selectedIndexPath.row < 5) {
        if (self.selectedIndexPath.row < [self.imagesArray count]) {
            [self.imagesArray replaceObjectAtIndex:self.selectedIndexPath.row withObject:selectedImage];
        } else if ([self.imagesArray count] < 5) {
            [self.imagesArray addObject:selectedImage];
        }
    } else if ([self.imagesArray count] < 5) {
        [self.imagesArray addObject:selectedImage];
    }
    img_item.image = selectedImage;
    [self.bannerCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// UIImagePickerControllerDelegate method for when the user cancels
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
