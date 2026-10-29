//
//  StockFilterVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 06/10/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "StockFilterVC.h"
#import "CustomerVisitItemListVC.h"

#pragma mark - Custom NewRateBook UITableViewCell

@interface StockFilterVCTablCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblQuantity;
@property (nonatomic, strong) IBOutlet UIButton *btnCheck;

@end

@implementation StockFilterVCTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
@end

@implementation StockFilterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    arrayListData = [[NSMutableArray alloc]init];
    selectedItems = [NSMutableArray array];
    categoryItemList = [NSMutableArray array];
    groupItemList = [NSMutableArray array];
    otherItemList = [NSMutableArray array];
    selectedCategory = [NSMutableArray array];
    selectedGroup = [NSMutableArray array];
    selectedOther = [NSMutableArray array];
    
    siteListData = [NSMutableArray array];
    qualityListData = [NSMutableArray array];
    stampListData = [NSMutableArray array];
    otherItemList = @[@"Order Gold", @"Order Silver", @"Repair Gold", @"Repair Silver"];
    [self setUpView];
    [self get_PhysicalItem:@"" site:@"" qty:@"" stamp:@"" fiterValue:@""];
}

-(void)setUpView{
    txtSite.layer.cornerRadius = 10;
    txtSite.layer.borderWidth = 1;
    txtSite.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    txtQuality.layer.cornerRadius = 10;
    txtQuality.layer.borderWidth = 1;
    txtQuality.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    txtStamp.layer.cornerRadius = 10;
    txtStamp.layer.borderWidth = 1;
    txtStamp.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    [self getSiteFilterItemAPI];
    [self getStampListApi];
    txtSite.delegate = self;
    txtQuality.delegate = self;
    txtStamp.delegate = self;
}

-(void)setUpCheck{
    int totalValue = 0;
    int checkCount = 0;
    if ([selectedItems count] > 0){
        for (NSDictionary *item in selectedItems) {
            int itemtg = [[item valueForKey:@"tgpc"] intValue];
            totalValue = totalValue + itemtg;
            Boolean isSelected = [[item valueForKey:@"selected"] boolValue];
            checkCount = isSelected == true ? checkCount + 1 : checkCount;
        }
    }
    lblTotalPc.text = [NSString stringWithFormat: @"%lu", (unsigned long)totalValue];
    btnAllCheck.selected = checkCount == arrayListData.count ? true : false;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"tedt data");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // This dismisses the keyboard
    NSLog(@"text 12342");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSDictionary *filterValues = [self setUpFilterView];
    NSString *siteId = filterValues[@"siteid"];
    NSString *qualityId = filterValues[@"qualityid"];
    NSString *stampId = filterValues[@"stampid"];
    [self get_PhysicalItem:@"" site:siteId qty:qualityId stamp:stampId fiterValue:@""];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder]; // This dismisses the keyboard
    NSLog(@"text end 12342");
    return YES;
}

- (NSDictionary *)setUpFilterView {
    NSString *siteValue = @"";
    NSString *qtyValue = @"";
    NSString *stampValue = @"";
    
    if ([siteListData count] > 0) {
        for (NSDictionary *dict in siteListData) {
            NSString *idesc = dict[@"site"];
            if ([txtSite.text isEqualToString:idesc]) {
                siteValue = dict[@"siteid"];
                break;
            }
        }
    }
    
    if ([qualityListData count] > 0) {
        for (NSDictionary *dict in qualityListData) {
            NSString *idesc = dict[@"quality"];
            if ([txtQuality.text isEqualToString:idesc]) {
                qtyValue = dict[@"qualityid"];
                break;
            }
        }
    }
    
    if ([stampListData count] > 0) {
        for (NSDictionary *dict in stampListData) {
            NSString *idesc = dict[@"stamp"];
            if ([txtStamp.text isEqualToString:idesc]) {
                stampValue = dict[@"stampid"];
                break;
            }
        }
    }
    
    NSLog(@"siteValue = %@, qty Value = %@ and stamp Value = %@", siteValue, qtyValue, stampValue);
    
    return @{
        @"siteid": siteValue ?: @"",
        @"qualityid": qtyValue ?: @"",
        @"stampid": stampValue ?: @""
    };
}


#pragma mark: - Button Action Methods

