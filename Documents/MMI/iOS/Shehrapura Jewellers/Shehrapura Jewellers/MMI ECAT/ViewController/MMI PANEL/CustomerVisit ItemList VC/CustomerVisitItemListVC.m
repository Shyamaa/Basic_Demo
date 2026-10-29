//
//  CustomerVisitItemListVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CustomerVisitItemListVC.h"

#pragma mark - Custom UITableViewCell

@interface ItemListTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblItemName;
@property (nonatomic, strong) IBOutlet UIButton *btnCheck;

@end

@implementation ItemListTblCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end


#pragma mark: Classs

@interface CustomerVisitItemListVC ()
@end

@implementation CustomerVisitItemListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblMasterItemListData = [[NSMutableArray alloc] init];
    tblItemListData = [[NSMutableArray alloc] init];
    selectedItemListData = [[NSMutableArray alloc] init];
    //[self apiListData];
    if ([_str_page_type isEqualToString:@"Approval"]) {
        tblMasterItemListData = self.listData;
        tblItemListData = self.listData;
        [self.tableView reloadData];
    } else {
        [self listDataApi];
    }
}

#pragma mark:- Button Action Method

- (IBAction)okButtonAction:(id)sender{
        if ([selectedItemListData count] > 0){
            if ([_str_page_type isEqualToString:@"Approval"]) {
                if (self.completionHandler) {
                    self.completionHandler(self->selectedItemListData);
                }
                [self cancelButtonAction:sender];
            }else{
                [self saveDataApi];
            }
        }
}

