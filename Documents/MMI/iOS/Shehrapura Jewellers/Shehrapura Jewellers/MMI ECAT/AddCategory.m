//
//  AddCategory.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/10/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "AddCategory.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface AddCategory ()
{
    NSString *manual_tagging;
}
@end

@implementation AddCategory

#pragma  mark: - Class Mathod

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Item";
    UITapGestureRecognizer *singleTapBusiness = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected_member)];
    singleTapBusiness.numberOfTapsRequired = 1;
    [img_add addGestureRecognizer:singleTapBusiness];
    img_add.contentMode = UIViewContentModeScaleAspectFit;
    
    [img_add.layer setCornerRadius:10.0f];
    [img_add.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [img_add.layer setBorderWidth:1];

    [txt_item.layer setMasksToBounds:YES];
    [txt_item.layer setCornerRadius:10.0f];
    [txt_item.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_item.layer setBorderWidth:1];
    
    [txt_prefix.layer setMasksToBounds:YES];
    [txt_prefix.layer setCornerRadius:10.0f];
    [txt_prefix.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_prefix.layer setBorderWidth:1];
    
    [btn_category.layer setMasksToBounds:YES];
    [btn_category.layer setCornerRadius:10.0f];
    [btn_category.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_category.layer setBorderWidth:1];
    
    [btn_group.layer setMasksToBounds:YES];
    [btn_group.layer setCornerRadius:10.0f];
    [btn_group.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_group.layer setBorderWidth:1];
    
    manual_tagging =@"0";
    // Add target to handle button tap
    [self.btn_check addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    categoryStackView.hidden = YES;
    groupStackView.hidden = YES;
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
        categoryStackView.hidden = NO;
        groupStackView.hidden = NO;
    }
    [self setData];
    [self scrollData_Com];
}

-(void)setData{
    txt_prefix.enabled = true;
    if (self.preCategoryData != nil){
        NSLog(@"dic Value = %@", _preCategoryData);
        txt_item.text = [self.preCategoryData valueForKey:@"idesc"];
        txt_prefix.text = [self.preCategoryData valueForKey:@"tpre"];
        txt_prefix.enabled = false;
        NSURL *URL = [NSURL URLWithString: [self.preCategoryData valueForKey:@"imgurl"]];
        NSString *myString = [URL absoluteString];
        [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        [img_add sd_setImageWithURL:[NSURL URLWithString: [self.preCategoryData valueForKey:@"imgurl"]]
                   placeholderImage:[UIImage imageNamed:@"plusitem.png"] options:/* DISABLES CODE */ (0) ? SDWebImageRefreshCached : 0];
        NSString *category = [self.preCategoryData valueForKey:@"category"];
        //[self->btn_category setTitle: category.length > 0 ? category : @"" forState:UIControlStateNormal];
        if ([category isKindOfClass:[NSString class]]) {
            //NSUInteger len = [category length];
            // Safe to use length
            [self->btn_category setTitle: category forState: UIControlStateNormal];
        } else {
            // Handle NSNull or other unexpected types
            [self->btn_category setTitle: @"" forState: UIControlStateNormal];
        }
        NSString *group = [self.preCategoryData valueForKey:@"igroup"];
        if ([group isKindOfClass:[NSString class]]) {
            NSUInteger len = [group length];
            // Safe to use length
            [self->btn_group setTitle: group forState: UIControlStateNormal];
        } else {
            // Handle NSNull or other unexpected types
            [self->btn_group setTitle: @"" forState: UIControlStateNormal];
        }
        [self->btn_category setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [self->btn_group setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    }
    
}
// Toggle checkbox state on tap
- (void)checkboxTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSLog(@"Checkbox checked");
        manual_tagging =@"1";
    } else {
        NSLog(@"Checkbox unchecked");
        manual_tagging =@"0";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark: - Texfield Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_item) {
        [txt_prefix becomeFirstResponder];
    }else if (textField == txt_prefix) {
        [txt_prefix resignFirstResponder];
        [textField resignFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark: - Tab GestureRecognizer Method

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
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        //Handle no, thanks button
    }];
    //Add your buttons to alert controller
    [alert addAction:CameraButton];
    [alert addAction:GalleryButton];
    [alert addAction:CancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark: - Image Picker ViewController Method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (picker==pickerControllerGallery) {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            self->filename = [representation filename];
            NSLog(@"fileName : %@",self->filename);
            self->img_add.image = [info objectForKey:UIImagePickerControllerEditedImage];
            self->img_add.image = [info objectForKey:UIImagePickerControllerOriginalImage];
            CGSize imageSize = self->img_add.image.size;
            [self->img_add sizeThatFits:imageSize];
            CGPoint imageViewCenter = self->img_add.center;
            [self->img_add setCenter:imageViewCenter];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        NSLog(@"imageURL=%@",imageURL);
    }else if (picker==pickerControllerCamera) {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            self->filename = [representation filename];
            NSLog(@"fileName : %@",self->filename);
            UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
            self->img_add.image = chosenImage;
            CGSize imageSize = self->img_add.image.size;
            [self->img_add sizeThatFits:imageSize];
            CGPoint imageViewCenter = self->img_add.center;
            [self->img_add setCenter:imageViewCenter];
            [picker dismissViewControllerAnimated:YES completion:NULL];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        NSLog(@"imageURL=%@",imageURL);
    }
}

#pragma mark: - Button Action Method

- (IBAction)btn_save:(id)sender{
    if (txt_item.text.length == 0) {
        [self showAlert:@"Please Enter Item name"];
    }else if(txt_prefix.text.length == 0){
        [self showAlert:@"Please Enter Gross Wt."];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self send_memberimg_ToServer];
        });
    }
}

