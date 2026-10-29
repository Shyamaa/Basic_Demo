//
//  CustomerVisit.m
//  MMI ECAT
//
//  Created by MMI SOFTWARES PVT LTD on 12/12/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "CustomerVisit.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PopupTouch.h"
#import "PopupLoosebill.h"
#import "MMIHOMEPanel.h"
#import "CustomerVisitTblCell.h"
#import "ItemDetail.h"
#import "CustomerVisitItemListVC.h"
#import "CustomerVisitApplyDataVC.h"


@interface CustomerVisit ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIButton *btn_item;
    NSString *cpid;
    NSString * visid;
    NSString *smacno;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) CAShapeLayer *overlayLayer;

@end

@implementation CustomerVisit
@synthesize str_act;

#pragma mark - Class Life Cycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"Customer Visit";
    //self.title = @"Visit";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setupNavigationBarButtons];
    //smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    //[self Get_prvsAPI];
    array_selectedItemList = [[NSMutableArray alloc] init];
    [self.collectionView setHidden:YES];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DefaultCell"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    //layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    //layout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)setupNavigationBarButtons {
    // Special button using UIButtonTypeContactAdd
    UIButton *bnt_Add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [bnt_Add addTarget:self action:@selector(btn_customer:) forControlEvents:UIControlEventTouchUpInside];
    bnt_Add.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *barAddBtn = [[UIBarButtonItem alloc] initWithCustomView:bnt_Add];
    barAddBtn.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 2;
    
    UIBarButtonItem *barSearch = [self createCustomButtonWithImageName:@"search.png" action:@selector(btn_Search:)];
    UIBarButtonItem *barAddUser = [self createCustomButtonWithImageName:@"add_user" action:@selector(btn_AddCustomer:)];
    UIBarButtonItem *barEdit = [self createCustomButtonWithImageName:@"item_edit" action:@selector(btn_edit:)];
    UIBarButtonItem *barcamera = [self createCustomButtonWithImageName:@"camera" action:@selector(btn_scan:)];
    UIBarButtonItem *barSelectAll = [self createCustomButtonWithImageName:@"select_all" action:@selector(btnSelectAll:)];
    
    self.navigationItem.rightBarButtonItems = @[barSearch, barAddBtn, barAddUser, barEdit, barcamera, barSelectAll];
}

- (void)setUpView {
    smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    [self Get_prvsAPI];
}

#pragma mark - Navigation Button Action Method

-(void)btn_Search:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.txtSearchBar setHidden:NO];
    }else{
        [self.txtSearchBar setHidden:YES];
    }
}

-(void)btn_customer:(UIButton*)sender{
    if ([cpid isEqualToString:@""]) {
        [self presentCustomerViewController];
    }else{
        UIStoryboard *customerVisitSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CustomerVisitItemListVC *popVc = [customerVisitSb instantiateViewControllerWithIdentifier:@"CustomerVisitItemListVC"];
        popVc.modalPresentationStyle = UIModalPresentationFullScreen; // Optional
        popVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        popVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        popVc.str_cpid = cpid;
        popVc.str_visid = visid;
        popVc.completionHandler = ^(NSMutableArray *listData) {
            NSLog(@"Received from child: %@", listData);
            self->array_selectedItemList = listData;
            [self.collectionView setHidden:NO];
            [self.collectionView reloadData];
        };
        [self presentViewController:popVc animated:YES completion:nil];
    }
}

-(void)btn_AddCustomer:(UIButton*)sender{
    [self presentCustomerViewController];
}

-(void)btn_edit:(UIButton*)sender{
    if ([visid isEqualToString:@"0"] || visid.length==0){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"Please select customer" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        PopupLoosebill *popupVC = [[PopupLoosebill alloc] init];
        popupVC.visid = visid;
        popupVC.completionHandler = ^(NSString *amount,NSString *wt, NSString *text2,NSString *btnaction) {
            if ([btnaction isEqualToString:@"Cancel"]) {
                [self cancelButtonPressed];
            }else if ([btnaction isEqualToString:@"Save"]) {
                [self ItemAPI];
            }
        };
        popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:popupVC animated:YES completion:nil];
    }
}

