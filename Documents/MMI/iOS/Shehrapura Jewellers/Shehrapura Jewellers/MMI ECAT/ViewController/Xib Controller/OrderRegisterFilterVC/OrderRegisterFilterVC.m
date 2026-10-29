//
//  OrderRegisterFilterVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "OrderRegisterFilterVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

@interface OrderRegisterFilterVC()

@end

@implementation OrderRegisterFilterVC

- (instancetype)init {
    self = [super initWithNibName:@"OrderRegisterFilterVC" bundle:nil];
    if (self) {
        // Any additional setup
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self datePickerViewSetUp];
    [self setUpPickerView];
    self.txtDateTo.delegate = self;
    self.txtDateFrom.delegate = self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (NSArray *)getUniqueValuesForKey:(NSString *)key fromArray:(NSArray *)array {
    // Create a mutable set to store unique values
    NSMutableSet *uniqueValuesSet = [NSMutableSet set];
    // Loop through the array and add each value to the set
    for (NSDictionary *dict in array) {
        // Extract the value for the given key
        id value = dict[key];
        //[[dic valueForKey:key] isEqualToString:@"<null>"]
        if (value != [NSNull null]) {
            [uniqueValuesSet addObject:value];
        }
    }
    // Convert the set back to an array if you need an NSArray
    NSArray *uniqueValuesArray = [uniqueValuesSet allObjects];
    return uniqueValuesArray;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //[textField resignFirstResponder];
    //[textField isFirstResponder];
    if (textField == self.txtContact) {
        if (textField.text != nil || ![textField.text isEqualToString:@""]) {
            if (textField.text.length == 10) {
                //[self getDataByContactNo:self.txtContact.text];
            }
        }
    } else if (textField == self.txtStatus) {
        [self showPickerToolbarForTextField:textField];
        [self.pickerDataList removeAllObjects];
        NSArray *uniqueNames = [self getUniqueValuesForKey:@"ostatus" fromArray: _arrayDataItem];
        self.pickerDataList = [uniqueNames mutableCopy];
        [self.pickerView reloadAllComponents];
    } else if (textField == self.txtSearchItem) {
        [self showPickerToolbarForTextField:textField];
        [self.pickerDataList removeAllObjects];
//        NSArray *uniqueNames = [self getUniqueValuesForKey:@"" fromArray: _arrayDataItem];
//        self.pickerDataList = [uniqueNames mutableCopy];
        [self.pickerView reloadAllComponents];
    } else if (textField == self.txtStamp) {
        [self showPickerToolbarForTextField:textField];
        [self.pickerDataList removeAllObjects];
        NSArray *uniqueNames = [self getUniqueValuesForKey:@"curstamp" fromArray: _arrayDataItem];
        self.pickerDataList = [uniqueNames mutableCopy];
        [self.pickerView reloadAllComponents];
    } else if (textField == self.txtParty) {
        [self showPickerToolbarForTextField:textField];
        [self.pickerDataList removeAllObjects];
        NSArray *uniqueNames = [self getUniqueValuesForKey:@"cname" fromArray: _arrayDataItem];
        self.pickerDataList = [uniqueNames mutableCopy];
        [self.pickerView reloadAllComponents];
    } else if (textField == self.txtKarigar) {
        [self showPickerToolbarForTextField:textField];
        [self.pickerDataList removeAllObjects];
        NSArray *uniqueNames = [self getUniqueValuesForKey:@"karigar" fromArray: _arrayDataItem];
        self.pickerDataList = [uniqueNames mutableCopy];
        [self.pickerView reloadAllComponents];
    }else if (textField == self.txtDateTo || textField == self.txtDateFrom) {
                [self showPickerToolbarForTextField:textField];
    }else{
        //[textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // This dismisses the keyboard
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtContact) {
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (updatedString.length == 10) {
            // You can hide or disable other UI elements here
            NSLog(@"More than 10 digits: %@", updatedString);
            //[self getDataByContactNo:updatedString];
            return NO; // Allow typing until 10 digits
        } else {
            // Only allow entering more text (e.g. show other UI elements) after 10 digits
            // You can show additional content here or trigger some logic
            NSLog(@"less than 10 digits: %@", updatedString);
            return YES; // Or YES if you want to allow further input
        }
    }
    return YES;
}

- (void)showPickerToolbarForTextField:(UITextField *)textField {
    // Add a toolbar above the date picker
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolbar sizeToFit];
    // Add Cancel and Done buttons
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelDatePicker:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (textField == self.txtDateFrom || textField == self.txtDateTo) {
        textField.inputView = self.datePicker;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(doneDatePicker:)];
        toolbar.items = @[cancelButton, flexibleSpace, doneButton];
    }else{
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(donePickerView:)];
        toolbar.items = @[cancelButton, flexibleSpace, doneButton];
    }
    textField.inputAccessoryView = toolbar;
}

#pragma mark - Button Action Methods

- (IBAction)saveButton:(id)sender{
    //    if ([self.txtContactNo1.text isEqual:@""]){
    //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
    //                                                                      message:@"Please select customer"
    //                                                               preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
    //                                                            style:UIAlertActionStyleDefault
    //                                                          handler:^(UIAlertAction * action){
    //        }];
    //        [alert addAction:yesButton];
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }else{
    //        [self saveCustomerDataApi];
    //    }
}

