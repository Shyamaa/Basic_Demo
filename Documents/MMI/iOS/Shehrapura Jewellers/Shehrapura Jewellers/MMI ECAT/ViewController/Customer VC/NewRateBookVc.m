//
//  NewRateBookVc.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "NewRateBookVc.h"
#import "NewRateBookDetailVc.h"
#import "KittyDetailsVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "CustomerInfoVc.h"

#pragma mark - Custom NewRateBook UITableViewCell

@interface NewRateBook : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblKNo;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblRec;
@property (nonatomic, strong) IBOutlet UILabel *lblBalance;
@property (nonatomic, strong) IBOutlet UILabel *lblDue;

@end

@implementation NewRateBook

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

#pragma mark - UserListActivity

@interface NewRateBookVc ()

@end

@implementation NewRateBookVc

@synthesize str_ktype,str_mobile,str_groupid,str_activity;

#pragma mark: - Class Method

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"New Rate Book";
    [self setUpNavigationButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getItemListApi:@"No"];
}

- (void)setUpNavigationButton {
    UIButton *button_Short =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button_Short setFrame:CGRectMake(0, 0, 35, 35)];
    [button_Short setImage:[UIImage imageNamed:@"short"] forState:UIControlStateNormal];
    [[button_Short imageView] setContentMode: UIViewContentModeScaleAspectFit];
    button_Short.tintColor = [UIColor whiteColor];
    [button_Short addTarget:self action:@selector(shortNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barShortBtn = [[UIBarButtonItem alloc] initWithCustomView:button_Short];
    
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,8,35,35);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,8,35,35);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(shareNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barShortBtn, space, barFilterBtn, space, barSearchBtn, nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)dateChanged:(UIDatePicker *)sender {
    // Customizing the date format based on the active text field
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (self.txtStartDate.isFirstResponder) {
        formatter.dateFormat = @"dd-MM-yyyy";
        self.txtStartDate.text = [formatter stringFromDate:sender.date];
    } else if (self.txtEndDate.isFirstResponder) {
        formatter.dateFormat = @"MMM d, yyyy";
        self.txtEndDate.text = [formatter stringFromDate:sender.date];
    }
}

#pragma mark - Navigation Button Action Methods

- (void)shortNavigationButtonAction:(UIButton *) sender  {
    sender.selected = !sender.selected;
    if (sender.selected){
        [arraytblListData sortUsingDescriptors:@[
            [NSSortDescriptor sortDescriptorWithKey:@"cname" ascending:YES]
        ]];
    }else{
        [arraytblListData sortUsingDescriptors:@[
            [NSSortDescriptor sortDescriptorWithKey:@"kmno" ascending:YES]
        ]];
    }
    [self.tableView reloadData];
}

- (void)filterNavigationButtonAction {
    //    if ([arrayListData count] > 0){
    //        [self setUpFilterView];
    //    }
    [self setBlankFilterview];
    [self.filterView setHidden : NO];
}

- (void)shareNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.searchBar setHidden:false];
    }else{
        [self.searchBar setHidden:true];
        [self.searchBar resignFirstResponder];
    }
}

