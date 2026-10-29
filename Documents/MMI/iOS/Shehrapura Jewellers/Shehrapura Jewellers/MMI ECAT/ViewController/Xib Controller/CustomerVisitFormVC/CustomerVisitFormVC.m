//
//  CustomerVisitFormVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 05/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CustomerVisitFormVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

@interface CustomerVisitFormVC ()
{
    NSArray *array_CPNameList;
    UITableView *cpNametblView;
    UIAlertController *alertController;
    NSString *str_cpid;
}
@end

@implementation CustomerVisitFormVC

- (instancetype)init {
    self = [super initWithNibName:@"CustomerVisitFormVC" bundle:nil];
    if (self) {
        // Any additional setup
    }
    return self;
}


// This method gets called when the view is loaded into memory
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to identify it easily
    self.txtContactNo1.delegate = self;
    self.txtDoa.delegate = self;
    self.txtDob.delegate = self;
    [self datePickerViewSetUp];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    [self getDataByContactNo:mobile];
    array_CPNameList = [[NSArray alloc] init];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtContactNo1) {
        [self getDataByContactNo:self.txtContactNo1.text];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.txtContactNo1) {
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (textField.text.length == 11) {
            return NO; // Allow typing until 10 digits
        }
        
        if (updatedString.length == 10) {
            // You can hide or disable other UI elements here

            NSLog(@"More than 10 digits: %@", updatedString);
            
            [self getDataByContactNo:updatedString];
        } else {
            // Only allow entering more text (e.g. show other UI elements) after 10 digits
            // You can show additional content here or trigger some logic
            NSLog(@"less than 10 digits: %@", updatedString);

            return YES; // Or YES if you want to allow further input
        }
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Add a toolbar above the picker
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolbar sizeToFit];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (textField == self.txtDoa || textField == self.txtDob) {
        textField.inputView = self.datePicker;
        // Add Cancel and Done buttons
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelDatePicker:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(doneDatePicker:)];
        toolbar.items = @[cancelButton, flexibleSpace, doneButton];
        textField.inputAccessoryView = toolbar;  // Set the toolbar above the date picker
    }
    return YES;  // Returning YES allows the text field to become the first responder
}

#pragma mark - Button Action Methods

- (IBAction)searchButton:(id)sender{
    if(self.txtPartyName.text.length > 0){
        [self getDataByCustomerPartyName: self.txtPartyName.text];
    }else{
        [self alertMsg:@"Please Enter Party Name"];
    }
}

- (IBAction)saveButton:(id)sender{
    if ([self.txtContactNo1.text isEqual:@""]){
        [self alertMsg:@"Please select customer"];
    }else{
        [self saveCustomerDataApi];
    }
}

