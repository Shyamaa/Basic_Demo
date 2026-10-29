//
//  CustomerInfoVc.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CustomerInfoVc.h"

#pragma mark - UserListActivity

@interface CustomerInfoVc()
    
@end
@implementation CustomerInfoVc

BOOL isFrontImageSelected = NO;
BOOL isBackImageSelected = NO;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Customer Information";
    self.txtGroupNameList.delegate = self;
    self.txtMobile.delegate = self;
    [self getListDataApi];
    [self updateUI];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

-(void)updateUI{
    [self.viewGroupList setHidden:NO];
    [self.viewStampList setHidden:YES];
    [self.viewInstallList setHidden:NO];
    [self.viewCityList setHidden:NO];
    [self setupDatePickerForTextField:self.txtDob];
}

#pragma mark: - UITextField delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtMobile) {
        //[self getDataByContactNo:self.txtContactNo1.text];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    if (textField == self.txtGroupNameList) {
        NSLog(@"Group TextField resigned. Text: %@", text);
    } else {
        NSLog(@"TextField resigned. Text: %@", text);
    }
}

//- (void)textFieldDidChangeSelection:(UITextField *)textField {
//    if (textField == self.txtMobile) {
//        if (textField.text.length == 10) {
//            NSLog(@"✅ Exactly 10 characters entered = %@", textField.text);
//            // You can enable a button or show a green check here
//           // [self getDataByContactNo:textField.text];
//            //[self getDataByContactNo1:textField.text];
//        } else {
//            NSLog(@"❌ Not 10 characters");
//            // Maybe disable a button or show warning
//        }
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtMobile) {
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (updatedString.length == 11) {
            return NO;
        }
        if (updatedString.length == 10) {
            // You can hide or disable other UI elements here
            NSLog(@"More than 10 digits: %@", updatedString);
            [self getDataByContactNo:updatedString];
            return YES; // Allow typing until 10 digits
        } else {
            // Only allow entering more text (e.g. show other UI elements) after 10 digits
            // You can show additional content here or trigger some logic
            NSLog(@"less than 10 digits: %@", updatedString);
            return YES; // Or YES if you want to allow further input
        }
    }
    return YES;
}

#pragma mark:- IBAction Button Method
//List view cancel button
-(IBAction)cancelButtonAction:(id)sender{
    [self.listView setHidden:YES];
}

-(IBAction)aadharPhotoButtonAction:(UIButton *)sender{
    self.imagePickerHelper = [[ImagePickerHelper alloc] initWithPresentingController:self];
    if (sender.tag == 11){
        [self.imagePickerHelper showImagePickerOptionsWithCompletion:^(UIImage *image) {
            if (image) {
                self.imgAdharFront.image = image;
                isFrontImageSelected = YES;
               } else {
                   NSLog(@"No image found in info dictionary");
               }
        }];
    }else if (sender.tag == 22){
        [self.imagePickerHelper showImagePickerOptionsWithCompletion:^(UIImage *image) {
            if (image) {
                self.imgAdharBack.image = image;
                isBackImageSelected = YES;
               } else {
                   NSLog(@"No image found in info dictionary");
               }
        }];
    }
}

-(IBAction)saveButtonAction:(id)sender{
    if (self.txtGroupNameList.text.length == 0){
        [self alertMsg:@"Please select group"];
    }else if(self.txtMobile.text.length == 0){
        [self alertMsg:@"Please enter mobile"];
    }else if(self.txtMobile.text.length != 10){
        [self alertMsg:@"Please enter valid mobile"];
    }else if(self.txtName.text.length == 0){
        [self alertMsg:@"Please enter name"];
    }else if(self.txtEmail.text.length == 0){
        [self alertMsg:@"Please enter email"];
    }else if( ![self isValidEmail:self.txtEmail.text]){
        [self alertMsg:@"Please enter valid email"];
    }else if(self.txtDob.text.length == 0){
        [self alertMsg:@"Please select date of birth"];
    }else if(self.txtAddress.text.length == 0){
        [self alertMsg:@"Please enter address"];
    }else if(self.txtCity.text.length == 0){
        [self alertMsg:@"Please select city"];
    }else if(self.txtPinCode.text.length == 0){
        [self alertMsg:@"Please enter pin code"];
    }else if(self.txtAdharNo.text.length == 0){
        [self alertMsg:@"Please enter aadhaar number"];
    }else if(self.txtAdharNo.text.length != 12){
        [self alertMsg:@"Please enter valid aadhaar number"];
    }else if(self.txtInstallmentList.text.length == 0){
        [self alertMsg:@"Please select installment"];
    }else if (isFrontImageSelected == NO && isFrontImageSelected == NO){
        [self alertMsg:@"Please select Id's photo"];
    }else{
        [self saveDataApi];
    }
}




