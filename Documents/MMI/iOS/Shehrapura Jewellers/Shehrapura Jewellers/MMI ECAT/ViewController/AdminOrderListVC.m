//
//  AdminOrderListVC.m
//  Swiz Gold and Diamonds
//
//  Created by MMI Softwares Pvt Ltd on 21/05/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AdminOrderListVC.h"
#import "OrderDetail.h"

#pragma mark - Custom OrderDetails UITableViewCell

@interface AdminOrderTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblOrderNo;
@property (nonatomic, strong) IBOutlet UILabel *lblWt;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIButton *btnCall;
@property (nonatomic, strong) IBOutlet UIButton *btnComplete;
@property (nonatomic, strong) IBOutlet UIButton *btnDetail;

@end

@implementation AdminOrderTblCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

@interface AdminOrderListVC ()
{
    NSArray *arrayTblFilterList;
    UIAlertController *filterAlertView;
}
@end

@implementation AdminOrderListVC

#pragma mark: - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Order List";
    
    arrayTblOrderList =[[NSMutableArray alloc]init];
    arrayMasterPendingOrderList =[[NSMutableArray alloc]init];
    arrayMasterAllOrderList =[[NSMutableArray alloc]init];
    arrayTblFilterList = @[@"ALL", @"Pending", @"In Progress", @" Complete", @"Deliverd", @"Reject"];
    [self setUpNavigationButton];
    [self api_ListDataCategory:@"Pending"];
}

- (void)setUpNavigationButton {
    UIButton * btn_Delete =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Delete.frame = CGRectMake(0,5,30,30);
    
    UIImage *image = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn_Delete setImage: image forState:UIControlStateNormal];
    [[btn_Delete imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Delete.tintColor = [UIColor whiteColor];
    [btn_Delete addTarget:self action:@selector(deleteNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barDeleteBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Delete];
    barDeleteBtn.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barDeleteBtn, nil];
}

- (void)filterNavigationButtonAction:(UIButton *) sender {
    [self alertFilterList];
}

- (void)deleteNavigationButtonAction:(UIButton *) sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message: @"Do you want Delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self api_DeleteData];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){}];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) alertFilterList {
    filterAlertView = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Select Item");
    }];
    UIViewController *controller_item = [[UIViewController alloc]init];
    CGRect rect;
    rect = CGRectMake(0, 0, 280, 7*45);
    [controller_item setPreferredContentSize:rect.size];
    UITableView *table_item = [[UITableView alloc]initWithFrame:rect];
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
    [filterAlertView setValue:controller_item forKey:@"contentViewController"];
    
    [filterAlertView addAction:cancelAction];
    [self presentViewController:filterAlertView animated:YES completion:nil];
}

#pragma mark - Table View Datasource and Delegates Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView){
        return [arrayTblOrderList count];
    }else{
        return [arrayTblFilterList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView){
        AdminOrderTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminOrderTblCell" forIndexPath:indexPath];
        cell.lblName.text = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"username"] objectAtIndex:indexPath.row]];
        cell.lblOrderNo.text = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"orderno"] objectAtIndex:indexPath.row]];
        cell.lblWt.text = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"totalwt"] objectAtIndex:indexPath.row]];
        cell.lblDate.text = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"item_date"] objectAtIndex:indexPath.row]];
        cell.btnCall.tag = indexPath.row;
        cell.btnComplete.tag = indexPath.row;
        cell.btnDetail.tag = indexPath.row;
        cell.subView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.subView.layer.borderWidth = 1;
        [cell.btnCall addTarget:self action:@selector(tblCellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComplete addTarget:self action:@selector(tblCompleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDetail addTarget:self action:@selector(tblDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnComplete.hidden = false;
        cell.btnDetail.hidden = false;
        if(self.btnAll.selected){
            cell.btnComplete.hidden = true;
            cell.btnDetail.hidden = true;
        }
        return cell;
    }else{
        static NSString *myIdentifier = @"MyIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        cell.textLabel.text = [arrayTblFilterList objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView){
        OrderDetail *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetail"];
        obj.str_orderno = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"orderno"] objectAtIndex:indexPath.row]];
        obj.str_odate = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"item_date"] objectAtIndex:indexPath.row]];
        obj.str_wt = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"totalwt"] objectAtIndex:indexPath.row]];
        obj.str_qty = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"qty"] objectAtIndex:indexPath.row]];
        obj.str_username = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"username"] objectAtIndex:indexPath.row]];
        obj.str_mobile = [NSString stringWithFormat:@"%@", [[arrayTblOrderList valueForKey:@"mobile"] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        //Filter
        [filterAlertView dismissViewControllerAnimated:YES completion:nil];
        NSString *strTitle = [arrayTblFilterList objectAtIndex:indexPath.row];
        [self api_ListDataCategory: strTitle];
    }
}