- (IBAction)cancelButton:(id)sender{
    // Dismiss the presented view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker View Methos

- (void) setUpPickerView{
    // Create the UIPickerView
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    // Set the input view of the UITextField to the UIPickerView
    self.txtStatus.inputView = self.pickerView;
    //self.txtSearchItem.inputView = self.pickerView;
    self.txtStamp.inputView = self.pickerView;
    self.txtParty.inputView = self.pickerView;
    self.txtKarigar.inputView = self.pickerView;
    // Add a target to the text field to detect text changes for search functionality
    [self.txtStatus addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtSearchItem addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtStamp addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtParty addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtKarigar addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

// Handle search text change
- (void)searchTextChanged:(UITextField *)textField {
    NSString *searchText = textField.text.lowercaseString;
    for (NSDictionary *item in _pickerDataList) {
        NSString *cname = item[@"cname"];
        // Use rangeOfString to check for partial match (case-insensitive)
        if ([cname rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            //[self.filteredData addObject:item];
        }
    }
//    if (self.filteredData.count < 1) {
//        self.filteredData = [_pickerDataList mutableCopy];
//    }
    // Reload the picker view with filtered data
    [self.pickerView reloadAllComponents];
}

#pragma mark - UIPickerView DataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1; // Single column picker
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerDataList.count; // Return the number of filtered items
}

// UIPickerView Delegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerDataList[row]; // Return the filtered data to display
    //return [[self.pickerDataList valueForKey:@"cname"] objectAtIndex:row];
}

// Handle when a row is selected
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selecteValue = self.pickerDataList[row];
    if (self.txtStatus.isFirstResponder) {
        self.txtStatus.text = selecteValue;
        [self.txtStatus resignFirstResponder];
    }else if (self.txtSearchItem.isFirstResponder) {
        self.txtSearchItem.text = selecteValue;
        [self.txtSearchItem resignFirstResponder];
    }else if (self.txtStamp.isFirstResponder) {
        self.txtStamp.text = selecteValue;
        [self.txtStamp resignFirstResponder];
    }else if (self.txtParty.isFirstResponder) {
        self.txtParty.text = selecteValue;
        [self.txtParty resignFirstResponder];
    }else if (self.txtKarigar.isFirstResponder) {
        self.txtKarigar.text = selecteValue;
        [self.txtKarigar resignFirstResponder];
    }
}

- (void)donePickerView:(id)sender {
   UITextField *textField = [[UITextField alloc] init];
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    // Get the value from pickerData array
    NSString *selecteValue = self.pickerDataList[selectedRow];
    
    if (self.txtStatus.isFirstResponder) {
        textField = self.txtStatus;
    }else if (self.txtSearchItem.isFirstResponder) {
        textField = self.txtSearchItem;
    }else if (self.txtStamp.isFirstResponder) {
        textField = self.txtStamp;
    }else if (self.txtParty.isFirstResponder) {
        textField = self.txtParty;
    }else if (self.txtKarigar.isFirstResponder) {
        textField = self.txtKarigar;
    }
    textField.text = selecteValue;
   [textField resignFirstResponder];
}

#pragma mark - DatePickerView method

- (void)datePickerViewSetUp {
    // Set up the date picker
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    if (@available(iOS 13.4, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    // Add a target for the date picker to update the text field
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    self.txtDateTo.inputView = self.datePicker;
    self.txtDateFrom.inputView = self.datePicker;
}

// Date picker value changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if (self.txtDateFrom.isFirstResponder) {
        self.txtDateFrom.text = [dateFormatter stringFromDate:datePicker.date];
    } else if (self.txtDateTo.isFirstResponder) {
        self.txtDateTo.text = [dateFormatter stringFromDate:datePicker.date];
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
    if (self.txtDateFrom.isFirstResponder) {
        textField = self.txtDateFrom;
    } else if (self.txtDateTo.isFirstResponder) {
        textField = self.txtDateTo;
    }
    UIDatePicker *picker = (UIDatePicker *)textField.inputView;
    textField.text = [formatter stringFromDate:picker.date];
    [textField resignFirstResponder];
    [self.view endEditing:YES];  // Dismiss the keyboard and date picker
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

- (void)parse_GETmembers:(NSData *) data {
    NSError *jsonError;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSLog(@"Karigar Name Response: %@", jsonResponse);
    //self->array_KarigarNameList = [[NSMutableArray alloc]init];
    //self->array_KarigarNameList =
    self.txtContact.text = [jsonResponse objectForKey:@"cnmlist"];
    //NSLog(@"cnmlist : %@",self->array_KarigarNameList);
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.pickerView reloadAllComponents];
    });
}


/*
-(void)saveCustomerDataApi{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *sm_mobile = self.txtContact.text;
    NSString *str_status = self.txtStatus.text;
    NSString *str_item = self.txtSearchItem.text;
    NSString *str_stamp = self.txtStamp.text;
    NSString *str_party = self.txtParty.text;
    NSString *str_karigar = self.txtKarigar.text;
    NSString *str_wtFrom = self.txtWTFrom.text;
    NSString *str_wtTo = self.txtWtTo.text;
    NSString *str_dateFrom = self.txtDateFrom.text;
    NSString *str_dateTo = self.txtDateTo.text;
    
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
*/

-(void) saveData:(NSData *)apiData{
    
    NSDictionary *personInfo = @{
        @"contact": self.txtContact.text,
        @"status": self.txtStatus.text,
        @"item": self.txtSearchItem.text,
        @"stamp": self.txtStamp.text,
        
        @"party": self.txtParty.text,
        @"karigar": self.txtKarigar.text,
        @"dateFrom": self.txtDateFrom.text,
        @"dateTo": self.txtDateTo.text,
        @"isSaved": @YES
    };
    [[BusyIndicator sharedInstance]stopIndicator];
    // Call the delegate method to send data back to the parent view controller
    if ([self.delegate respondsToSelector:@selector(didFinishFilterOrderWithData:customerData:)]) {
        [self.delegate didFinishFilterOrderWithData:apiData customerData:personInfo];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // Dismiss the presented view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