- (IBAction)cancelButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        tblItemListData = tblMasterItemListData;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"idesc"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            return ([name containsString:searchLower]);
        }];
        tblItemListData = [[tblMasterItemListData filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
   // });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [tblItemListData removeAllObjects];
    tblItemListData = tblMasterItemListData;
    [self.tableView reloadData];
}

#pragma mark: - TableView Delegate and Datasouce Method

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return [tblItemListData count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    ItemListTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemListTblCell" forIndexPath:indexPath];
    
    cell.subView.layer.cornerRadius = 10;
    cell.subView.layer.borderWidth = 1;
    cell.subView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    cell.btnCheck.tag = indexPath.row;
    [cell.btnCheck addTarget:self action:@selector(btnRowCheck:) forControlEvents: UIControlEventTouchUpInside];
    cell.btnCheck.selected = NO;
    
    if ([_str_page_type isEqualToString:@"Approval"]) {
        cell.lblItemName.text = [tblItemListData objectAtIndex:indexPath.row];
        for (NSString *item in [selectedItemListData copy]) {
            if ([item isEqualToString: cell.lblItemName.text]){
                cell.btnCheck.selected = YES;
                break; // remove first match only
            }
        }
    }else{
        cell.lblItemName.text = [[tblItemListData valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        NSString *item_Id = [[tblItemListData valueForKey:@"ino"] objectAtIndex:indexPath.row];
        for (NSDictionary *item in [selectedItemListData copy]) {
            if ([item[@"ino"] isEqualToString: item_Id]){
                cell.btnCheck.selected = YES;
                break; // remove first match only
            }
        }
    }
    return cell;
}

-(void)btnRowCheck:(UIButton *)sender{
    sender.selected = !sender.selected;
    BOOL found = NO;
    if ([_str_page_type isEqualToString:@"Approval"]) {
        NSString *obj = [tblItemListData objectAtIndex: sender.tag];
        for (NSString *item in [selectedItemListData copy]) {
            if ([item isEqualToString: obj]){
                [selectedItemListData removeObject:item];
                found = YES;
                break; // remove first match only
            }
        }
        if (!found) {
            [selectedItemListData addObject:obj];
        }
    }else{
        NSString *item_Id = [[tblItemListData valueForKey:@"ino"] objectAtIndex: sender.tag];
        NSDictionary *obj = [tblItemListData objectAtIndex: sender.tag];
        for (NSDictionary *item in [selectedItemListData copy]) {
            if ([item[@"ino"] isEqualToString: item_Id]){
                [selectedItemListData removeObject:item];
                found = YES;
                break; // remove first match only
            }
        }
        if (!found) {
            [selectedItemListData addObject:obj];
        }
    }
    NSLog(@"selected ItemList Data: %@", selectedItemListData);
}

#pragma mark:- Api Method

-(void)apiListData{
    if ([_str_cpid isEqualToString:@""]){
        return;
    }
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];

    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *dbname = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSDictionary *params = @{
        @"mobile"     : mobile,
        @"smacno"     : smacno,
        @"apptype"    : apptype,
        @"ip"         : ip,
        @"dbname"     : dbname,
        @"ipusername" : ipusername,
        @"password"   : pswd,
        @"ftppath"    : ftppath,
        @"cpid"       : _str_cpid
    };
    
    NSLog(@"params: %@", params);
    NSLog(@"api: %@", [WEB_URL URL_GET_VISITITEM]);
    [[APIManager sharedManager] POST: [WEB_URL URL_GET_VISITITEM]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"List Response: %@", data);
            NSString *success = [data objectForKey:@"itemlist"];
            NSLog(@"Successfully = %@",success);
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.txtCity addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

-(void)apiInsertData{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSMutableArray *idStrings = [NSMutableArray array];

    for (NSDictionary *item in selectedItemListData) {
        [idStrings addObject:[item[@"ino"] stringValue]];
    }
    NSString *str_Ids = [idStrings componentsJoinedByString:@","];
    NSLog(@"inos: %@", str_Ids);
    
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *dbname = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSDictionary *params1 = @{
        @"apptype"    : apptype,
        @"ip"         : ip,
        @"ipusername" : ipusername,
        @"password"   : pswd,
        @"dbname"     : dbname,
        @"ftppath"    : ftppath,
        @"smacno"     : smacno,
        
        @"disptags"     : @"0",
        @"ino"     : str_Ids,
        @"visid"     : _str_visid,
    };
    
    NSDictionary *params2 = @{
        @"apptype"    : apptype,
        @"ftppath"    : ftppath,
        @"smacno"     : smacno,
        @"disptags"     : @"0",
        @"ino"     : str_Ids,
        @"visid"     : _str_visid,
    };
    
    NSLog(@"params: %@", params1);
    NSLog(@"params: %@", params2);
    NSDictionary *params = [apptype isEqualToString:@"1"] ? params1 : params2;
    
    NSLog(@"params: %@", params);
    NSLog(@"api: %@", [WEB_URL URL_INSERT_CPVDET]);
    [[APIManager sharedManager] POST: [WEB_URL URL_INSERT_CPVDET]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Insert Response: %@", data);
            NSString *success = [data objectForKey:@"success"];
            NSLog(@"Successfully = %@",success);
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.txtCity addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

-(void)listDataApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;

    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&mobile=%@&cpid=%@&smacno=%@",apptype,ip,db,ipusername,pswd,ftppath,mobile,_str_cpid,smacno];
        URL_API = [WEB_URL URL_GET_VISITITEM];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/update_cartitem.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&mobile=%@&cpid=%@&smacno=%@",apptype,ftppath,mobile,_str_cpid,smacno];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&cpid=%@&smacno=%@",apptype,mobile,_str_cpid,smacno];
        URL_API = [WEB_URL URL_GET_VISITITEM];
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
            tblMasterItemListData = [[pDict objectForKey:@"itemlist"] mutableCopy];
            tblItemListData = [tblMasterItemListData mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)saveDataApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSMutableArray *idStrings = [NSMutableArray array];

    for (NSDictionary *item in selectedItemListData) {
        [idStrings addObject:[item[@"ino"] stringValue]];
    }
    NSString *str_Ids = [idStrings componentsJoinedByString:@","];
    NSLog(@"inos: %@", str_Ids);
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;

    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&disptags=%@&visid=%@&smacno=%@&ino=%@",apptype,ip,db,ipusername,pswd,ftppath,@"0",_str_visid,smacno,str_Ids];
        URL_API = [WEB_URL URL_INSERT_CPVDET];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/update_cartitem.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&disptags=%@&visid=%@&smacno=%@&ino=%@",apptype,ftppath,@"0",_str_visid,smacno,str_Ids];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&disptags=%@&visid=%@&smacno=%@&ino=%@",apptype,@"0",_str_visid,smacno,str_Ids];
        URL_API = [WEB_URL URL_INSERT_CPVDET];
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
                [self parseResponseSaveData:data];
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

- (void)parseResponseSaveData:(NSData *) data {
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
            NSString *success = [pDict objectForKey:@"success"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completionHandler) {
                    self.completionHandler(self->selectedItemListData);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
