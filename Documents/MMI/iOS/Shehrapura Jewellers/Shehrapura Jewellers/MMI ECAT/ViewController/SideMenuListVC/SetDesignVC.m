//
//  SetDesignVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "SetDesignVC.h"
#import "SWRevealViewController.h"

@interface SetDesignVCTablCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblItemName;
@property (nonatomic, strong) IBOutlet UITextField *txtItem;
@property (nonatomic, strong) IBOutlet UITextField *txtSrno;
@property (nonatomic, strong) IBOutlet UITextField *txtPdfSum;
@property (nonatomic, strong) IBOutlet UITextField *txtPrint;
@property (nonatomic, strong) IBOutlet UIButton *btnCheck;

@end

@implementation SetDesignVCTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end


@interface SetDesignVC()
{}
@end

@implementation SetDesignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Set Item Details";
    if (_openWithSidMenu) {
        [self setUpNavigationBtn];
    }
    [self scrollData_Category];
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

#pragma mark:- UITextField Delegate Method

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger row = textField.tag;
    if (row >= tblListData.count) return;

    NSMutableDictionary *rowData = [tblListData[row] mutableCopy];
    NSString *key = textField.accessibilityIdentifier;

    if (key) {
        rowData[key] = textField.text ?: @"";
        tblListData[row] = rowData;
    }
}




#pragma mark:- Button Action Method

- (IBAction)btnSaveAction:(UIButton *)sender{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    for (NSDictionary *rowData in tblListData) {
        NSString *itemName = rowData[@"itemname"] ?: @"";
        NSString *item = rowData[@"caption"] ?: @"";
        NSString *srno = rowData[@"srno"] ?: @"";
        NSString *pdfSum = rowData[@"pdf9sum"] ?: @"";
        NSString *print = rowData[@"print9"] ?: @"";
        NSString *selected = rowData[@"selected"] ?: @"0";

        NSString *strdata = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", itemName, item, srno, pdfSum, print, selected];
        [resultArray addObject:strdata];
    }

    NSString *strListData = [resultArray componentsJoinedByString:@" : "];
    NSLog(@"Collected Data: %@", strListData);

    [self insertDisgnData:strListData];

    
    
    
    
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (NSNumber *rowNumber in tblListData) {
//        NSInteger row = [rowNumber integerValue];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        SetDesignVCTablCell *cell = [tblview cellForRowAtIndexPath:indexPath];
//        if (cell) {
//            NSString *strdata = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", cell.lblItemName.text ?: @"", cell.txtItem.text ?: @"", cell.txtSrno.text ?: @"", cell.txtPdfSum.text ?: @"", cell.txtPrint.text ?: @"", (cell.btnCheck.selected) ? @"1" : @"0"];
//            [resultArray addObject:strdata];
//        }
//    }
//    NSLog(@"Collected Data: %@", resultArray);
//    NSString *strListData = [resultArray componentsJoinedByString:@" : "];
//    NSLog(@"%@", strListData);
   //[self insertDisgnData:strListData];
}

- (void)btnCheckboxAction:(UIButton *)sender{
    //sender.selected = !sender.selected;
//    NSDictionary *selectedItem = tblListData[sender.tag];
    // Add it to the selectedItems array if not already there
    //    if (![selectDataList containsObject:selectedItem]) {
    //        [selectDataList addObject:selectedItem];
    //    }else{
    //        [selectDataList removeObject:selectedItem];
    //    }
    
//    if (![selectDataList containsObject:@(sender.tag)]) {
//        [selectDataList addObject:@(sender.tag)];
//    } else {
//        [selectDataList removeObject:@(sender.tag)];
//    }
//    NSLog(@"Selected Data = %@", selectDataList);
    
    NSInteger row = sender.tag;
       NSMutableDictionary *rowData = tblListData[row];
       BOOL newValue = ![rowData[@"selected"] boolValue];
       rowData[@"selected"] = @(newValue);
       sender.selected = newValue;
}

- (void)checkButtonTapped:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (row >= tblListData.count) return;

    NSMutableDictionary *rowData = [tblListData[row] mutableCopy];
    BOOL selected = !sender.selected;
    sender.selected = selected;

    rowData[@"selected"] = selected ? @"1" : @"0";
    tblListData[row] = rowData;
}