-(IBAction)checkOrderBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)itemOptionBtnAction:(UIButton *)sender{
    btnItem.selected = false;
    btnCategory.selected = false;
    btnGroup.selected = false;
    btnIOrder.selected = false;
    sender.selected = !sender.selected;
    if (sender != btnItem) {
        itemsView.hidden = false;
        [itemTableView reloadData];
    }else{
        [selectedCategory removeAllObjects];
        [selectedGroup removeAllObjects];
        [selectedOther removeAllObjects];
        [self get_PhysicalItem:@"" site:@"" qty:@"" stamp:@"" fiterValue:@""];
    }
}

-(IBAction)checkAllBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [selectedItems removeAllObjects];
    if (sender.selected){
        selectedItems = [arrayListData mutableCopy];
    }
    [self setUpCheck];
    [tableView reloadData];
}

-(IBAction)cancelBtnAction:(id)sender{
    btnItem.selected = true;
    btnCategory.selected = false;
    btnGroup.selected = false;
    btnIOrder.selected = false;
    itemsView.hidden = true;
    [self get_PhysicalItem:@"" site:@"" qty:@"" stamp:@"" fiterValue:@""];
}

-(IBAction)okBtnAction:(id)sender{
    //    btnItem.selected = true;
    //    btnCategory.selected = false;
    //    btnGroup.selected = false;
    //    btnIOrder.selected = false;
    itemsView.hidden = true;
    if(btnCategory.selected){
        if(selectedCategory.count > 0){
            NSLog(@"category %@", selectedCategory);
            NSString *resultString = [[selectedCategory valueForKey:@"catid"] componentsJoinedByString:@","];
            resultString = [NSString stringWithFormat:@"%@", resultString];
            NSLog(@"%@", resultString);
            [self get_PhysicalItem:@"Category" site:@"" qty:@"" stamp:@"" fiterValue:resultString];
        }
    }else if(btnGroup.selected){
        if(selectedGroup.count > 0){
            NSLog(@"group %@", selectedGroup);
            NSString *resultString = [[selectedGroup valueForKey:@"igroupid"] componentsJoinedByString:@","];
            resultString = [NSString stringWithFormat:@"%@", resultString];
            NSLog(@"%@", resultString);
            [self get_PhysicalItem:@"Group" site:@"" qty:@"" stamp:@"" fiterValue:resultString];
        }
    }else if(btnIOrder.selected){
        if(selectedOther.count > 0){
            NSLog(@"Other %@", selectedOther);
            NSString *result = [[selectedOther valueForKeyPath:@"self"] componentsJoinedByString:@","];
            result = [NSString stringWithFormat:@"%@", result];
            NSLog(@"%@", result);
            [self get_PhysicalItem:@"Order" site:@"" qty:@"" stamp:@"" fiterValue:result];
        }
    }
}

-(IBAction)continueBtnAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)startNewCancleBtnAction:(id)sender{
    // 1. Convert array_ino to formatted string
    
    NSString *p_ino = [[selectedItems valueForKey:@"ino"] componentsJoinedByString:@","];
    p_ino = [NSString stringWithFormat:@"(%@)", p_ino];
    NSLog(@"%@", p_ino);
    
    // 2. Create str_ordrep2 based on array_order contents
    NSMutableString *str_ordrep2 = [NSMutableString string];
    
    if ([selectedOther containsObject:@"Order Gold"]) {
        [str_ordrep2 appendString:@"1"];
    } else {
        [str_ordrep2 appendString:@"0"];
    }
    
    if ([selectedOther containsObject:@"Order Silver"]) {
        [str_ordrep2 appendString:@"1"];
    } else {
        [str_ordrep2 appendString:@"0"];
    }
    
    if ([selectedOther containsObject:@"Repair Gold"]) {
        [str_ordrep2 appendString:@"1"];
    } else {
        [str_ordrep2 appendString:@"0"];
    }
    
    if ([selectedOther containsObject:@"Repair Silver"]) {
        [str_ordrep2 appendString:@"1"];
    } else {
        [str_ordrep2 appendString:@"0"];
    }
    // 3. Call InsertPScanApi method
    [self InsertPScanApiWithINO: p_ino ordrep2:str_ordrep2];
}