- (void)showAlert:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btn_group:(id)sender {
    [self Alert_Group];
}

- (IBAction)btn_category:(id)sender {
    [self Alert_Category];
}

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    return cropped;
}

- (void)send_memberimg_ToServer {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE_NEW"];
    NSString *URL_Config;
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    // Setting the URL based on ECAT_TYPE value
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Config = [WEB_URL URL_SAVE_CATEGORY];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/save_category_ios.php", ip];
    } else {
        URL_Config = [WEB_URL URL_SAVE_CATEGORY];
    }
    
    NSLog(@"URL_Config ******************************* %@", URL_Config);
    
    NSString *item = txt_item.text;
    NSString *design = txt_prefix.text;
    NSString *tpre = [txt_prefix.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tpre = [tpre stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tpre = [tpre stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    // Convert image to JPEG data
    NSData *imageData = UIImageJPEGRepresentation(img_add.image, 0.1f);
    
    // Get the current date and format it
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *curDate = [dateFormatter stringFromDate:[NSDate date]];
    
    //    NSString *stringWithoutSpaces = [curDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    NSString *stringWithoutSpaces1 = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", design];
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
    
    NSString *str_category = [btn_category titleForState:UIControlStateNormal];
    NSString *str_igroup = [btn_group titleForState:UIControlStateNormal];
    str_category = [str_category isEqualToString:@"Select Category"] ? @"" : str_category;
    str_igroup = [str_igroup isEqualToString:@"Select Group"] ? @"" : str_igroup;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:ECAT_TYPE_NEW forKey:@"apptype4"];
    [params setObject:ECAT_TYPE forKey:@"apptype"];
    [params setObject:filename forKey:@"filename"];
    [params setObject:item forKey:@"idesc"];
    [params setObject:design forKey:@"tpre"];
    [params setObject:str_category forKey:@"category"];
    [params setObject:str_igroup forKey:@"igroup"];
    [params setObject:manual_tagging forKey:@"manual_tagging"];
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
            self.onValueSelected(@"Back with block value!");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


//- (void)send_memberimg_ToServer {
//    [[BusyIndicator sharedInstance]startIndicator];
//    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
//    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
//    NSString *URL_Config;
//    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
//    if ([ECAT_TYPE isEqualToString:@"1"]) {
//        URL_Config =[WEB_URL URL_SAVE_CATEGORY];
//    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
//        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
//        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/save_category_ios.php",ip];
//    }else{
//        URL_Config =[WEB_URL URL_SAVE_CATEGORY];
//    }
//    
//    NSLog(@"URL_Config ******************************* %@",URL_Config);
//    NSString *item = txt_item.text;
//    NSString *design = txt_prefix.text;
//
//    NSString *tpre=[NSString stringWithString:txt_prefix.text];
//    tpre = [tpre stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    tpre = [tpre stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    tpre = [tpre stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    
//    NSData *imageData = UIImageJPEGRepresentation(img_add.image, 0.1f);
//    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *curDate=[dateFormatter stringFromDate:[NSDate date]];
//    
//    NSString *stringWithoutSpaces = [curDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *stringWithoutSpaces1 = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
//
//    filename = [NSString stringWithFormat:@"%@.jpg", design];
//    NSLog(@"filename :: %@",filename);
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:URL_Config]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
//    NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
//    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
//    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
//    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
//    
//    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
//    [_params setObject:[NSString stringWithFormat:@"%@",ECAT_TYPE_NEW] forKey:@"apptype4"];
//    [_params setObject:[NSString stringWithFormat:@"%@",ECAT_TYPE] forKey:@"apptype"];
//    [_params setObject:[NSString stringWithFormat:@"%@",ip] forKey:@"ip"];
//    [_params setObject:[NSString stringWithFormat:@"%@",db] forKey:@"dbname"];
//    [_params setObject:[NSString stringWithFormat:@"%@",ipusername] forKey:@"ipusername"];
//    [_params setObject:[NSString stringWithFormat:@"%@",pswd] forKey:@"password"];
//    [_params setObject:[NSString stringWithFormat:@"%@",ftppath] forKey:@"ftppath"];
//
//    [_params setObject:[NSString stringWithFormat:@"%@",filename] forKey:@"filename"];
//    [_params setObject:[NSString stringWithFormat:@"%@",item] forKey:@"idesc"];
//    [_params setObject:[NSString stringWithFormat:@"%@",design] forKey:@"tpre"];
//
//    NSLog(@"_params = %@", _params);
//    
//    NSMutableData *body = [NSMutableData data];
//    
//    for (NSString *param in _params) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"myfile\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:imageData]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    // setting the body of the post to the reqeust
//    [request setHTTPBody:body];
//    // now lets make the connection to the web
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"returnString=%@",returnString);
//    
//    [self showAlert:returnString];
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    
//    [[BusyIndicator sharedInstance]stopIndicator];
//    
//}