#pragma mark:- UITableView Delegate and DataSource  Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tblListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetDesignVCTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetDesignVCTablCell" forIndexPath:indexPath];
    //cell.lblItemName.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"caption"] objectAtIndex:indexPath.row]];
    
    cell.lblItemName.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"itemname"] objectAtIndex:indexPath.row]];
    cell.txtItem.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"caption"] objectAtIndex:indexPath.row]];
    cell.txtSrno.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"srno"] objectAtIndex:indexPath.row]];
    cell.txtPdfSum.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"pdf9sum"] objectAtIndex:indexPath.row]];
    cell.txtPrint.text = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"print9"] objectAtIndex:indexPath.row]];
    NSString *strSelected = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"selected"] objectAtIndex:indexPath.row]];
    cell.btnCheck.tag = indexPath.row;
    cell.btnCheck.selected = [strSelected isEqualToString:@"1"] ? true : false;
    [cell.btnCheck addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if ([strSelected isEqualToString:@"1"]){
        if (![selectDataList containsObject:@(indexPath.row)]) {
            [selectDataList addObject:@(indexPath.row)];
        }
    }
    
    [cell.txtItem addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    [cell.txtSrno addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    [cell.txtPdfSum addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    [cell.txtPrint addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    cell.txtItem.delegate = self;
    cell.txtSrno.delegate = self;
    cell.txtPdfSum.delegate = self;
    cell.txtPrint.delegate = self;
    
    cell.txtItem.tag = indexPath.row;
    cell.txtItem.accessibilityIdentifier = @"caption";

    cell.txtSrno.tag = indexPath.row;
    cell.txtSrno.accessibilityIdentifier = @"srno";

    cell.txtPdfSum.tag = indexPath.row;
    cell.txtPdfSum.accessibilityIdentifier = @"pdf9sum";

    cell.txtPrint.tag = indexPath.row;
    cell.txtPrint.accessibilityIdentifier = @"print9";

    return cell;
}

#pragma mark:- Api Method

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_GetDESIGNDATAList];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_setdesign.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API =[WEB_URL URL_GetDESIGNDATAList];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"Param = %@",loginRequest);
    NSLog(@"Api name = %@",api);
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
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


- (void) parseResponse_category:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            tblListData =[[NSMutableArray alloc]init];
            selectDataList =[[NSMutableArray alloc]init];
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray * rensarray_data =[[NSMutableArray alloc]init];
            rensarray_data = [pDict objectForKey:@"data"];
            tblListData = [rensarray_data mutableCopy];
//            for (int row; row < tblListData.count; row++) {
//                NSString *strSelected = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"selected"] objectAtIndex:row]];
//                    if ([strSelected isEqualToString:@"1"]) {
//                        [selectDataList addObject:@(row)];
//                    }
//            }
            NSLog(@"nsarray_data :: %@", tblListData);
            NSLog(@"selected array_data :: %@", selectDataList);
            [tblview reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)insertDisgnData:(NSString *) strlistData {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&designparam=%@",apptype,ip,db,ipusername,pswd,ftppath,strlistData];
        
        URL_API =[WEB_URL URL_Insert_Set_Design];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_set_design.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&designparam=%@",apptype,ftppath,strlistData];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&designparam=%@",apptype,strlistData];
        URL_API =[WEB_URL URL_Insert_Set_Design];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"Param = %@",loginRequest);
    NSLog(@"Api name = %@",api);
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponseData:data];
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


- (void) parseResponseData:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSString *success = jsonDict[@"success"];
            NSString *message = @"Successfully Updated.";//jsonDict[@"message"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:message];
                [self scrollData_Category];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
@end