#pragma mark: - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self->tableView) {
        return arrayListData.count;
    }else{
        return btnCategory.selected ? categoryItemList.count : btnGroup.selected ? groupItemList.count : btnIOrder.selected ? otherItemList.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockFilterVCTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockFilterVCTablCell" forIndexPath:indexPath];
    
    cell.subView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.subView.layer.borderWidth = 1;
    cell.subView.layer.cornerRadius = 10;
    
    NSString *itemName = @"";
    NSString *itemQty = @"";
    
    if (tableView == self->tableView) {
        itemName = [[arrayListData valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        itemQty = [[arrayListData valueForKey:@"tgpc"] objectAtIndex:indexPath.row];
        //Boolean isSelected = [[[arrayListData valueForKey:@"selected"] objectAtIndex:indexPath.row] boolValue];
        //cell.btnCheck.selected = isSelected;
        NSString *cell_ino = [[arrayListData valueForKey:@"ino"] objectAtIndex:indexPath.row];
        cell.btnCheck.selected = false;
        if ([selectedItems count] > 0){
            for (NSDictionary *dict in selectedItems) {
                NSString *ino = dict[@"ino"];
                if ([cell_ino isEqualToString: ino]) {
                    cell.btnCheck.selected = YES;
                }
            }
        }
        cell.lblQuantity.hidden = false;
    }else{
        cell.btnCheck.selected = false;
        if (btnCategory.selected) {
            itemName = [[categoryItemList valueForKey:@"category"] objectAtIndex:indexPath.row];
            if ([selectedCategory count] > 0){
                for (NSDictionary *dict in selectedCategory) {
                    NSString *category = dict[@"category"];
                    if ([itemName isEqualToString: category]) {
                        cell.btnCheck.selected = YES;
                    }
                }
            }
        }else if (btnGroup.selected) {
            itemName = [[groupItemList valueForKey:@"igroup"] objectAtIndex:indexPath.row];
            if ([selectedGroup count] > 0){
                for (NSDictionary *dict in selectedGroup) {
                    NSString *igroup = dict[@"igroup"];
                    if ([itemName isEqualToString: igroup]) {
                        cell.btnCheck.selected = YES;
                    }
                }
            }
        }else if (btnIOrder.selected) {
            itemName = [otherItemList objectAtIndex:indexPath.row];
            if ([selectedOther count] > 0){
                for (NSString *idesc in selectedOther) {
                    if ([itemName isEqualToString: idesc]) {
                        cell.btnCheck.selected = YES;
                    }
                }
            }
        }
        cell.lblQuantity.hidden = true;
    }
    cell.lblName.text = [NSString stringWithFormat:@"%@",itemName];
    cell.lblQuantity.text = [NSString stringWithFormat:@"%@",itemQty];
    cell.btnCheck.tag = indexPath.row;
    [cell.btnCheck addTarget:self action:@selector(itemCheckbox:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)itemCheckbox:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (btnItem.selected) {
        NSDictionary *selectedItem = arrayListData[sender.tag];
        // Add it to the selectedItems array if not already there
        if (![selectedItems containsObject:selectedItem]) {
            [selectedItems addObject:selectedItem];
        }else{
            [selectedItems removeObject:selectedItem];
        }
        [self setUpCheck];
    }else  if (btnCategory.selected) {
        NSDictionary *selectedItem = categoryItemList[sender.tag];
        // Add it to the selectedItems array if not already there
        if (![selectedCategory containsObject:selectedItem]) {
            [selectedCategory addObject:selectedItem];
        }else{
            [selectedCategory removeObject:selectedItem];
        }
    }else  if (btnGroup.selected) {
        NSDictionary *selectedItem = groupItemList[sender.tag];
        // Add it to the selectedItems array if not already there
        if (![selectedGroup containsObject:selectedItem]) {
            [selectedGroup addObject:selectedItem];
        }else{
            [selectedGroup removeObject:selectedItem];
        }
    }else  if (btnIOrder.selected) {
        NSDictionary *selectedItem = otherItemList[sender.tag];
        // Add it to the selectedItems array if not already there
        if (![selectedOther containsObject:selectedItem]) {
            [selectedOther addObject:selectedItem];
        }else{
            [selectedOther removeObject:selectedItem];
        }
    }
}

#pragma mark: - Api Methods

-(void)get_PhysicalItem:(NSString *)filterType site: (NSString *) str_siteId qty: (NSString *) str_QtyId stamp:(NSString *) str_stamId fiterValue:(NSString *) str_FilterType{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]){
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@&p_filter=%@&billtype=%@&stampid=%@&quality=%@&siteid=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
        URL_API =[WEB_URL URL_Physical_Item];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_physicalitem.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@&type=%@&p_filter=%@&billtype=%@&stampid=%@&quality=%@&siteid=%@",apptype,mobile,ftppath, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&type=%@&p_filter=%@&billtype=%@&stampid=%@&quality=%@&siteid=%@",apptype,mobile, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
        URL_API = [WEB_URL URL_Physical_Item];
    }
    
    NSLog(@"Physical Param = %@",loginRequest);
    NSLog(@"Physical url = %@",URL_API);
    
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
                [self parseResponse_ScanId:data];
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

- (void)parseResponse_ScanId:(NSData *) data {
    @try {
        
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully Resopsnce Stock ... %@", jsonObject);
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            arrayListData = [pDict objectForKey:@"itemlist"];
            [tableView reloadData];
            int totalValue = 0;
            int checkCount = 0;
            for (NSDictionary *item in arrayListData) {
                int itemtg = [[item valueForKey:@"tgpc"] intValue];
                totalValue = totalValue + itemtg;
                Boolean isSelected = [[item valueForKey:@"selected"] boolValue];
                checkCount = isSelected == true ? checkCount + 1 : checkCount;
            }
            lblTotalPc.text = [NSString stringWithFormat: @"%lu", (unsigned long)totalValue];
            if(checkCount == arrayListData.count){
                selectedItems = [arrayListData mutableCopy];
            }
            btnAllCheck.selected = checkCount == arrayListData.count ? true : false;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)getSiteFilterItemAPI{
    
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *urlStr;
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        urlStr = [WEB_URL URL_GET_SITE];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        urlStr = [NSString stringWithFormat:@"http://%@/jwellyecat/get_site.php", ip];
    } else {
        urlStr = [WEB_URL URL_GET_SITE];
    }
    
    NSLog(@"urlStr :::::::::: %@",urlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSMutableString *postBody = [NSMutableString stringWithFormat:@"apptype=%@&mobile=%@", ECAT_TYPE, regmobile];
    
    if ([regmobile isEqualToString:mobile]) {
        [postBody appendString:@"&is_register=1"];
    } else {
        [postBody appendString:@"&is_register=0"];
    }
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];
        
        [postBody appendFormat:@"&ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@", ip, username, password, db, ftppath];
    }
    NSLog(@"postBody :::::::::: %@",postBody);
    
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest:request
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [[BusyIndicator sharedInstance] stopIndicator];
        
        if (!jsonError) {
            NSLog(@"responseDict :::::::::: %@",responseDict);
            self->siteListData = [responseDict[@"sitelist"] mutableCopy];
            NSArray *siteListPickerData = [self->siteListData valueForKey:@"site"];
            self->qualityListData = [responseDict[@"qualitylist"] mutableCopy];
            NSArray *qualityListPickerData = [self->qualityListData valueForKey:@"quality"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->txtSite addPickerWithData:siteListPickerData searchEnabled:NO];
                [self->txtQuality addPickerWithData:qualityListPickerData searchEnabled:NO];
                self->categoryItemList = [responseDict[@"categorylist"] mutableCopy];
                self->groupItemList = [responseDict[@"grouplist"] mutableCopy];
            });
        }
    }];
    [task resume];
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
            self->stampListData = [response[@"stamplist"] mutableCopy];
            NSArray *stampListPickerData = [self->stampListData valueForKey:@"stamp"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->txtStamp addPickerWithData:stampListPickerData searchEnabled:NO];
            });
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

