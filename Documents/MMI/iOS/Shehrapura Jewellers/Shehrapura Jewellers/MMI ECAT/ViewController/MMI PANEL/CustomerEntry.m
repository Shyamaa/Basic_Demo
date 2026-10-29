//
//  CustomerEntry.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 20/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "CustomerEntry.h"

@interface CustomerEntry ()

@end

@implementation CustomerEntry

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cutomer Entry";
    NSArray *prefixListPickerData = @[@"Mr.", @"Ms.", @"Mrs.", @"Dr."];
    [txtPrefix addPickerWithData:prefixListPickerData searchEnabled:NO];
    txtCountry.text = @"India";
    [self setupDatePickerForTextField:txtDob];
    [self setupDatePickerForTextField:txtSpouseDob];
    [self setupDatePickerForTextField:txtAnniversaryDate];
}

#pragma mark - Button Action Methods

- (IBAction)btnPersonalDetailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    personalDetailsView.hidden = !sender.selected;
    if(personalDetailsView.hidden == true){
        merriedDetailsView.hidden = true;
        btnMarried.selected = false;
    }
}

- (IBAction)btnGetImageAction:(UIButton *)sender {
    if (sender.tag == 200) {
        imgSelecte = imgPan;
    } else if (sender.tag == 300) {
        imgSelecte = imgAdhar;
    }else{
        imgSelecte = imgPhoto;
    }
    [self selectPhoto];
}

- (IBAction)btnMerriedAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    merriedDetailsView.hidden = !sender.selected;
}

- (IBAction)btnGenderAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (btnMale == sender){
        btnFemale.selected = false;
    }else if (btnFemale == sender){
        btnMale.selected = false;
    }
}

- (IBAction)btnSaveAction:(UIButton *)sender {
    if (txtMobile.text.length == 0) {
        [self alertMsg: @"Please enter mobile number"];
    } else if (txtName.text.length == 0) {
        [self alertMsg: @"Please enter customer full name"];
    }else{
        [self saveCustomerDataApi];
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
    
    //    if (([self.imagesArray count] > 0 ) && (([self.imagesArray count] - 1 == 4) || ([self.imagesArray count] - 1 >= self.selectedIndexPath.row))){
    //        [self.imagesArray replaceObjectAtIndex:self.selectedIndexPath.row withObject:selectedImage];
    //    }else{
    //        [self.imagesArray addObject:selectedImage];
    //    }
    imgSelecte.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// UIImagePickerControllerDelegate method for when the user cancels
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Place order API Methods

-(void)saveCustomerDataApi{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *str_contact = txtMobile.text;
    NSString *str_mobile = txtPhone.text;
    NSString *str_prefix = txtPrefix.text;
    NSString *str_fullname = txtName.text;
    NSString *str_address = txtAddress1.text;
    NSString *str_address2 = txtAddress2.text;
    NSString *str_address3 = txtAddress3.text;
    NSString *str_location = txtLocation.text;
    NSString *str_city = txtCity.text;
    NSString *str_country = txtCountry.text;
    NSString *str_pincode = txtPincode.text;
    
    NSString *str_FirmName = txtFirmName.text;
    NSString *str_Pancard = txtPancard.text;
    NSString *str_Adhar = txtAdharCardNo.text;
    NSString *str_email = txtEmail.text;
    NSString *str_Dob = txtDob.text;
    NSString *str_Education = txtEducation.text;
    NSString *str_Potential = txtPotential.text;
    NSString *str_Jewknowlede = txtJewKnowlede.text;
    NSString *str_Refrence = txtRefrence.text;
    NSString *str_RingSize = txtRingSize.text;
    NSString *str_BangleSize = txtBangleSize.text;
    NSString *str_Remark = txtRemark.text;
    NSString *str_gender = btnMale.selected == true ? @"1" : @"0";
    
    NSString *str_isMarried = btnMarried.selected == true ? @"1" : @"0";
    
    NSString *str_sName = txtSpouseName.text;
    NSString *str_sEmail = txtSpouseMobile.text;
    NSString *str_sDob = txtSpouseName.text;
    NSString *str_sAnniversary = txtAnniversaryDate.text;
    NSString *str_smobile = txtSpouseMobile.text;
    
    
    NSString *param = [NSString stringWithFormat:@"apptype=%@&mobile=%@&cpphone=%@&prefix=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&cpcity=%@&country=%@&cppin=%@&cppan=%@&cpaadhar=%@&cpemail=%@&cpdob=%@&education=%@&potential=%@&knowledge=%@&refby=%@&ring=%@&bangle=%@&remark=%@&spouse=%@&spemail=%@&spousedob=%@&cpasary=%@&smobile=%@&married=%@&gender=%@",apptype,str_mobile,str_contact,str_prefix,str_fullname,str_address,str_address2,str_address3,str_location,str_city,str_country,str_pincode,str_Pancard,str_Adhar,str_email,str_Dob,str_Education,str_Potential,str_Jewknowlede,str_Refrence,str_RingSize,str_BangleSize,str_Remark,str_sName,str_sEmail,str_sDob,str_sAnniversary,str_smobile,str_isMarried,str_gender];
    
    if ([apptype isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&%@",ip,db,ipusername,pswd,ftppath,param];
        
        URL_API =[WEB_URL URL_INSERT_MEMBERS];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_members.php",ip];
        loginRequest=[NSString stringWithFormat:@"ftppath=%@&%@",ftppath,param];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"%@",param];
        URL_API =[WEB_URL URL_INSERT_MEMBERS];
    }
    
    NSLog(@"loginRequest :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api :: %@",api);
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_Data:data];
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

- (void)parse_Data:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data_parse_GETmembers =============== %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"]) {
                str_msg = str_msg.length > 0 ? str_msg : @"No Records";
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action){
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