-(void)Alert_Category {
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width-10, ([array_category count]*50));
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
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_category setTitle:self->str_catedata forState:UIControlStateNormal];
        [self->btn_category setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->str_catedata = @"";
        [self->btn_category setTitle:@"Select Category" forState:UIControlStateNormal];
        [self->btn_category setTitleColor:[UIColor colorNamed: @"font_Color"] forState: UIControlStateNormal];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)Alert_Group {
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width - 10, ([array_group count]*50));
    [controller setPreferredContentSize:rect.size];
    
    [tableview_group reloadData];
    tableview_group  = [[UITableView alloc]initWithFrame:rect];
    tableview_group.delegate = self;
    tableview_group.dataSource = self;
    tableview_group.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [tableview_group setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableview_group setTag:1000];
    [controller.view addSubview:tableview_group];
    [controller.view bringSubviewToFront:tableview_group];
    [controller.view setUserInteractionEnabled:YES];
    [tableview_group setUserInteractionEnabled:YES];
    [tableview_group setAllowsSelection:YES];
    
    ac_group = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_group setValue:controller forKey:@"contentViewController"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_group setTitle:self->str_catedata forState:UIControlStateNormal];
        [self->btn_group setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->str_catedata = @"";
        [self->btn_group setTitle:@"Select Group" forState:UIControlStateNormal];
        [self->btn_group setTitleColor:[UIColor colorNamed: @"font_Color"] forState: UIControlStateNormal];
    }];
    [ac_group addAction:cancelAction];
    [ac_group addAction:yesAction];
    [self presentViewController:ac_group animated:YES completion:nil];
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
        URL_API = [WEB_URL URL_GET_CAT_GROUP];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_tg_category.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&ECAT_TYPE_NEW=%@",apptype,ftppath,ECAT_TYPE_NEW];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ECAT_TYPE_NEW=%@",apptype,ECAT_TYPE_NEW];
        URL_API = [WEB_URL URL_GET_CAT_GROUP];
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
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void) parseResponse_com:(NSData *) data {
    @try {
        array_category = [[NSMutableArray alloc]init];
        array_group = [[NSMutableArray alloc]init];
        
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
            NSMutableArray *arrayResponse1 = [pDict objectForKey:@"categorylist"];
        
            NSMutableArray *arraygroupList = [pDict objectForKey:@"groupList"];

            for (int i = 0; i < [arrayResponse1 count]; i++) {
                NSDictionary * dictObject = [arrayResponse1 objectAtIndex:i];
                [array_category addObject:[dictObject objectForKey:@"category"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->alertTableView reloadData];
                });
            }
            
            for (int i = 0; i < [arraygroupList count]; i++) {
                NSDictionary * dictObject = [arraygroupList objectAtIndex:i];
                [array_group addObject:[dictObject objectForKey:@"igroup"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->tableview_group reloadData];
                });
            }
                    
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


#pragma mark:- TableView Delegate and Datasouce Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableview_group) {
        return [array_group count];
    }else{
        return [array_category count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    NSString * str_label = @"";
    if (tableView == tableview_group) {
        cell = [tableview_group dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        str_label = [array_group objectAtIndex:indexPath.row];
    }else{
        cell = [alertTableView dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        str_label = [array_category objectAtIndex:indexPath.row];
    }
    
    UILabel *lbl_date = [[UILabel alloc] init];
    lbl_date.frame = CGRectMake(15,0, self.view.frame.size.width-25, 50);
    lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:15];
    lbl_date.text = str_label;
    lbl_date.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lbl_date];
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableview_group) {
        str_catedata = [array_group objectAtIndex:indexPath.row];
    }else{
        str_catedata = [array_category objectAtIndex:indexPath.row];
    }
    NSLog(@"str_catedata : %@",str_catedata);
}


@end