- (IBAction)cancelButton:(id)sender{
    // Dismiss the presented view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark:- Helper Method

-(void)setUpUserData: (NSDictionary *) userData{
    str_cpid = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpid"]];
    NSString *str_cpname = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpname"]];
    NSString *str_cpmobile = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpmobile"]];
    NSString *str_cpphone = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpphone"]];
    NSString *str_cpemail = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpemail"]];
    NSString *str_cplocation = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cplocation"]];
    NSString *str_country = [NSString stringWithFormat:@"%@",[userData valueForKey:@"country"]];
    NSString *str_cpcity = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpcity"]];
    NSString *str_cpdob = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpdob"]];
    NSString *str_cpdoa = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpdoa"]];
    
    NSString *str_cpadd1 = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpadd1"]];
    NSString *str_cpadd2 = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpadd2"]];
    NSString *str_cpadd3 = [NSString stringWithFormat:@"%@",[userData valueForKey:@"cpadd3"]];
    
    self.txtContactNo1.text = str_cpmobile;
    self.txtContactNo2.text = str_cpphone;
    self.txtPartyName.text = str_cpname;
    self.txtEmail.text = str_cpemail;
    self.txtAddress1.text = str_cpadd1;
    self.txtAddress2.text = str_cpadd2;
    self.txtAddress3.text = str_cpadd3;
    self.txtLocation.text = str_cplocation;
    self.txtCity.text = str_cpcity;
    self.txtDob.text = str_cpdob;
    self.txtDoa.text = str_cpdoa;
    [self.txtPartyName resignFirstResponder];
}


-(void)AlertViewCPName{
    UIViewController *controller = [[UIViewController alloc]init];
    
    // 3. Title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, controller.view.frame.size.width, 28)];
    titleLabel.text = @"Select Status :-";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    [controller.view addSubview:titleLabel];

    // 4. Separator line
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 8, 480, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [controller.view addSubview:separator];
    
    
    CGFloat tblHight = 150;//cpNametblView.frame.size.height;
    CGFloat tblListHight = 50 * [array_CPNameList count] + 50;
    //tblListHight = tblListHight < tblHight ? tblListHight : tblHight - 50;
    CGRect rect = CGRectMake(0, CGRectGetMaxY(separator.frame) + 8, self.view.frame.size.width, tblListHight);
    [controller setPreferredContentSize:rect.size];
    
    cpNametblView  = [[UITableView alloc]initWithFrame:rect];
    cpNametblView.delegate = self;
    cpNametblView.dataSource = self;
    cpNametblView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [cpNametblView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [cpNametblView setTag:1000];
    [cpNametblView setUserInteractionEnabled:YES];
    [cpNametblView setAllowsSelection:YES];
    [controller.view addSubview:cpNametblView];
    [controller.view bringSubviewToFront:cpNametblView];
    [controller.view setUserInteractionEnabled:YES];
    [cpNametblView reloadData];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Cancel Customer Party Name");
        //self->isFilter = false;
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark: - UITableView Datasouce and Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [array_CPNameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(10,5, self.view.frame.size.width-20, 21);
    [lbl_itemname setFont: [UIFont systemFontOfSize:16]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor=[UIColor blackColor];
    [cell.contentView addSubview:lbl_itemname];
    
    NSString *strCPName = [[array_CPNameList valueForKey:@"cpname"]  objectAtIndex:indexPath.row];
    NSString *strCPMobile = [[array_CPNameList valueForKey:@"cpmobile"]  objectAtIndex:indexPath.row];
    lbl_itemname.text = [NSString stringWithFormat:@"%@ %@", strCPName, strCPMobile];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strCPName = [NSString stringWithFormat:@"%@",[[array_CPNameList valueForKey:@"cpname"] objectAtIndex:indexPath.row]];
    NSDictionary *dicData = [array_CPNameList objectAtIndex:indexPath.row];
    self.txtPartyName.text = strCPName;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->alertController dismissViewControllerAnimated:YES completion:nil];
        [self setUpUserData: dicData];
    });
}

#pragma mark - Api Methods

-(void)getDataByContactNo:(NSString *)mobile {
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

-(void)getDataByCustomerPartyName:(NSString *)str_cpname {
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
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cpname=%@",apptype,ip,db,ipusername,pswd,ftppath,str_cpname];
        URL_API =[WEB_URL URL_Get_CPName];
        
    }else if([ECAT_TYPE isEqualToString:@"2"]){
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_cp_name.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&cpname=%@",ECAT_TYPE,ftppath,str_cpname];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&cpname=%@",ECAT_TYPE,str_cpname];
        URL_API =[WEB_URL URL_Get_CPName];
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

-(void)saveCustomerDataApi{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *str_contact = self.txtContactNo1.text;
    NSString *sm_mobile = self.txtContactNo2.text;
    NSString *str_pname = self.txtPartyName.text;
    NSString *str_address = self.txtAddress1.text;
    NSString *str_address2 = self.txtAddress2.text;
    NSString *str_address3 = self.txtAddress3.text;
    NSString *str_location = self.txtLocation.text;
    NSString *str_city = self.txtCity.text;
    NSString *str_email = self.txtEmail.text;
    NSString *str_Dob = self.txtDob.text;
    NSString *str_Doa = self.txtDoa.text;
    
    if ([apptype isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&smobile=%@&smacno=%@&cpdob=%@&cpasary=%@",apptype,ip,db,ipusername,pswd,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile,smacno,str_Dob,str_Doa];
        
        URL_API =[WEB_URL URL_INSERT_MEMBERS];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_members.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&smobile=%@&smacno=%@",apptype,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile,smacno];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&smobile=%@&smacno=%@",apptype,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile,smacno];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self parse_Insertmember:data con_mob:str_contact cname:str_pname];
                [self saveData:data];
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

-(void) saveData:(NSData *)apiData{
    
    NSDictionary *personInfo = @{
        @"contactNo1": self.txtContactNo1.text,
        @"contactNo2": self.txtContactNo2.text,
        @"cname": self.txtPartyName.text,
        @"cemail": self.txtEmail.text,
        @"cCity": self.txtCity.text,
        @"cLocation": self.txtLocation.text,
        @"cAddress1": self.txtAddress1.text,
        @"cAddress2": self.txtAddress2.text,
        @"cAddress3": self.txtAddress3.text,
        @"cpid" : str_cpid,
        @"isSaved": @YES
    };
    [[BusyIndicator sharedInstance]stopIndicator];
    // Call the delegate method to send data back to the parent view controller
    if ([self.delegate respondsToSelector:@selector(didFinishCustomerWithData:customerData:)]) {
        [self.delegate didFinishCustomerWithData:apiData customerData:personInfo];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // Dismiss the presented view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
            array_CPNameList = [[pDict objectForKey:@"memberlist"] mutableCopy];
            
            if ([str_success isEqualToString:@"1"]) {
                NSMutableArray*nsarray_cpemail = [pDict objectForKey:@"cpemail"];
                NSString *str_cpemail = [nsarray_cpemail description];
                
                NSMutableArray*nsarray_cpid = [pDict objectForKey:@"cpid"];
                str_cpid = [nsarray_cpid description];
                
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
                NSString *str_spphone = [nsarray_spphone description];
                
                NSMutableArray *nsarray_mobile1 = [pDict objectForKey:@"mobile1"];
                NSString *str_mobile1 = [nsarray_mobile1 description];
                
                self.txtContactNo1.text = str_cpphone.length > 0 ? str_cpphone : str_mobile1;
                self.txtContactNo2.text = str_spphone;
                self.txtPartyName.text = str_cpname;
                self.txtAddress1.text = str_cpadd1;
                self.txtAddress2.text = str_cpadd2;
                self.txtAddress3.text = str_cpadd3;
                self.txtLocation.text = str_cplocation;
                self.txtCity.text = str_cpcity;
                self.txtEmail.text = str_cpemail;
                self.txtDob.text = str_cpdob;
                self.txtDoa.text = str_cpdoa;
                [self.txtContactNo1 resignFirstResponder];
            }else if (array_CPNameList.count > 0){
                [self AlertViewCPName];
            }else{
                str_msg = str_msg.length > 0 ? str_msg : @"No Records";
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

#pragma mark - DatePickerView method

- (void)datePickerViewSetUp {
    // Set up the date picker
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    // Add a target for the date picker to update the text field
    if (@available(iOS 13.4, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

// Date picker value changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if (self.txtDoa.isFirstResponder) {
        self.txtDoa.text = [dateFormatter stringFromDate:datePicker.date];
    } else if (self.txtDob.isFirstResponder) {
        self.txtDob.text = [dateFormatter stringFromDate:datePicker.date];
    }
}

// Cancel button action
- (void)cancelDatePicker:(id)sender {
    [self.view endEditing:YES];  // Dismiss the keyboard and date picker
}

// Done button action
- (void)doneDatePicker:(id)sender {
    UITextField *textField = [[UITextField alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    if (self.txtDoa.isFirstResponder) {
        textField = self.txtDoa;
    }else if (self.txtDob.isFirstResponder) {
        textField = self.txtDob;
    }
    UIDatePicker *picker = (UIDatePicker *)textField.inputView;
    textField.text = [formatter stringFromDate:picker.date];
    [textField resignFirstResponder];
}


@end