- (void)btn_scan:(id)sender {
    if ([visid isEqualToString:@"0"] || visid.length==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                      message:@"Please select customer"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        ScanViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
        obj.str_act = @"Customer Visit";
        obj.visid =  visid;
        obj.cusmobile =  lbl_mobile.text;
        obj.act = str_act;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

- (void)btnSelectAll:(id)sender {
    CustomerVisitApplyDataVC *popupVC = [[CustomerVisitApplyDataVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.str_visid = visid;
    popupVC.completionHandler = ^(NSDictionary *dic_Data) {
        NSLog(@"Received from child: %@", dic_Data);
        [self ItemAPI];
    };
    [self presentViewController:popupVC animated:YES completion:nil];
}

#pragma mark - Present Customer View Method

- (void)presentCustomerViewController {
    CustomerVisitFormVC *popupVC = [[CustomerVisitFormVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.delegate = self;
    [self presentViewController:popupVC animated:YES completion:nil];
}

// Implement the delegate method to get the data after the popup is dismissed
- (void)didFinishCustomerWithData:(NSData *)apiData customerData:(NSDictionary *)cdata{
    // Update the label with the data received from the popup
    NSLog(@"Cutomer API Data = %@", apiData);
    NSLog(@"Cutomer Data = %@", cdata);
    NSString *str_cname = [cdata valueForKey: @"cname"];
    NSString *str_contact1 = [cdata valueForKey: @"contactNo1"];
    [self parse_Insertmember:apiData con_mob:str_contact1 cname:str_cname];
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_tagno) {
        [txt_tagno resignFirstResponder];
    }  else{
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        nsarray_data = master_arrayData;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"idesc"] lowercaseString];
            NSString *tgno = [item[@"tgno"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            
            return ([name containsString:searchLower] ||
                    [tgno containsString:searchLower]);
        }];
        nsarray_data = [[master_arrayData filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    // });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [nsarray_data removeAllObjects];
    nsarray_data = master_arrayData;
    [self.tableView reloadData];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@", [metadataObj stringValue]);
            // Do something with the QR code value
        }
    }
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIBarButtonItem *)createCustomButtonWithImageName:(NSString *)imageName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [[button imageView] setContentMode:UIViewContentModeScaleAspectFit];
    button.tintColor = [UIColor whiteColor];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


-(void)Get_prvsAPI {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&smacno=%@",ECAT_TYPE_NEW,apptype,ip,db,ipusername,pswd,ftppath,smacno];
        
        URL_API = [WEB_URL URL_GET_CPVDET];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_cpvdet.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&ftppath=%@&smacno=%@",ECAT_TYPE_NEW,apptype,ftppath,smacno];
    }else{
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&smacno=%@",ECAT_TYPE_NEW,apptype,smacno];
        URL_API = [WEB_URL URL_GET_CPVDET];
    }
    
    NSLog(@"URL_API ***************** %@",URL_API);
    NSLog(@"loginRequest ***************** %@",loginRequest);
    
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
                [self parseResponse_prev:data];
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


- (void)parseResponse_prev:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
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
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            
            if ([str_success isEqualToString:@"1"])
            {
                NSMutableArray *nsarray_visid = [pDict objectForKey:@"visid"];
                visid = [nsarray_visid description];
                
                NSMutableArray *nsarray_cpid = [pDict objectForKey:@"cpid"];
                cpid = [nsarray_cpid description];
                
                NSMutableArray *nsarray_cpname = [pDict objectForKey:@"cpname"];
                NSString *cpname = [nsarray_cpname description];
                lbl_name.text = [NSString stringWithString:cpname];
                NSMutableArray *nscpmobile = [pDict objectForKey:@"cpmobile"];
                NSString *cpmobile = [nscpmobile description];
                lbl_mobile.text = [NSString stringWithString:cpmobile];
                [self ItemAPI];
            }else{
                [self presentCustomerViewController];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)showPopupWithTextFields
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter Details"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"First Name";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Last Name";
        CGRect frame = textField.frame;
        frame.origin.y += 10;
        textField.frame = frame;
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
        
        UITextField *firstNameTextField = alertController.textFields.firstObject;
        UITextField *lastNameTextField = alertController.textFields.lastObject;
        NSLog(@"First Name: %@", firstNameTextField.text);
        NSLog(@"Last Name: %@", lastNameTextField.text);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)ItemAPI{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *activity = @"product";
    NSString *rlid = @"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,userid,activity,rlid,visid,ip,db,ipusername,pswd,ftppath];
        URL_API = [WEB_URL URL_GET_CART_VISIT];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_cart_visit2.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@&ftppath=%@",apptype,mobile,userid,activity,rlid,visid,ftppath];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@",apptype,mobile,userid,activity,rlid,visid];
        URL_API = [WEB_URL URL_GET_CART_VISIT];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSLog(@"urlString_URL_GET_CART = %@",urlString);
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api_URL_GET_CART = %@",api);
    
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
        nsarray_qty = [[NSMutableArray alloc] init];
        nsarray_data = [[NSMutableArray alloc] init];
        master_arrayData = [[NSMutableArray alloc] init];
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON_Visit = %@", myData);
        NSLog(@"nsarray_data :: %@",nsarray_data);
        [self.tableView reloadData];
        
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
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
            
            
            nsarray_data = [pDict objectForKey:@"items"];
            master_arrayData = [nsarray_data mutableCopy];
            double int_wt = 0, int_salemrp = 0, int_qty = 0;
            double db_total = 0, intmrptotal = 0, intgwttotal = 0,intwttotal = 0;
            NSInteger gst_p = 0;
            NSInteger salemrp = 0;
            
            for (int i = 0; i < [nsarray_data count]; i++) {
                NSDictionary *dictObject = [nsarray_data objectAtIndex:i];
                NSString *qty = [dictObject objectForKey:@"item_qty"];
                [nsarray_qty addObject:qty];
                NSString *itemwt = [dictObject objectForKey:@"itemwt"];
                NSString *str_salemrp = [dictObject objectForKey:@"salemrp"];
                //NSString *str_salemrp = [dictObject objectForKey:@"slamt"];
                NSString *fine1 = [dictObject objectForKey:@"fine1"];
                NSString *fine2 = [dictObject objectForKey:@"fine2"];
                
                NSString *type = [dictObject objectForKey:@"type"];
                NSString *item_gwt = [dictObject objectForKey:@"item_gwt"];
                NSString *remarks1 = [dictObject objectForKey:@"remarks1"];
                NSString *t_amt = [dictObject objectForKey:@"t_amt"];
                
                salemrp = [str_salemrp intValue];
                
                if (![type isEqualToString:@""]) {
                    if ([type isEqualToString:@"S"]) {
                        db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal += [str_salemrp floatValue];
                        intwttotal += [itemwt length] > 0 ? [itemwt floatValue] : 0;
                        intgwttotal += [item_gwt length] > 0 ? [item_gwt floatValue] : 0;
                    } else if ([type isEqualToString:@"P"]) {
                        db_total -= ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal -= [str_salemrp floatValue];
                        intwttotal -= [itemwt floatValue];
                        if ([item_gwt length] > 0) {
                            intgwttotal -= [item_gwt floatValue];
                        }
                    } else if ([type isEqualToString:@"SR"] ||
                               [type isEqualToString:@"MR"] || [type isEqualToString:@"CASH"]) {
                        db_total -= ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal -= [str_salemrp floatValue];
                        intwttotal -= [itemwt floatValue];
                        intgwttotal -= [item_gwt floatValue];
                    } else if ([type isEqualToString:@"MP"]) {
                        db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal += [str_salemrp floatValue];
                        intwttotal += [itemwt floatValue];
                        intgwttotal += [item_gwt floatValue];
                    } else if ([type isEqualToString:@"REC"]) {
                        db_total -= ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal -= [str_salemrp floatValue];
                    } else if ([type isEqualToString:@"PAY"]) {
                        db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal += [str_salemrp floatValue];
                    } else if ([type isEqualToString:@"GPB"] ||
                               [type isEqualToString:@"SPB"]) {
                        db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal -= [str_salemrp floatValue];
                    } else if ([type isEqualToString:@"GSB"] ||
                               [type isEqualToString:@"SSB"]) {
                        db_total -= ([fine1 doubleValue] + [fine2 doubleValue]);
                        intmrptotal += [str_salemrp floatValue];
                    } else if ([type isEqualToString:@"TRN"]) {
                        if ([remarks1 isEqualToString:@"1"]) {
                            db_total -= ([fine1 doubleValue] + [fine2 doubleValue]);
                            intmrptotal -= [str_salemrp floatValue];
                        } else {
                            db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                            intmrptotal += [str_salemrp floatValue];
                        }
                    }
                } else {
                    db_total += ([fine1 doubleValue] + [fine2 doubleValue]);
                    intmrptotal += ([str_salemrp floatValue] + [t_amt floatValue]);
                    /*
                    if (salemrp == 0) {
                        intmrptotal = 0;
                        gst_p = 0;
                    } else {
                        intmrptotal += ([str_salemrp floatValue] + [t_amt floatValue]);
                    }
                    */
                    
                    if ([itemwt length] == 0 || [itemwt isEqualToString:@"null"]) {
                        intwttotal += 0;
                    } else {
                        intwttotal += [itemwt floatValue];
                    }
                    
                    if ([item_gwt length] == 0 || [item_gwt isEqualToString:@"null"]) {
                        intgwttotal += 0;
                    } else {
                        intgwttotal += [item_gwt floatValue];
                    }
                }
                int_qty = int_qty + [qty doubleValue];
                
                NSLog(@"Amount = %0.3f", intmrptotal);
            }
            lbl_pc.text = [NSString stringWithFormat:@"%.0f", int_qty];
            lbl_Gwt.text = [NSString stringWithFormat:@"%.3f", intgwttotal];
            lbl_wt.text = [NSString stringWithFormat:@"%.3f", intwttotal];
            lbl_Fine.text = [NSString stringWithFormat:@"%.3f", db_total];
            lbl_mrp.text = [NSString stringWithFormat:@"%.3f", intmrptotal];
            [self.tableView reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Calculate item width for 3 items per row
    CGFloat itemWidth = (self.collectionView.frame.size.width - 20) / 3;
    return CGSizeMake(itemWidth, 30); // Adjust the height as per your design
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [array_selectedItemList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultCell" forIndexPath:indexPath];

    // Always remove previous subviews to avoid stacking reused cells
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:12];
    label.text = [[array_selectedItemList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview: label];
    
//    UILabel *lbl_itemname = [[UILabel alloc] init];
//    lbl_itemname.frame = CGRectMake(10,5, cell.contentView.frame.size.width-20, 20);
//    //[lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
//    lbl_itemname.font = [UIFont systemFontOfSize:12];
//    lbl_itemname.text = [[array_selectedItemList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
//    lbl_itemname.textAlignment = NSTextAlignmentLeft;
//    lbl_itemname.textColor = [UIColor blackColor];
//    [cell.contentView addSubview:lbl_itemname];
    
    
    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:5],
        [label.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-5],
        [label.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:5],
        [label.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-5]
    ]];
    

    
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.clipsToBounds = YES;
    
    [UIView animateWithDuration:2.0 // Duration of animation
                             delay:0.0 // Delay before start
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            // Move text to the right
        label.frame = CGRectMake(0, 0, label.frame.size.width - 10, 30);
                        } completion:nil];
    
//    [UIView animateWithDuration:8.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
//        lbl_itemname.frame = CGRectMake(-lbl_itemname.intrinsicContentSize.width, 100, 200, 30);
//    } completion:nil];
    
    return cell;

}


    
#pragma mark - Table View Data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [nsarray_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerVisitTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerVisitTblCell" forIndexPath:indexPath];
    NSURL *URL = [NSURL URLWithString:[[nsarray_data valueForKey:@"itemimage"] objectAtIndex:indexPath.row]];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    [cell.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                        placeholderImage:[UIImage imageNamed:@"1024.png"]
                                 options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    NSString *strItemName = [[nsarray_data valueForKey:@"tgno"] objectAtIndex:indexPath.row];
    if ([strItemName isEqualToString:@""]){
        strItemName = [[nsarray_data valueForKey:@"idesc"] objectAtIndex:indexPath.row];
    }
    cell.lblItemTagNo.text = [NSString stringWithFormat:@"%@", strItemName];
    cell.lblItemGrossWt.text = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_gwt"] objectAtIndex:indexPath.row]];
    cell.lblItemWt.text = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"itemwt"] objectAtIndex:indexPath.row]];
    NSString *strMrp = [[nsarray_data valueForKey:@"salemrp"] objectAtIndex:indexPath.row];
    NSString *str_tamt = [[nsarray_data valueForKey:@"t_amt"] objectAtIndex:indexPath.row];
    float totalvalue = [strMrp floatValue] + [str_tamt floatValue];
    cell.lblItemSaleMrp.text = [NSString stringWithFormat:@"%.1f", totalvalue];
    //cell.lblItemSaleMrp.text = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"slamt"] objectAtIndex:indexPath.row]];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCheck.tag = indexPath.row;
    [cell.btnCheck addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.infoStackView.hidden = true;
    NSString *str_type = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"type"] objectAtIndex:indexPath.row]];
    
    if ([str_type isEqualToString:@""]){
        cell.btnEdit.tag = indexPath.row;
        [cell.btnEdit addTarget:self action:@selector(btnAdditional1Tapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblItemRate.text = @"0.00";
        cell.lblItemGst.text = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"gst"] objectAtIndex:indexPath.row]];
        cell.infoStackView.hidden = false;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemDetail *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetail"];
    obj.str_idesc=[[nsarray_data valueForKey:@"idesc"]objectAtIndex:indexPath.row];
    obj.str_image=[[nsarray_data valueForKey:@"itemimage"]objectAtIndex:indexPath.row];
    obj.str_image2=[[nsarray_data valueForKey:@"itemimage2"]objectAtIndex:indexPath.row];
    obj.str_image3=[[nsarray_data valueForKey:@"itemimage3"]objectAtIndex:indexPath.row];
    obj.str_image4=[[nsarray_data valueForKey:@"itemimage4"]objectAtIndex:indexPath.row];
    obj.str_image5=[[nsarray_data valueForKey:@"itemimage5"]objectAtIndex:indexPath.row];
    obj.str_tagno=[[nsarray_data valueForKey:@"tgno"]objectAtIndex:indexPath.row];
    obj.str_gwt=[[nsarray_data valueForKey:@"item_gwt"]objectAtIndex:indexPath.row];
    obj.str_qty=[[nsarray_data valueForKey:@"item_qty"]objectAtIndex:indexPath.row];
    obj.str_tpre=[[nsarray_data valueForKey:@"item_tpre"]objectAtIndex:indexPath.row];
    obj.str_design=[[nsarray_data valueForKey:@"item_design"]objectAtIndex:indexPath.row];
    obj.str_tsno=[[nsarray_data valueForKey:@"tsno"]objectAtIndex:indexPath.row];
    obj.str_item1=[[nsarray_data valueForKey:@"item1"]objectAtIndex:indexPath.row];
    obj.str_item2=[[nsarray_data valueForKey:@"item2"]objectAtIndex:indexPath.row];
    obj.str_item3=[[nsarray_data valueForKey:@"item3"]objectAtIndex:indexPath.row];
    obj.str_item4=[[nsarray_data valueForKey:@"item4"]objectAtIndex:indexPath.row];
    obj.str_rlid=@"0";
    obj.str_remarks=[[nsarray_data valueForKey:@"remarks"]objectAtIndex:indexPath.row];
    obj.str_shpc=@"0";
    obj.str_stamp=[[nsarray_data valueForKey:@"stamp"]objectAtIndex:indexPath.row];
    obj.str_tgimage = @"";
    obj.str_wt1 = @"";
    obj.str_status = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Table Cell Button Action Methods

