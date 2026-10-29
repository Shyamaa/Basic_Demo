//
//  AddDemand.m
//  Jwelly Customer
//
//  Created by mmsoft116 on 10/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "AddDemand.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "HomeBannerCell.h"

@interface AddDemand ()
 
@end

@implementation AddDemand

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    self.imagesArray = [NSMutableArray array];
    //self.lblCustomerName.text = @"Customer Name";
    self.lblCustomerName.text = @"";
    [self setUpView];
    
    [self getItemListApi];
    [self getStampListApi];

    self.txtCustomerName.delegate = self;
    self.txtItemName.delegate = self;
    self.txtSelectStamp.delegate = self;
    self.txtSelectGrWt.delegate = self;
    
    [self setupDatePickerForTextField:self.txtDueDate];

    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.imagesArray = [NSMutableArray array];
}

-(void)setUpView{
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *user_mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    
    //if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
    if([ECAT_TYPE isEqualToString:@"3"]){
        self.txtSize.hidden = true;
        //self.viewCustomerName.hidden = true;
        self.viewKarigarName.hidden = true;
        self.viewSalesmanName.hidden = true;
        self.viewOtherName.hidden = true;
        self.viewWstg.hidden = true;
        self.viewLbr.hidden = true;
        self.viewOption.hidden = true;
        
        self.viewDueDate.hidden = true;
        self.viewAmount.hidden = true;
        
        self.txtDueDate.textAlignment = NSTextAlignmentLeft;
        self.txtDueDate.placeholder = @" Due Date";
        
        str_cname = username;
        self.txtCustomerName.text = user_mobile;
        self.lblCustomerName.text = username;
        self.txtCustomerName.userInteractionEnabled = NO;
        
        if (_str_orderno.length > 0){
            [self getOrderData];
            self.title = @"Edit Demand";
        }else{
            self.title = @"Add Demand";
        }
    }else{
        self.title = [self.str_Activity isEqualToString: @"REP"] ? @"Customer Repair" : @"Customer Order";
        [self getKarigarNameListApi];
        [self getSalesmanNameListApi];
    }
}

#pragma mark - Banner Collection View Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
    
    // Set the default image
    bannerCell.bannerImageView.image = nil;
//    bannerCell.bannerImageView.image = [UIImage imageNamed:@"plusitem.png"];
//    //bannerCell.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
//    if (([self.imagesArray count] > 0) && (indexPath.row <= [self.imagesArray count] -1)) {
//        bannerCell.bannerImageView.image = self.imagesArray[indexPath.row];
//        //bannerCell.bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    
    bannerCell.bannerImageView.image =
        [UIImage imageNamed:@"plusitem.png"];

    if (indexPath.item < self.imagesArray.count) {

        id imageObject = self.imagesArray[indexPath.item];

        if ([imageObject isKindOfClass:[UIImage class]]) {
            bannerCell.bannerImageView.image = imageObject;
        }
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


#pragma mark - UITextFieldDelegate method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   if (textField == self.txtCustomerName) {
        NSLog(@"Select Customer Name");
       [self.view endEditing:YES];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self presentCustomerViewController];
       });
    } else if (textField == self.txtItemName) {
        NSLog(@"Select Item Name");
        [self alert_ItemList];
    } else if (textField == self.txtSelectStamp) {
        [self alert_StampList];
        NSLog(@"Select Stamp");
    } else if (textField == self.txtSelectGrWt) {
        [self alert_GrWtList];
        NSLog(@"Select Gr.WT");
    } else if (textField == self.txtSize) {
        NSLog(@"Select Size");
    } else if (textField == self.txtDueDate) {
        NSLog(@"Select Due Date");
    } else{
        NSLog(@"Select Other");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
    return YES;
}

#pragma mark:- Present Customer Form

- (void)presentCustomerViewController {
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
    CustomerVisitFormVC *popupVC = [[CustomerVisitFormVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.delegate = self;
    [self presentViewController:popupVC animated:YES completion:nil];
    });
}

// Implement the delegate method to get the data after the popup is dismissed
- (void)didFinishCustomerWithData:(NSData *)apiData customerData:(NSDictionary *)cdata{
    // Update the label with the data received from the popup
    NSLog(@"Cutomer API Data = %@", apiData);
    NSLog(@"Cutomer Data = %@", cdata);
    NSString *str_cname = [cdata valueForKey: @"cname"];
    NSString *str_cphone = [cdata valueForKey: @"contactNo1"];
    [self parse_Insertmember:apiData con_mob: str_cphone cname:str_cname];
}

