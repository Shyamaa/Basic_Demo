//
//  EditProfileVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 18/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC()

@end

@implementation EditProfileVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.editProfileStackView.hidden = true;
    self.editUserInfoStackView.hidden = true;
    
    if ([self.profileType isEqualToString:@"user"]){
        [self setUpUserInfoData];
        self.editUserInfoStackView.hidden = false;
    }else{
        [self setUpData];
        self.editProfileStackView.hidden = false;
    }
}

-(void)setUpData{
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:@""]
                                 placeholderImage:[UIImage imageNamed:@"user_white.png"] options:SDWebImageRefreshCached];
    NSString *profile = [[NSUserDefaults standardUserDefaults] stringForKey:@"profiledisplay"];
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *firmname = [[NSUserDefaults standardUserDefaults] stringForKey:@"firmname"];
    NSString *emailId = [[NSUserDefaults standardUserDefaults] stringForKey:@"emailid"];
    NSString *address = [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
    NSString *area = [[NSUserDefaults standardUserDefaults] stringForKey:@"area"];
    
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    NSString *state = [[NSUserDefaults standardUserDefaults] stringForKey:@"state"];
    NSString *gstno = [[NSUserDefaults standardUserDefaults] stringForKey:@"gstno"];
    NSString *hmno = [[NSUserDefaults standardUserDefaults] stringForKey:@"hmno"];
    NSString *panno = [[NSUserDefaults standardUserDefaults] stringForKey:@"panno"];

    NSLog(@"Profile = %@, Name = %@, mobile = %@", profile,name,mobile);
    NSLog(@"firmname = %@, emailId = %@, address = %@, area = %@", firmname,emailId,address);
    NSLog(@"Dispaye");
    self.lblName.text = name;
    self.lblMobile.text = mobile;
    self.txtEmailID.text = emailId;
    self.txtFirmName.text = firmname;
    self.txtAddress.text = address;
    self.txtCity.text = city;
    self.txtState.text = state;
    self.txtGstNo.text = gstno;
    self.txtHmNo.text = hmno;
    self.txtPanNo.text = panno;

    NSLog(@"Profile = %@, Name = %@, mobile = %@", profile,name,mobile);
    NSLog(@"firmname = %@, emailId = %@, address = %@, area = %@", firmname,emailId,address,area);
    NSLog(@"Dispaye");
}

-(void)setUpUserInfoData{
    self.title = @"User Profile";
    //categoriesList = [NSArray array];
    categoriesList = @[@"Befor Login", @"After Login", @"Retail", @"Trader", @"Karigar", @"Staff", @"Admin", @"Branch", @"Dealer"];
    
    [self.txtCategory addPickerWithData:categoriesList searchEnabled:NO];
    
    [self.imgProfile setShowActivityIndicatorView:YES];
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString: self.userData.imgurl] placeholderImage:[UIImage imageNamed:@"user"] options: SDWebImageRefreshCached];
    self.lblName.text = self.userData.name;
    self.lblMobile.text = self.userData.mobile;
    self.txtInterested.text = self.userData.interested.length>0 ? self.userData.interested : @"" ;
    self.txtCategory.text = self.userData.category; //categoriesList.firstObject;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // Hides the keyboard
    return YES;
}

#pragma mark - UIButton Action Method

-(IBAction)btnActionProfilPic:(id)sender{
    [self selectPhoto];
}

-(IBAction)btnActionSave:(id)sender{
    if ([self.profileType isEqualToString:@"user"]){
        //Update User info
        [self Update_User:self.txtCategory.text withName:self.userData.name withmobile:self.userData.mobile];
    }else{
        //Edit Profile Api
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
    self.imgProfile.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// UIImagePickerControllerDelegate method for when the user cancels
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  API Method

- (void)Update_User:(id)selectedItem withName:(NSString *)username withmobile:(NSString *)mobile {
    NSString *category = @"";
    if ([selectedItem isEqualToString:@"Retail"] || [selectedItem isEqualToString:@"Customer"]) {
        category = @"1";
    } else if ([selectedItem isEqualToString:@"Not Any Category"] || [selectedItem isEqualToString:@"All"]) {
        category = @"0";
    } else if ([selectedItem isEqualToString:@"By Default"]) {
        category = @"-1";
    } else if ([selectedItem isEqualToString:@"Admin"]) {
        category = @"5";
    } else if ([selectedItem isEqualToString:@"Befor Login"]) {
        category = @"0";
    } else if ([selectedItem isEqualToString:@"After Login"]) {
        category = @"0";
    } else if ([selectedItem isEqualToString:@"Trader"]) {
        category = @"2";
    } else if ([selectedItem isEqualToString:@"Karigar"]) {
        category = @"3";
    } else if ([selectedItem isEqualToString:@"Staff"]) {
        category = @"4";
    } else if ([selectedItem isEqualToString:@"Branch"]) {
        category = @"6";
    } else if ([selectedItem isEqualToString:@"Dealer"]) {
        category = @"7";
    }
    NSString *strInterest = self.txtInterested.text;
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_UDPATE_MEMBER]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"mobile=%@&category=%@&username=%@&interestedin=%@", mobile,category,username,strInterest];
    NSLog(@"User Update Param = %@", postString);
    NSLog(@"User Update Url = %@", url);
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"User Update Response = %@", jsonDict);
                NSString *status = jsonDict[@"success"];
                NSString *message = jsonDict[@"message"];
                if ([status isEqualToString:@"1"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[self alertMsg:message];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertMsg:message];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertMsg:jsonError.localizedDescription];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:error.localizedDescription];
            });
        }
    }];
    [task resume];
}

@end