- (void)checkButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"Button tapped in cell at row: %ld", (long)sender.tag);
}

- (void)deleteButtonTapped:(UIButton *)sender {
    NSInteger index_c = [sender tag];
    NSString *str_cartid = [[nsarray_data valueForKey:@"cart_id"] objectAtIndex:index_c];
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self URL_SINGLE_ITEM_DELETE:str_cartid];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)btnAdditional1Tapped:(UIButton *)sender{
    NSLog(@"Button tapped in cell at index: %ld", (long)sender.tag);
    NSString *str_visitdis = [[NSUserDefaults standardUserDefaults]stringForKey:@"visitdis"];
    if([str_visitdis isEqualToString:@"1"]){
        CustomerVisitApplyDataVC *popupVC = [[CustomerVisitApplyDataVC alloc] init];
        popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        popupVC.str_visid = visid;
        popupVC.completionHandler = ^(NSDictionary *dic_Data) {
            NSLog(@"Received from child: %@", dic_Data);
            [self ItemAPI];
        };
        popupVC.dicData = [nsarray_data objectAtIndex:sender.tag];
        [self presentViewController:popupVC animated:YES completion:nil];
    }else{
        PopupTouch *popupVC = [[PopupTouch alloc] init]; 
        popupVC.str_lbr = visid;
        popupVC.str_mrp = [[nsarray_data valueForKey:@"mrp"] objectAtIndex:sender.tag];
        popupVC.str_bhav = [[nsarray_data valueForKey:@"bhav"] objectAtIndex:sender.tag];
        popupVC.str_dis1 = [[nsarray_data valueForKey:@"dis1"] objectAtIndex:sender.tag];
        popupVC.str_dis2 = [[nsarray_data valueForKey:@"dis2"] objectAtIndex:sender.tag];
        popupVC.str_rate = [[nsarray_data valueForKey:@"rate"] objectAtIndex:sender.tag];
        popupVC.str_csamt = [[nsarray_data valueForKey:@"csmamt"] objectAtIndex:sender.tag];
        popupVC.str_lbron = [[nsarray_data valueForKey:@"lbron"] objectAtIndex:sender.tag];
        popupVC.str_pdis1 = [[nsarray_data valueForKey:@"pdis1"] objectAtIndex:sender.tag];
        popupVC.str_pdis2 = [[nsarray_data valueForKey:@"pdis2"] objectAtIndex:sender.tag];
        popupVC.str_sdamt = [[nsarray_data valueForKey:@"sdamt"] objectAtIndex:sender.tag];
        popupVC.str_slamt = [[nsarray_data valueForKey:@"slamt"] objectAtIndex:sender.tag];
        popupVC.str_ssamt = [[nsarray_data valueForKey:@"ssamt"] objectAtIndex:sender.tag];
        popupVC.str_stamp = [[nsarray_data valueForKey:@"stamp"] objectAtIndex:sender.tag];
        popupVC.str_csmamt = [[nsarray_data valueForKey:@"csmamt"] objectAtIndex:sender.tag];
        popupVC.str_dis1on = [[nsarray_data valueForKey:@"dis1on"] objectAtIndex:sender.tag];
        popupVC.str_dis2on = [[nsarray_data valueForKey:@"dis2on"] objectAtIndex:sender.tag];
        popupVC.str_itemwt = [[nsarray_data valueForKey:@"itemwt"] objectAtIndex:sender.tag];
        popupVC.str_lbr24k = [[nsarray_data valueForKey:@"lbr24k"] objectAtIndex:sender.tag];
        popupVC.str_othamt = [[nsarray_data valueForKey:@"othamt"] objectAtIndex:sender.tag];
        popupVC.str_spolish = [[nsarray_data valueForKey:@"spolish"] objectAtIndex:sender.tag];
        popupVC.str_24karat = [[nsarray_data valueForKey:@"24krate"] objectAtIndex:sender.tag];
        popupVC.str_polishwt = [[nsarray_data valueForKey:@"polishwt"] objectAtIndex:sender.tag];
        popupVC.str_remarks1 = [[nsarray_data valueForKey:@"remarks1"] objectAtIndex:sender.tag];
        popupVC.str_polishper = [[nsarray_data valueForKey:@"polishper"] objectAtIndex:sender.tag];
        popupVC.str_cartid = [[nsarray_data valueForKey:@"cart_id"] objectAtIndex:sender.tag];
        popupVC.dicData = [nsarray_data objectAtIndex:sender.tag];
        popupVC.completionHandler = ^(NSString *amount,NSString *wt, NSString *text2,NSString *btnaction) {
            if ([btnaction isEqualToString:@"Cancel"]) {
                [self cancelButtonPressed];
            }else if ([btnaction isEqualToString:@"Save"]) {
                [self ItemAPI];
            }
        };
        popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:popupVC animated:YES completion:nil];
    }
}