- (void)parse_Insertmember:(NSData *)data con_mob:(NSString *)str_contact cname:(NSString *)str_pname {
    @try {
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil)
        {
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSLog(@"str_success :: %@",str_success);
            str_cname = str_pname;
            self.txtCustomerName.text = str_contact;
            self.lblCustomerName.text = str_pname;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


#pragma mark - Button Action Methods

- (IBAction)btn_save:(id)sender {
    NSString *mobile = self.txtCustomerName.text;
    NSString *item = self.txtItemName.text;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    //if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
    if([ECAT_TYPE isEqualToString:@"3"]){
        mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
        str_cname =[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    }
    if (mobile.length == 0) {
        [self showAlert1:@"Please select mobile" success:@"0"];
    }else if (item.length == 0) {
        [self showAlert1:@"Please select Item" success:@"0"];
//    }else if (self.imagesArray.count < 4){
//        [self showAlert1:@"Please select all image" success:@"0"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Save_data_demand];
        });
    }
}

- (IBAction)btnColour:()sender {
    _btnColour.selected = !_btnColour.selected;
}

- (IBAction)btnStones:(id)sender {
    _btnStones.selected = !_btnStones.selected;
}

- (IBAction)btnMina:(id)sender {
    _btnMina.selected = !_btnMina.selected;
}

#pragma mark - Alert Lits Item UI Methods

-(void) alert_ItemList {
    controller_item = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 500);
    [controller_item setPreferredContentSize:rect.size];
    
    [table_item reloadData];
    table_item  = [[UITableView alloc]initWithFrame:rect];
    table_item.delegate = self; 
    table_item.dataSource = self;
    table_item.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_item setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_item setTag:1000];
    [controller_item.view addSubview:table_item];
    [controller_item.view bringSubviewToFront:table_item];
    [controller_item.view setUserInteractionEnabled:YES];
    [table_item setUserInteractionEnabled:YES];
    [table_item setAllowsSelection:YES];
    [table_item reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_item forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        self.txtItemName.text = @"Select Item";
        
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}


-(void)alert_StampList {
    controller_stamp = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [controller_stamp setPreferredContentSize:rect.size];
    
    [table_stamp reloadData];
    table_stamp  = [[UITableView alloc]initWithFrame:rect];
    table_stamp.delegate = self;
    table_stamp.dataSource = self;
    table_stamp.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_stamp setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_stamp setTag:1000];
    [controller_stamp.view addSubview:table_stamp];
    [controller_stamp.view bringSubviewToFront:table_stamp];
    [controller_stamp.view setUserInteractionEnabled:YES];
    [table_stamp setUserInteractionEnabled:YES];
    [table_stamp setAllowsSelection:YES];
    [table_stamp reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_stamp forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}


-(void) alert_GrWtList{
    array_lbron = [[NSMutableArray alloc]init];
    [array_lbron addObject:@"Gr.Wt"];
    [array_lbron addObject:@"N.Wt"];
    [array_lbron addObject:@"Pc"];
    [array_lbron addObject:@"Rs"];
    [array_lbron addObject:@"%"];
    
    controller_lbron = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 250);
    [controller_lbron setPreferredContentSize:rect.size];
    
    [table_lbron reloadData];
    table_lbron = [[UITableView alloc]initWithFrame:rect];
    table_lbron.delegate = self;
    table_lbron.dataSource = self;
    table_lbron.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_lbron setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_lbron setTag:1000];
    [controller_lbron.view addSubview:table_lbron];
    [controller_lbron.view bringSubviewToFront:table_lbron];
    [controller_lbron.view setUserInteractionEnabled:YES];
    [table_lbron setUserInteractionEnabled:YES];
    [table_lbron setAllowsSelection:YES];
    [table_lbron reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_lbron forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Select GrWt");
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}

#pragma mark - Alert Methods

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