#pragma mark: - TableVeiw Delegate and DataSouce


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark: - Api Methods

- (void)getListDataApi{
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    //NSString *kittyip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    //NSString *kittydb = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    //NSString *kittyuser = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    //NSString *kittypswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    //NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSDictionary *params = @{
        @"apptype": apptype,
        @"mobile": mobile
        //        @"kittyip": kittyip,
        //        @"kittydb": kittydb,
        //        @"kittyuser": kittyuser,
        //        @"kittypswd": kittypswd,
    };
    //NSLog(@"params: %@", params);
    
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_KittyGroupList]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Kitty Group List Response: %@", data);
            NSArray *groupList = data[@"ktgrouplist"];
            NSLog(@"Gropup List: %@", groupList);
            NSArray *pickerData = [groupList valueForKey:@"gname"];
            NSLog(@"Gropup Name List: %@", pickerData);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtGroupNameList addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_KittyInstallList]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Kitty Install List Response: %@", data);
            NSArray *listData = data[@"installlist"];
            NSLog(@"Gropup List: %@", listData);
            NSArray *pickerData = [listData valueForKey:@"amount"];
            NSLog(@"Kitty Install List: %@", pickerData);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtInstallmentList addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_STAMP]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Stamp List Response: %@", data);
            NSArray *listData = data[@"stamplist"];
            NSLog(@"Stamp List: %@", listData);
            NSArray *pickerData = [listData valueForKey:@"stamp"];
            NSLog(@"Stamp Name List: %@", pickerData);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtStampList addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_KittyCityList]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"City List Response: %@", data);
            NSArray *listData = data[@"citylist"];
            NSLog(@"City List: %@", listData);
            NSArray *pickerData = [listData valueForKey:@"city"];
            NSLog(@"City Name List: %@", pickerData);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtCity addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[BusyIndicator sharedInstance] stopIndicator];
    });
}


- (void)saveDataApi{
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apiName = [WEB_URL URL_Save_Kitty];
    NSLog(@"apiName: %@", apiName);
    
//    NSString *kittyip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
//    NSString *kittydb = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
//    NSString *kittyuser = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
//    NSString *kittypswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"]; //Data are nil
    
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    //NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *mobile = self.txtMobile.text;
    NSString *cname = self.txtName.text;
    NSString *email = self.txtEmail.text;
    NSString *dob = self.txtDob.text;
    NSString *address = self.txtAddress.text;
    NSString *city = self.txtCity.text;
    NSString *pincode = self.txtPinCode.text;
    NSString *aadharNo = self.txtAdharNo.text;
    NSString *groupName = self.txtGroupNameList.text;
    NSString *installment = self.txtInstallmentList.text;
    
    NSDictionary *params = @{
        @"apptype": apptype,
        //        @"kittyip": kittyip,
        //        @"kittydb": kittydb,
        //        @"kittyuser": kittyuser,
        //        @"kittypswd": kittypswd,
        @"mobile": mobile,
        @"cname" : cname,
        @"email": email,
        @"dob" : dob,
        @"add1": address,
        @"city" : city,
        @"pin": pincode,
        @"groupid" : groupName,
        @"kinsamt" : installment,
        @"stampid" : @"0"
    };
    NSLog(@"params: %@", params);
    
    [[APIManager sharedManager] GET: apiName
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Save Response: %@", data);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

-(void)getDataByContactNo:(NSString *)mobile {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSDictionary *params = @{
        @"apptype": apptype,
        @"mobile": mobile
    };
    NSLog(@"params: %@", params);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_MEMBERS]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Mobile Data Response: %@", data);
            NSArray *listData = data[@"citylist"];
            NSArray *pickerData = [listData valueForKey:@"city"];
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.txtMobile.text = str_cpphone;
//                self.txtName.text = str_cpname;
//                self.txtEmail.text = str_cpemail;
//                self.txtDob.text = str_cpdob;
//                self.txtAddress.text = str_cpadd1;;
//                self.txtCity.text = str_cpcity;
//                self.txtPinCode.text = str_cpdoa;
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

-(void)getDataByContactNo1:(NSString *)mobile {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]){
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&mobile=%@",apptype,ip,db,ipusername,pswd,ftppath,mobile];
        URL_API =[WEB_URL URL_GET_MEMBERS];
        
    }else if([ECAT_TYPE isEqualToString:@"2"]){
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_members.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&mobile=%@",ECAT_TYPE,ftppath,mobile];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@",ECAT_TYPE,mobile];
        URL_API =[WEB_URL URL_GET_MEMBERS];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_GETmembers:data];
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