-(void)setUpFilterView{
    [self setupDatePickerForTextField:self.txtStartDate];
    [self setupDatePickerForTextField:self.txtEndDate];
    
    //    NSArray *namePickerData = [arrayListData valueForKeyPath:@"cname"];
    
    NSArray *kNoPickerData = [[arrayListData valueForKey:@"kmno"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@", [NSNull null]]];
    NSArray *uniqueKnoArray = [[NSSet setWithArray:kNoPickerData] allObjects];
    
    NSArray *mobilePickerData = [[arrayListData valueForKey:@"mobile"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@", [NSNull null]]];
    NSArray *uniqueMobileArray = [[NSSet setWithArray:mobilePickerData] allObjects];
    
    NSArray *namePickerData = [[arrayListData valueForKey:@"cname"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@", [NSNull null]]];
    NSArray *uniqueNameArray = [[NSSet setWithArray:namePickerData] allObjects];
    
    // Add the picker with search functionality to the text field
    [self.txtKNo addPickerWithData:uniqueKnoArray searchEnabled:NO];
    [self.txtMobile addPickerWithData:uniqueMobileArray searchEnabled:NO];
    [self.txtName addPickerWithData:uniqueNameArray searchEnabled:NO];
}

-(void)setBlankFilterview{
    self.txtKNo.text = @"";
    self.txtMobile.text = @"";
    self.txtName.text = @"";
    self.txtStartDate.text = @"";
    self.txtEndDate.text = @"";
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        arraytblListData = arrayListData;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"cname"] lowercaseString];
            NSString *mobile = [item[@"mobile"] lowercaseString];
            NSString *userId = [item[@"kmno"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            
            return ([name containsString:searchLower] ||
                    [mobile containsString:searchLower] ||
                    [userId containsString:searchLower]);
        }];
        arraytblListData = [[arrayListData filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    // });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [arraytblListData removeAllObjects];
    arraytblListData = arrayListData;
    [self.tableView reloadData];
}


#pragma mark: - UITableViewDelegate,UITableViewDataSource Methods

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [arraytblListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewRateBook *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRateBook" forIndexPath:indexPath];
    NSString *strName = [[arraytblListData valueForKey:@"cname"] objectAtIndex:indexPath.row];
    NSString *strPhone = [[arraytblListData valueForKey:@"mobile"] objectAtIndex:indexPath.row];
    
    cell.lblKNo.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"kmno"] objectAtIndex:indexPath.row]];
    if ([str_activity isEqualToString:@"Kitty Customer"]) {
        cell.lblName.text = [NSString stringWithFormat:@"%@\n%@", strName, strPhone];
    }else{
        cell.lblName.text = [NSString stringWithFormat:@"%@", strName];
    }
    cell.lblRec.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"trec"] objectAtIndex:indexPath.row]];
    cell.lblBalance.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"tamt"] objectAtIndex:indexPath.row]];
    cell.lblDue.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"months"] objectAtIndex:indexPath.row]];
    
    NSString *type = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"ktype"] objectAtIndex:indexPath.row]];
    
    if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"] || [type isEqualToString:@"5"]){
        [cell.subView setBackgroundColor:[UIColor greenColor]];
    }else{
        [cell.subView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"ktype"] objectAtIndex:indexPath.row]];
    if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"] || [type isEqualToString:@"5"]){
        KittyDetailsVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"KittyDetailsVC"];
        obj.strId = [[arraytblListData valueForKey:@"ktid"] objectAtIndex:indexPath.row];
        obj.strStampid = [[arraytblListData valueForKey:@"stampid"] objectAtIndex:indexPath.row];
        obj.strKittyType = self.strKittyType;
        obj.selectData = [arraytblListData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        NewRateBookDetailVc *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRateBookDetailVc"];
        obj.kittId = [[arraytblListData valueForKey:@"ktid"] objectAtIndex:indexPath.row];
        obj.strKittyType = self.strKittyType;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

#pragma mark:- IBAction Button Method

-(IBAction)addButtonAction:(id)sender{
    CustomerInfoVc *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoVc"];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)fiterButtonAction:(UIButton *)sender{
    if (sender.tag == 44) {
        [self.filterView setHidden:YES];
    }else{
        //filter data
        if (self.txtKNo.text.length == 0 && self.txtMobile.text.length == 0 && self.txtName.text.length == 0 && self.txtStartDate.text.length == 0 && self.txtEndDate.text == 0){
            [self alertMsg: @"Please select atleast one field from Kno/Mobile/Name"];
        }else{
            [self getItemListApi:@"YES"];
            [self.filterView setHidden:YES];
        }
    }
}

#pragma mark:- Api Method


-(void)getItemListApi:(NSString *)isFilter {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [self getAPIWithApiName:[WEB_URL URL_GET_KittyallList]
                       type:isFilter
                 completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@" Item Response: %@", response);
            self->arraytblListData = [[NSMutableArray alloc]init];
            self->arrayListData = [[NSMutableArray alloc]init];
            self->arrayListData = [response objectForKey:@"custlist"];
            self->arraytblListData = [[response objectForKey:@"custlist"] mutableCopy];
            NSLog(@"feeditem %@",self->arraytblListData);
        }
        [[BusyIndicator sharedInstance] stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            // ✅ Safe UI updates here
            [self.tableView reloadData];
            if ([isFilter isEqualToString:@"No"]){
                [self setUpFilterView];
            }
        });
    }];
}

- (void)getAPIWithApiName:(NSString *)apiName
                     type:filter
               completion:(void (^)(NSDictionary *response, NSError *error))completion {
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *cMobile = ([filter isEqualToString:@"YES"]) ? self.txtMobile.text : str_mobile;
    NSString *cName = self.txtName.text;
    NSString *cKno = self.txtKNo.text;
    NSString *cFromDate = self.txtStartDate.text;
    NSString *cEndDate = self.txtEndDate.text;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&kittyip=%@&kittydb=%@&kittyuser=%@&kittypswd=%@&ftppath=%@&mobile=%@&groupid=%@&kmno=%@&cname=%@&frmdate=%@&todate=%@&filter=%@",apptype,ip,db,ipusername,pswd,ftppath,cMobile,@"0",cKno,cName,cFromDate,cEndDate,filter];
        URL_API = apiName;
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/feeditem.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&type=%@",apptype,ftppath,@""];
    }else{
        //loginRequest = [NSString stringWithFormat:@"apptype=%@&type=%@&kmno=%@=mobile=%@&cname=%@&frmdate=%@&todate=%@&filter=%@",apptype,@"",cKno,cMobile,cName,cFromDate,cEndDate,filter];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&kmno=%@&mobile=%@&cname=%@&frmdate=%@&todate=%@&filter=%@",apptype,cKno,cMobile,cName,cFromDate,cEndDate,filter];
        URL_API = apiName;
    }
    
    NSLog(@"Filter Param = %@", loginRequest);
    NSLog(@"Filter Api Name = %@", URL_API);
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
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                NSError *jsonError;
            //                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            //
            //            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            completion(nil, error);
            
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            completion(nil, error);
        }
    }] resume];
    // Create a data task to handle the request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                completion(jsonResponse, nil);
            }
        }
    }];
    // Start the request
    [dataTask resume];
}

@end