#pragma mark - View Button Action Methods

- (IBAction)radioButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (btn_Manual == sender){
        btn_Automation.selected = false;
    }else if (btn_Automation == sender){
        btn_Manual.selected = false;
    }
}

- (IBAction)btn_search:(id)sender{
    if ([visid isEqualToString:@"0"] || visid.length == 0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"Please select customer" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSString *str_tag = txt_tagno.text;
        if (str_tag.length !=0) {
            [self scrollData_InsertItemTag];
        }
    }
}

- (IBAction)btn_clear:(id)sender {
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want clear" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK"
    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self URL_CLEAR_CART:@""];
    }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action)
                               {}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
//Place data order
- (IBAction)btn_placeorder:(id)sender {
    [self showInputAlert];
}

- (void)showInputAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Remark"
                                                                   message:@"Please enter remark"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    // Add a text field to the alert
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Remark";
    }];
    
    // Add Cancel button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    // Add OK button with handler
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *inputText = textField.text;
        NSLog(@"User entered: %@", inputText);

        // Optionally show another alert with the input
        if (inputText.length > 0){
            [self scrollData_pleaceord:inputText];
        }else{
            [self scrollData_pleaceord:@""];
            //[self showConfirmationWithInput:inputText];
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// Optional: Show confirmation alert
- (void)showConfirmationWithInput:(NSString *)input {
    UIAlertController *confirmation = [UIAlertController alertControllerWithTitle:@"Please Entered Remark"
                                                                          message:input
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
        [self showInputAlert];
    }];
    [confirmation addAction:ok];
    [self presentViewController:confirmation animated:YES completion:nil];
}