- (void)parse_GETmembers:(NSData *) data {
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
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            
            if ([str_success isEqualToString:@"1"]) {
                NSMutableArray*nsarray_cpemail = [pDict objectForKey:@"cpemail"];
                NSString *str_cpemail = [nsarray_cpemail description];
                
                NSMutableArray*nsarray_cpid = [pDict objectForKey:@"cpid"];
                NSString *str_cpid = [nsarray_cpid description];
                
                NSMutableArray*nsarray_cpname = [pDict objectForKey:@"cpname"];
                NSString *str_cpname = [nsarray_cpname description];
                
                NSMutableArray*nsarray_cpasary = [pDict objectForKey:@"cpasary"];
                NSString *str_cpasary = [nsarray_cpasary description];
                
                NSMutableArray*nsarray_cpcity = [pDict objectForKey:@"cpcity"];
                NSString *str_cpcity = [nsarray_cpcity description];
                
                NSMutableArray*nsarray_cpdob = [pDict objectForKey:@"cpdob"];
                NSString *str_cpdob = [nsarray_cpdob description];
                
                NSMutableArray*nsarray_cpdoa = [pDict objectForKey:@"cpasary"];
                NSString *str_cpdoa = [nsarray_cpdob description];
                
                
                NSMutableArray*nsarray_cpadd1 = [pDict objectForKey:@"cpadd1"];
                NSString *str_cpadd1 = [nsarray_cpadd1 description];
                
                NSMutableArray*nsarray_cpadd2 = [pDict objectForKey:@"cpadd2"];
                NSString *str_cpadd2 = [nsarray_cpadd2 description];
                
                NSMutableArray*nsarray_cpadd3 = [pDict objectForKey:@"cpadd3"];
                NSString *str_cpadd3 = [nsarray_cpadd3 description];
                
                NSMutableArray*nsarray_cplocation = [pDict objectForKey:@"cplocation"];
                NSString *str_cplocation = [nsarray_cplocation description];
                
                NSMutableArray *nsarray_cpphone = [pDict objectForKey:@"cpphone"];
                NSString *str_cpphone = [nsarray_cpphone description];
                
                NSMutableArray *nsarray_spphone = [pDict objectForKey:@"spmobile"];
                NSString *str_spphone = [nsarray_cpphone description];
                
//                self.txtContactNo1.text = str_cpphone;
//                self.txtContactNo2.text = str_spphone;
//                self.txtPartyName.text = str_cpname;
//                self.txtAddress1.text = str_cpadd1;
//                self.txtAddress2.text = str_cpadd2;
//                self.txtAddress3.text = str_cpadd3;
//                self.txtLocation.text = str_cplocation;
//                self.txtCity.text = str_cpcity;
//                self.txtEmail.text = str_cpemail;
//                self.txtDob.text = str_cpdob;
//                self.txtDoa.text = str_cpdoa;
                
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action){
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