#pragma mark - UITableView Delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == table_stamp){
        return [[array_stamp valueForKey:@"stamp"] count];
    }else if (tableView == table_lbron) {
        return [array_lbron count];
    }else if (tableView == table_item) {
        return [[array_item valueForKey:@"idesc"] count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    
    if (tableView == table_stamp) {
        cell = [table_stamp dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        
        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [[array_stamp valueForKey:@"stamp"] objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }else if (tableView == table_lbron) {
        cell = [table_lbron dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        
        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [array_lbron objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }else if (tableView == table_item) {
        cell = [table_item dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        
        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [[array_item valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table_stamp){
        [controller_stamp dismissViewControllerAnimated:YES completion:nil];
        NSString *str_stamp = [[array_stamp valueForKey:@"stamp"] objectAtIndex:indexPath.row];
        self.txtSelectStamp.text = str_stamp;
    }else if (tableView == table_lbron){
        [controller_lbron dismissViewControllerAnimated:YES completion:nil];
        NSString *str_lbron = [array_lbron objectAtIndex:indexPath.row];
        self.txtSelectGrWt.text = str_lbron;
    }else if (tableView == table_item){
        [controller_item dismissViewControllerAnimated:YES completion:nil];
        //NSString *str_lbron = [array_lbron objectAtIndex:indexPath.row];
        NSString *str_item = [[array_item valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        self.txtItemName.text = str_item;
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
    
    if (([self.imagesArray count] > 0 ) && (([self.imagesArray count] - 1 == 4) || ([self.imagesArray count] - 1 >= self.selectedIndexPath.row))){
        [self.imagesArray replaceObjectAtIndex:self.selectedIndexPath.row withObject:selectedImage];
    }else{
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

#pragma mark:- Name List Api Methods

-(void)getKarigarNameListApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [webUrlconstant getAPIWithApiName:[WEB_URL URL_GET_KarigarNames]
                                 type:@"KarigarNames"
                           completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Karigar Name Response: %@", response);
            self->array_KarigarNameList = [[NSMutableArray alloc]init];
            self->array_KarigarNameList = [response objectForKey:@"cnmlist"];
            NSArray *karigarList = [self->array_KarigarNameList valueForKey:@"cname"];
            NSLog(@"cnmlist : %@",self->array_KarigarNameList);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtKarigarName addPickerWithData:karigarList searchEnabled:NO];
            });
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

-(void)getSalesmanNameListApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [webUrlconstant getAPIWithApiName:[WEB_URL URL_GET_SalesmanNames]
                                 type:@"SalesmanNames"
                           completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"SalesName Response: %@", response);
            self->array_SalesNameList = [[NSMutableArray alloc]init];
            self->array_SalesNameList = [response objectForKey:@"salesmanlist"];
            NSLog(@"salesmanlist : %@",self->array_SalesNameList);
            NSArray *saleNameList = [self->array_SalesNameList valueForKey:@"cname"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.pickerView reloadAllComponents];
                [self.txtSalesmanName addPickerWithData:saleNameList searchEnabled:NO];
            });
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

-(void)getItemListApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [webUrlconstant getAPIWithApiName:[WEB_URL URL_FEEDITEM]
                                 type:@"FEEDITEM"
                           completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@" Item Response: %@", response);
            self->array_item = [[NSMutableArray alloc]init];
            self->array_item = [response objectForKey:@"feeditem"];
            NSLog(@"feeditem %@",self->array_item);
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

-(void)getStampListApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [webUrlconstant getAPIWithApiName:[WEB_URL URL_GET_STAMP]
                                 type:@"STAMP"
                           completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@" Stamp Response: %@", response);
            self->array_stamp = [[NSMutableArray alloc]init];
            self->array_stamp = [response objectForKey:@"stamplist"];
            NSLog(@"stamplist %@",self->array_stamp);
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

#pragma mark - Data Save API  Methods

- (void)Save_data_demand {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE_NEW"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *URL_Config;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Config = [WEB_URL URL_SAVE_DEMAND_IOS];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        URL_Config = [NSString stringWithFormat:@"http://%@/jwellyecat/save_demand_ios.php", ip];
    } else {
        URL_Config = [WEB_URL URL_SAVE_DEMAND_IOS];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_Config]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];
    NSString *salesman_mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    
    // ✅ item_tgno — Android currentDateandTime (yyyyMMddHHmmss) use karta hai
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString *itemTgno = [fmt stringFromDate:[NSDate date]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:ECAT_TYPE_NEW ?: @"" forKey:@"apptype_4"];   // Android: apptype_4
    [params setObject:ECAT_TYPE_NEW ?: @"" forKey:@"apptype4"];    // backward compat
    [params setObject:ECAT_TYPE ?: @"" forKey:@"apptype"];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        [params setObject:ip forKey:@"ip"];
        [params setObject:db forKey:@"dbname"];
        [params setObject:ipusername forKey:@"ipusername"];
        [params setObject:pswd forKey:@"password"];
        [params setObject:ftppath forKey:@"ftppath"];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        [params setObject:ftppath forKey:@"ftppath"];
    }
    
    NSString *customerNumber = self.txtCustomerName.text;
    NSString *itemname = [self.txtItemName.text isEqualToString:@"Other"] ? self.txtOtherName.text : self.txtItemName.text;
    NSString *itemwt = [NSString stringWithFormat:@"%@", self.txtWeight.text];
    NSString *activity = [NSString stringWithFormat:@"%@", self.str_Activity ?: @""];
    NSString *stamp = [self.txtSelectStamp.text isEqualToString:@"Select Stamp"] ? @"" : self.txtSelectStamp.text;
    
    NSString *tunch = [NSString stringWithFormat:@"%@", self.txtTuch.text];
    NSString *wstg = [NSString stringWithFormat:@"%@", self.txtWstg.text];
    NSString *fine = [NSString stringWithFormat:@"%@", self.txtFine.text];
    NSString *rate = [NSString stringWithFormat:@"%@", self.txtRate.text];
    NSString *lbr = [NSString stringWithFormat:@"%@", self.txtLBR.text];
    NSString *lbron = self.txtSelectGrWt.text;
    NSString *size = [NSString stringWithFormat:@"%@", self.txtSize.text];
    NSString *duedate = [NSString stringWithFormat:@"%@", self.txtDueDate.text];
    NSString *advance_amt = [NSString stringWithFormat:@"%@", self.txtAdvanceAmount.text];
    NSString *kacno = @"";
    NSString *type = activity;
    NSString *description = [NSString stringWithFormat:@"%@", _txtDescription1.text];
    NSString *remark2 = [NSString stringWithFormat:@"%@", _txtDescription2.text];
    
    NSString *color  = self.btnColour.selected ? @"1" : @"0";
    NSString *stones = self.btnStones.selected ? @"1" : @"0";
    NSString *mina   = self.btnMina.selected   ? @"1" : @"0";
    
    [params setObject:customerNumber forKey:@"mobile"];
    [params setObject:itemname forKey:@"itemname"];
    [params setObject:itemwt forKey:@"itemwt"];
    [params setObject:rate forKey:@"rate"];
    [params setObject:lbr forKey:@"lbr"];
    [params setObject:advance_amt forKey:@"advance_amt"];
    [params setObject:lbron forKey:@"lbron"];
    [params setObject:kacno forKey:@"kacno"];
    [params setObject:str_cname ?: @"" forKey:@"name"];
    [params setObject:tunch forKey:@"tunch"];
    [params setObject:wstg forKey:@"wstg"];
    [params setObject:fine forKey:@"fine"];
    [params setObject:type forKey:@"type"];
    [params setObject:salesman_mobile forKey:@"salesman_mobile"];
    [params setObject:size forKey:@"size"];
    [params setObject:duedate forKey:@"duedate"];
    [params setObject:description forKey:@"description"];
    [params setObject:remark2 forKey:@"remark2"];
    [params setObject:color forKey:@"color"];
    [params setObject:stones forKey:@"stones"];
    [params setObject:mina forKey:@"mina"];
    [params setObject:stamp forKey:@"stamp"];
    [params setObject:activity forKey:@"activity"];
    
    // ✅ Android ke missing params
    [params setObject:str_cpid ?: @"" forKey:@"cpid"];
    [params setObject:itemTgno forKey:@"item_tgno"];
    
    if (self.str_orderno.length > 0) {
        [params setObject:self.str_orderno forKey:@"orderno"];
    }
    
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in params) {
        NSString *val = [NSString stringWithFormat:@"%@", params[key]];
        NSString *encVal = [val stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, encVal]];
    }
    [request setHTTPBody:[[pairs componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });
        if (error) { NSLog(@"Save error: %@", error.localizedDescription); return; }
        
        NSString *respStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"save_demand response = %@", respStr);
        
        NSError *jsonError = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonDict || jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert1:@"Invalid response" success:@"0"];
            });
            return;
        }
        
        // ✅ Robust orderno extraction (NSNull safe)
        id ordernoObj = jsonDict[@"orderno"];
        NSString *orderno = @"";
        if (ordernoObj && ![ordernoObj isKindOfClass:[NSNull class]]) {
            orderno = [NSString stringWithFormat:@"%@", ordernoObj];
        }
        if (orderno.length == 0 || [orderno isEqualToString:@"<null>"] || [orderno isEqualToString:@"null"]) {
            orderno = itemTgno;
            NSLog(@"⚠️ orderno null in response — fallback to item_tgno: %@", orderno);
        }
        
        NSString *success = [NSString stringWithFormat:@"%@", jsonDict[@"success"]];
        NSString *message = [NSString stringWithFormat:@"%@", jsonDict[@"message"]];
        
        if ([success isEqualToString:@"1"]) {
            if (self.imagesArray.count > 0) {
                [self uploadImagesSequentially:self.imagesArray
                                       orderno:orderno
                                         index:0
                                successMessage:message];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlert1:message success:@"1"];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert1:message success:@"0"];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Image Upload (exact replica of Android UPLOAD_IMAGE_TPRE)

- (void)uploadImagesSequentially:(NSArray *)images
                         orderno:(NSString *)orderno
                           index:(NSInteger)index
                  successMessage:(NSString *)successMessage {
    
    if (index >= images.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert1:successMessage success:@"1"];
        });
        return;
    }
    
    UIImage *img = images[index];
    if (![img isKindOfClass:[UIImage class]]) {
        [self uploadImagesSequentially:images orderno:orderno index:index+1 successMessage:successMessage];
        return;
    }
    
    // Android filenames: orderno + ".jpg", orderno + "A.jpg", orderno + "B.jpg", orderno + "C.jpg"
    NSArray *suffixes = @[@"", @"A", @"B", @"C"];
    NSString *suffix = index < suffixes.count ? suffixes[index] : @"";
    NSString *filename = [NSString stringWithFormat:@"%@%@.jpg", orderno, suffix];
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5f);
    if (!imageData) {
        [self uploadImagesSequentially:images orderno:orderno index:index+1 successMessage:successMessage];
        return;
    }
    
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *URL_Upload;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_Upload = [WEB_URL URL_UpLoadImage];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        URL_Upload = [NSString stringWithFormat:@"http://%@/jwellyecat/upload_image.php", ip];
    } else {
        // ✅ Aapke case ke liye (ECAT_TYPE 3):
        URL_Upload = @"http://sherpura.theappvisions.com/apps/jwellyecat1/upload_image.php";
    }
    
    NSLog(@"Upload URL = %@ | filename = %@", URL_Upload, filename);
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_Upload]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];
    
    // ----- Params (Android @Part order ke saath) -----
    NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];
    
    NSMutableData *body = [NSMutableData data];
    
    // @Part("filename") RequestBody
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"filename\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("ip")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"ip\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", ip ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("ipusername")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"ipusername\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", ipusername ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];

    // ✅ CORRECT
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", pswd ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("dbname")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"dbname\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", db ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("ftppath")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"ftppath\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", ftppath ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("apptype")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"apptype\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", ECAT_TYPE ?: @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part("tpre") RequestBody (empty string)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"tpre\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // ✅ @Part("type") String — Android "" bhejta hai
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // @Part file (name = "image")
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Final boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });
        
        if (error) {
            NSLog(@"Image %ld upload failed: %@", (long)index, error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadImagesSequentially:images orderno:orderno index:index+1 successMessage:successMessage];
            });
            return;
        }
        
        NSString *respStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Image %ld upload response: %@", (long)index, respStr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadImagesSequentially:images orderno:orderno index:index+1 successMessage:successMessage];
        });
    }];
    [task resume];
}