#pragma mark - Place order API Methods

-(void)scrollData_pleaceord:(NSString *) remarks{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSLog(@"str_cpid Value = %@",str_cpid);
    str_cpid = (str_cpid.length > 0) ? str_cpid : @"";
    NSLog(@"str_cpid Value = %@",str_cpid);
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&visid=%@&cpid=%@&remarks=%@",ECAT_TYPE_NEW,apptype,ip,db,ipusername,pswd,ftppath,visid,str_cpid,remarks];
        
        URL_API = [WEB_URL URL_UPDATE_VISITQR];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/update_visitqr.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&ftppath=%@&visid=%@&cpid=%@&remarks=%@",ECAT_TYPE_NEW,apptype,ftppath,visid,str_cpid,remarks];
    }else{
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&visid=%@&cpid=%@&remarks=%@",ECAT_TYPE_NEW,apptype,visid,str_cpid,remarks];
        URL_API = [WEB_URL URL_UPDATE_VISITQR];
    }
    
    NSLog(@"URL_API ***************** %@",URL_API);
    NSLog(@"loginRequest ***************** %@",loginRequest);

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
                [self parseResponse_placeorder:data];
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


- (void)parseResponse_placeorder:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
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
            NSMutableArray *arrayResponse_orderno = [pDict objectForKey:@"orderno"];
            NSString *str_orderno = [arrayResponse_orderno description];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
    
            if ([str_success isEqualToString:@"1"]){
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:str_msg  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action){
                    [self alertPdfWithOrderno:str_orderno];
                    [self ItemAPI];
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:str_msg  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action){}];
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