/*
 - (void)InsertPScanApi:(NSString *)p_ino orderString:(NSString *)str_ordrep2 {
 webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
 [[BusyIndicator sharedInstance]startIndicator];
 NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
 NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
 NSString *loginRequest;
 NSString *URL_API;
 NSString *apptype = ECAT_TYPE;
 
 if ([ECAT_TYPE isEqualToString:@"1"]){
 NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
 NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
 NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
 NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
 NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
 
 loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@&p_filter=%@&billtype=%@&stamid=%@&quality=%@&siteid=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
 
 //params.put("ordrep2", str_ordrep2);
 //params.put("ino", p_ino);
 //params.put("tgpc", txt_totalpc.getText().toString());
 
 URL_API = [WEB_URL URL_Insert_Physical];
 }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
 NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
 NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
 URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_pscan.php",ip];
 loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@&type=%@&p_filter=%@&billtype=%@&stamid=%@&quality=%@&siteid=%@",apptype,mobile,ftppath, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
 }else{
 loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&type=%@&p_filter=%@&billtype=%@&stamid=%@&quality=%@&siteid=%@",apptype,mobile, filterType, str_FilterType, @"", str_stamId, str_QtyId, str_siteId];
 URL_API = [WEB_URL URL_Insert_Physical];
 }
 
 NSLog(@"Physical Param = %@",loginRequest);
 NSLog(@"Physical url = %@",URL_API);
 
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
 [self parseResponseFilterData:data];
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
 
 - (void)parseResponseFilterData:(NSData *) data {
 @try {
 
 NSString *myData = [[NSString alloc] initWithData:data
 encoding:NSUTF8StringEncoding];
 NSLog(@"JSON data = %@", myData);
 NSError *error = nil;
 [[BusyIndicator sharedInstance]stopIndicator];
 
 //parsing the JSON response
 id jsonObject = [NSJSONSerialization
 JSONObjectWithData:data
 options:NSJSONReadingAllowFragments
 error:&error];
 if (jsonObject != nil && error == nil){
 NSLog(@"Successfully Resopsnce Stock ... %@", jsonObject);
 
 //check if the country code was valid
 NSMutableDictionary *pDict = [NSJSONSerialization
 JSONObjectWithData:data
 options:NSJSONReadingAllowFragments
 error:&error];
 //arrayListData = [pDict objectForKey:@"itemlist"];
 }
 }
 @catch (NSException *exception) {
 }
 @finally {
 }
 }
 */