- (void)tblCellButtonAction:(UIButton *)sender {
    NSString *phoneNumber = [[arrayTblFilterList valueForKey:@"mobile"]  objectAtIndex: sender.tag];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self phoneCallMethod:phoneNumber];
}

- (void)tblCompleteButtonAction:(UIButton *)sender {
    NSString *strOrderNo = [[arrayTblOrderList valueForKey:@"orderno"] objectAtIndex: sender.tag];
    NSString *strTitle = [NSString stringWithFormat:@"Do you want complete %@", strOrderNo];
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message: strTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self api_ListCompleteOrder:strOrderNo];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){}];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tblDetailButtonAction:(UIButton *)sender {
    
}

#pragma mark: - IBAction Method

- (IBAction)btnPendingAction:(UIButton *)sender {
    self.btnPending.selected = true;
    self.btnAll.selected = false;
    if (arrayMasterPendingOrderList.count > 0){
        arrayTblOrderList = arrayMasterPendingOrderList;
    }else{
        [self api_ListDataCategory:@"Pending"];
    }
    [self setUpButton];
}

- (IBAction)btnAllAction:(UIButton *)sender {
    self.btnAll.selected = true;
    self.btnPending.selected = false;
    if (arrayMasterAllOrderList.count > 0){
        arrayTblOrderList = arrayMasterAllOrderList;
    }else{
        [self api_ListDataCategory:@"ALL"];
    }
    [self setUpButton];
}

-(void)setUpButton{
    if(self.btnAll.selected){
        [self.btnAll setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
        [self.btnPending setBackgroundColor: [UIColor lightGrayColor]];
    }else{
        [self.btnPending setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
        [self.btnAll setBackgroundColor: [UIColor lightGrayColor]];
    }
    [self.tableView reloadData];
}

#pragma mark: - Api call Method

-(void)api_ListDataCategory:(NSString *)strListType {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    if (userid == nil || [userid length] == 0) {
        userid = @"0";
    }
    mobile = @"";
    
    NSString *pending = strListType; //@"Pending";

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,pending,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_SHOW_ORDER];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno.php",ip];
       
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,pending,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@",apptype,category,mobile,userid,rlid,pending];
        
        URL_API =[WEB_URL URL_SHOW_ORDER];
    }
    
    NSLog(@"loginRequest orderlist ******************************* %@",loginRequest);
    NSLog(@"URL_API orderlist ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
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
                [self parseResponseData:data listType:strListType];
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


- (void) parseResponseData:(NSData *) data listType:(NSString *)strListType {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            arrayTblOrderList = [[pDict objectForKey:@"ordernolist"] mutableCopy];
            if ([strListType isEqualToString:@"all"]){
                arrayMasterAllOrderList = [arrayTblOrderList mutableCopy];
            }else{
                arrayMasterPendingOrderList = [arrayTblOrderList mutableCopy];
            }
            [self.tableView reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)api_ListCompleteOrder:(NSString *)orderno {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    if (userid == nil || [userid length] == 0) {
        userid = @"0";
    }
    mobile = @"";
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,orderno,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_SHOW_ORDER_COMPLETE];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno.php",ip];
       
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&orderno=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,orderno,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&orderno=%@",apptype,category,mobile,userid,rlid,orderno];
        
        URL_API =[WEB_URL URL_SHOW_ORDER_COMPLETE];
    }
    
    NSLog(@"loginRequest orderlist ******************************* %@",loginRequest);
    NSLog(@"URL_API orderlist ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
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
                [self parseResponseCompleteOrderData:data];
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


- (void) parseResponseCompleteOrderData:(NSData *) data{
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSLog(@"Complete Resoponse data = %@", pDict);
            int success = [[pDict valueForKey:@"success"] intValue];
            NSString *msg = [pDict valueForKey:@"message"];
            [self alertMsg:msg];
            if (success == 1) {
                [self api_ListDataCategory:@"Pending"];
            }else{
                
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)api_DeleteData{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    if (userid == nil || [userid length] == 0) {
        userid = @"0";
    }
    mobile = @"";

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_SHOW_ORDERD_DELETE];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno.php",ip];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@",apptype,category,mobile];
        URL_API =[WEB_URL URL_SHOW_ORDERD_DELETE];
    }
    
    NSLog(@"loginRequest orderlist ******************************* %@",loginRequest);
    NSLog(@"URL_API orderlist ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
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
                [self parseResponseDeleteData:data];
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

- (void) parseResponseDeleteData:(NSData *) data{
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSLog(@"Delete Resoponse data = %@", pDict);
            int success = [[pDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self api_ListDataCategory:@"Pending"];
            }else{
                NSString *msg = [pDict valueForKey:@"message"];
                [self alertMsg:msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
@end