-(void)getOrderData{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *activity=@"product";
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,_str_orderno,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno_item.php",ip];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,_str_orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@",apptype,category,mobile,userid,activity,rlid,_str_orderno];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
    }
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    
    NSLog(@"URL_API ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    
    //Apply the data to
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
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


- (void) parseResponse_category:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSError *error = nil;
        
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
            
            
            NSMutableArray *nsarray_data = [pDict objectForKey:@"tg_master"];
            NSLog(@"nsarray_data :: %@",nsarray_data);
            [self setEditData: nsarray_data];
            /*
            if ([nsarray_data count] > 0 && _str_orderno.length > 0){
                NSString *orderNo = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"orderno"] objectAtIndex:0]];
                NSString *itemName = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_idesc"] objectAtIndex:0]];
                NSString *item_gwt = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_gwt"] objectAtIndex:0]];
                NSString *item_qty = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_qty"] objectAtIndex:0]];
                NSString *stamp = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"stamp"] objectAtIndex:0]];
                NSString *item_date = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_date"] objectAtIndex:0]];
                NSString *salemrp = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"salemrp"] objectAtIndex:0]];
                NSString *remarks = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"remarks"] objectAtIndex:0]];
                NSString *remarks1 = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"remarks1"] objectAtIndex:0]];
                self.txtItemName.text = itemName;
                self.txtWeight.text = item_gwt;
                self.txtPieces.text = item_qty;
                self.txtSelectStamp.text = stamp;
                self.txtDueDate.text = item_date;
                self.txtAdvanceAmount.text = salemrp;
                self.txtDescription1.text = remarks;
                self.txtDescription2.text = remarks1;
            }
            */
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)setEditData:(NSMutableArray *)nsarray_data {

    if (nsarray_data.count == 0 || _str_orderno.length == 0) {
        return;
    }

    NSDictionary *orderData = nsarray_data[0];

    NSString *itemName = [NSString stringWithFormat:@"%@", orderData[@"item_idesc"] ?: @""];
    NSString *item_gwt = [NSString stringWithFormat:@"%@", orderData[@"item_gwt"] ?: @""];
    NSString *item_qty = [NSString stringWithFormat:@"%@", orderData[@"item_qty"] ?: @""];
    NSString *stamp = [NSString stringWithFormat:@"%@", orderData[@"stamp"] ?: @""];
    NSString *item_date = [NSString stringWithFormat:@"%@", orderData[@"item_date"] ?: @""];
    NSString *salemrp = [NSString stringWithFormat:@"%@", orderData[@"salemrp"] ?: @""];
    NSString *remarks = [NSString stringWithFormat:@"%@", orderData[@"remarks"] ?: @""];
    NSString *remarks1 = [NSString stringWithFormat:@"%@", orderData[@"remarks1"] ?: @""];

    self.txtItemName.text = itemName;
    self.txtWeight.text = item_gwt;
    self.txtPieces.text = item_qty;
    self.txtSelectStamp.text = stamp;
    self.txtDueDate.text = item_date;
    self.txtAdvanceAmount.text = salemrp;
    self.txtDescription1.text = remarks;
    self.txtDescription2.text = remarks1;

    // Keep exactly four image slots.
    self.imagesArray = [NSMutableArray arrayWithObjects:
                        [NSNull null],
                        [NSNull null],
                        [NSNull null],
                        [NSNull null],
                        nil];

    [self.bannerCollectionView reloadData];

    NSArray *imageKeys = @[
        @"imgname",
        @"imgnameA",
        @"imgnameB",
        @"imgnameC"
    ];

    for (NSInteger i = 0; i < imageKeys.count; i++) {

        NSString *key = imageKeys[i];
        id imageValue = orderData[key];

        if (![imageValue isKindOfClass:[NSString class]]) {
            continue;
        }

        NSString *imageURLString = (NSString *)imageValue;

        if (imageURLString.length == 0 ||
            [imageURLString isEqualToString:@"<null>"] ||
            [imageURLString isEqualToString:@"null"]) {
            continue;
        }

        NSURL *imageURL = [NSURL URLWithString:imageURLString];

        if (!imageURL ||
            !([imageURL.scheme.lowercaseString isEqualToString:@"https"] ||
              [imageURL.scheme.lowercaseString isEqualToString:@"http"])) {
            NSLog(@"Invalid image URL: %@", imageURLString);
            continue;
        }

        NSInteger imageIndex = i;

        NSURLSessionDataTask *task =
        [[NSURLSession sharedSession]
         dataTaskWithURL:imageURL
         completionHandler:^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {

            if (error) {
                NSLog(@"Image download error %@: %@",
                      imageURLString, error.localizedDescription);
                return;
            }

            if (![response isKindOfClass:[NSHTTPURLResponse class]] ||
                ((NSHTTPURLResponse *)response).statusCode < 200 ||
                ((NSHTTPURLResponse *)response).statusCode >= 300) {
                NSLog(@"Image HTTP error: %@", imageURLString);
                return;
            }

            UIImage *image = [UIImage imageWithData:data];

            if (!image) {
                NSLog(@"Unable to decode image: %@", imageURLString);
                return;
            }

            dispatch_async(dispatch_get_main_queue(), ^{

                // Ensure the slot still exists.
                if (imageIndex < self.imagesArray.count) {
                    self.imagesArray[imageIndex] = image;
                    [self.bannerCollectionView reloadData];
                }

            });
        }];

        [task resume];
    }
}