-(void)scrollData_InsertItemTag {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
//    NSString *mobile = lbl_mobile.text;
    NSString *tgno = txt_tagno.text;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;


    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,tgno,mobile,visid,ip,db,ipusername,pswd,ftppath];

        URL_API = [WEB_URL URL_INSERT_ITEMTAG];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_itemtag.php",ip];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,tgno,mobile,visid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@",ECAT_TYPE_NEW,apptype,tgno,mobile,visid];
        URL_API = [WEB_URL URL_INSERT_ITEMTAG];
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
                [self parseResponse_Save:data];
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

- (void)parseResponse_Save:(NSData *) data {
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
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
    
            if ([str_success isEqualToString:@"1"])
            {
                txt_tagno.text = @"";
                [self ItemAPI];
            }else
            {
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
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
            NSMutableArray *nsarray_cpid = [pDict objectForKey:@"cpid"];
            str_cpid = [nsarray_cpid description];
            
            if (![str_cpid isEqualToString:@"0"])
            {
                NSMutableArray *nsarray_visid = [pDict objectForKey:@"visid"];
                NSString * str_visid = [nsarray_visid description];
                self->lbl_name.text = str_pname;
                self->lbl_mobile.text = str_contact;
                self->cpid = str_cpid;
                self->visid = str_visid;
            }
            [self ItemAPI];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_CLEAR_CART:(NSString *)str_cartid {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];

    NSString *activity=@"product";
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
//    NSString *visid=@"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,userid,apptype,rlid,activity,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_CLEARCART];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/clear_cart.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@&ftppath=%@",mobile,userid,apptype,rlid,activity,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@",mobile,userid,apptype,rlid,activity];
        URL_API =[WEB_URL URL_CLEARCART];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_ClearCart:data];
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


- (void)parse_ClearCart:(NSData *) data {
    @try {
        
        ////////////// End processs load view
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
            
                [self ItemAPI];
                self->lbl_pc.text = @"0";
                self->lbl_Gwt.text = @"0.00";
                self->lbl_wt.text = @"0.00";
                self->lbl_Fine.text = @"0.00";
                self->lbl_mrp.text = @"0.00";
                
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                    //                    MMIHOMEPanel *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                    //                    [self.navigationController pushViewController:obj animated:YES];
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                
              
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
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

-(void)URL_SINGLE_ITEM_DELETE:(NSString *)cart_id {
    
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
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,cart_id,apptype,ip,db,ipusername,pswd,ftppath];
        
        URL_API = [WEB_URL URL_DELETE];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_single_item.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ftppath=%@",mobile,cart_id,apptype,ftppath];

    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@",mobile,cart_id,apptype];
        URL_API =[WEB_URL URL_DELETE];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SINGLE_ITEM:data];
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


- (void)parse_SINGLE_ITEM:(NSData *) data {
    @try {
        
        ////////////// End processs load view
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
            
                [self ItemAPI];
              
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
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

#pragma mark - Pdf Api Methods

- (void)alertPdfWithOrderno:(NSString *)orderno{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want share pdf?"  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action){
        [self getPdfWithOrderno:orderno type:@"1" pdftype:@"get_pdf10.php"];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action){
    }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)getPdfWithOrderno:(NSString *)orderno type:(NSString *)type pdftype:(NSString *)pdftype {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
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
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,type,orderno,ip,db,ipusername,pswd,ftppath];
        
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"%@%@",ip, pdftype];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ftppath=%@",apptype,type,orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@",apptype,type,orderno];
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
    }
    
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    NSLog(@"URL_API ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
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
                [self parseResponse_pdf:data];
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

- (void)parseResponse_pdf:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
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
                NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
                NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
                NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
                
                NSMutableArray*nsarray_pdf = [pDict objectForKey:@"pdf"];
                NSString *pdf = [nsarray_pdf description];
                
                NSString *str_url;
                if ([ECAT_TYPE isEqualToString:@"1"] || [ECAT_TYPE isEqualToString:@"3"]) {
                    NSLog(@"mainUrl ****************** %@",mainUrl);
                    str_url = [NSString stringWithFormat:@"%@pdf/%@", mainUrl, pdf];
                    NSLog(@"str_url ****************** %@",str_url);
                    
                    NSURL *url = [NSURL URLWithString:str_url];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        NSLog(@"Cannot open URL");
                    }
                    //                    WebActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                    //                    obj.str_type = @"PDf";
                    //                    obj.str_url = str_url;
                    //                    [self.navigationController pushViewController:obj animated:YES];
                } else {
                    str_url = [NSString stringWithFormat:@"http://%@/jwellyecat/pdf/%@", ip, pdf];
                }
                // Start file download
                //                [self downloadAndShareFileWithURL:str_url fileName:pdf];
            }else{
                [self alertMsg:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


@end