- (void)InsertPScanApiWithINO:(NSString *)p_ino ordrep2:(NSString *)str_ordrep2 {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ECAT_TYPE = [defaults stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [defaults stringForKey:@"mobile"];
    
    NSString *apiURL = @"";
    if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *URL_ip = [defaults stringForKey:@"ip"];
        apiURL = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_pscan.php", URL_ip];
    } else {
        apiURL = [WEB_URL URL_Insert_Physical];; // Define this constant or property
    }
    
    NSDictionary *filterValues = [self setUpFilterView];
    NSString *siteId = filterValues[@"siteid"];
    NSString *qualityId = filterValues[@"qualityid"];
    NSString *stampId = filterValues[@"stampid"];
    
    // Prepare POST parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ordrep2"] = str_ordrep2;
    params[@"mobile"] = mobile;
    params[@"ino"] = p_ino;
    params[@"tgpc"] = lblTotalPc.text;
    params[@"stamid"] = stampId;
    params[@"siteid"] = siteId;
    params[@"quality"] = qualityId;
    params[@"ordrep"] = btnCheckWithOrderRepair.selected == true ? @"1" : @"0";
    params[@"apptype"] = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        params[@"ip"] = [defaults stringForKey:@"ip"];
        params[@"ipusername"] = [defaults stringForKey:@"ipusername"];
        params[@"password"] = [defaults stringForKey:@"pswd"];
        params[@"dbname"] = [defaults stringForKey:@"db"];
        params[@"ftppath"] = [defaults stringForKey:@"ftppath"];
    }
    
    // Encode parameters
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in params) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }
    NSString *postString = [paramArray componentsJoinedByString:@"&"];
    
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"InsertPScanApi Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON Parse Error: %@", jsonError.localizedDescription);
            return;
        }
        NSLog(@"responce data %@", json);
        NSString *success = json[@"success"];
        NSString *message = json[@"message"];
        [[BusyIndicator sharedInstance]stopIndicator];
        if ([success isEqualToString:@"1"]) {
            NSString *pscid = json[@"pscid"];
            NSString *dtime = json[@"dtime"];
            
            // Save to preferences
//            [defaults setObject:dtime forKey:@"dtime"];
//            [defaults setObject:pscid forKey:@"pscid"];
//            [defaults synchronize];
            
            // Update UI on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Responce filter data");
                if (self.completionHandler) {
                    self.completionHandler(json);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {
            // Show alert on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    
    [task resume];
}


@end