-(void)setEditData1 :(NSMutableArray *) nsarray_data{
    if ([nsarray_data count] > 0 && _str_orderno.length > 0) {

        NSDictionary *orderData = nsarray_data[0];

        NSString *orderNo = [NSString stringWithFormat:@"%@", orderData[@"orderno"] ?: @""];
        NSString *itemName = [NSString stringWithFormat:@"%@", orderData[@"item_idesc"] ?: @""];
        NSString *item_gwt = [NSString stringWithFormat:@"%@", orderData[@"item_gwt"] ?: @""];
        NSString *item_qty = [NSString stringWithFormat:@"%@", orderData[@"item_qty"] ?: @""];
        NSString *stamp = [NSString stringWithFormat:@"%@", orderData[@"stamp"] ?: @""];
        NSString *item_date = [NSString stringWithFormat:@"%@", orderData[@"item_date"] ?: @""];
        NSString *salemrp = [NSString stringWithFormat:@"%@", orderData[@"salemrp"] ?: @""];
        NSString *remarks = [NSString stringWithFormat:@"%@", orderData[@"remarks"] ?: @""];
        NSString *remarks1 = [NSString stringWithFormat:@"%@", orderData[@"remarks1"] ?: @""];

        self.txtItemName.text = itemName;
        self.txtWeight.text = item_gwt;
        self.txtPieces.text = item_qty;
        self.txtSelectStamp.text = stamp;
        self.txtDueDate.text = item_date;
        self.txtAdvanceAmount.text = salemrp;
        self.txtDescription1.text = remarks;
        self.txtDescription2.text = remarks1;

        // Load order images
        NSArray *imageKeys = @[@"imgname", @"imgnameA", @"imgnameB", @"imgnameC"];

        [self.imagesArray removeAllObjects];

        for (NSString *key in imageKeys) {

            id imageValue = orderData[key];

            if (![imageValue isKindOfClass:[NSString class]]) {
                continue;
            }

            NSString *imageURLString = (NSString *)imageValue;

            if (imageURLString.length == 0 ||
                [imageURLString isEqualToString:@"<null>"] ||
                [imageURLString isEqualToString:@"null"]) {
                continue;
            }

            NSURL *imageURL = [NSURL URLWithString:imageURLString];

            if (!imageURL || !imageURL.scheme.length) {
                continue;
            }

            // Download image asynchronously
            NSURLSessionDataTask *task =
            [[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                        completionHandler:^(NSData *data,
                                                            NSURLResponse *response,
                                                            NSError *error) {

                if (error) {
                    NSLog(@"Image download error: %@", error.localizedDescription);
                    return;
                }

                if (![response isKindOfClass:[NSHTTPURLResponse class]] ||
                    ((NSHTTPURLResponse *)response).statusCode < 200 ||
                    ((NSHTTPURLResponse *)response).statusCode >= 300) {
                    NSLog(@"Image HTTP error: %@", imageURLString);
                    return;
                }

                UIImage *image = [UIImage imageWithData:data];

                if (!image) {
                    NSLog(@"Invalid image data: %@", imageURLString);
                    return;
                }

                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.imagesArray addObject:image];

                    [self.bannerCollectionView reloadData];

                });
            }];

            [task resume];
        }
    }
}


@end
