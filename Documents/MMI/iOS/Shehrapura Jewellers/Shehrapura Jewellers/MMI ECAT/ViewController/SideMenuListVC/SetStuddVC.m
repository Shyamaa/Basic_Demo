//
//  SetStuddVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "SetStuddVC.h"
#import "SWRevealViewController.h"

@interface SetStuddVCTablCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblField;
@property (nonatomic, strong) IBOutlet UITextField *txtItem;
@property (nonatomic, strong) IBOutlet UITextField *txtSrNo;
@property (nonatomic, strong) IBOutlet UITextField *txtWidth;

@end

@implementation SetStuddVCTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

@interface SetStuddVC()
{}
@end

@implementation SetStuddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Set Studd";
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

#pragma mark:- Button Action Method

- (IBAction)btnSaveAction:(UIButton *)sender{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < tblListData.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            SetStuddVCTablCell *cell = [tblview cellForRowAtIndexPath:indexPath];
            if (cell) {
                NSString *strdata = [NSString stringWithFormat:@"%@, %@, %@, %@", cell.lblField.text ?: @"", cell.txtItem.text ?: @"", cell.txtSrNo.text ?: @"", cell.txtWidth.text ?: @""];
                [resultArray addObject:strdata];
            }
        }
    NSLog(@"Collected Data: %@", resultArray);
    NSString *strListData = [resultArray componentsJoinedByString:@" : "];
    NSLog(@"%@", strListData);
    [self insertStuddData: strListData];
}

#pragma mark:- UITableView Delegate and DataSource  Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tblListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetStuddVCTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetStuddVCTablCell" forIndexPath:indexPath];
    cell.lblField.text = [[tblListData valueForKey:@"fieldname"] objectAtIndex:indexPath.row];
    cell.txtItem.text = [[tblListData valueForKey:@"caption"] objectAtIndex:indexPath.row];
    cell.txtSrNo.text = [[tblListData valueForKey:@"srno"] objectAtIndex:indexPath.row];
    cell.txtWidth.text = [[tblListData valueForKey:@"width"] objectAtIndex:indexPath.row];
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,@"9627746628",ip,db,ipusername,pswd,ftppath];

        URL_API =[WEB_URL URL_GetSTUDDList];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_studd.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];

    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API =[WEB_URL URL_GetSTUDDList];
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
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray * rensarray_data =[[NSMutableArray alloc]init];
            rensarray_data = [pDict objectForKey:@"data"];
            tblListData = [rensarray_data mutableCopy];
            NSLog(@"nsarray_data :: %@",rensarray_data);
            [tblview reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)insertStuddData:(NSString *) strlistData {
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&studdparam=%@",apptype,ip,db,ipusername,pswd,ftppath,strlistData];

        URL_API =[WEB_URL URL_Insert_Studd];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_studd.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&studdparam=%@",apptype,ftppath,strlistData];

    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&studdparam=%@",apptype,strlistData];
        URL_API =[WEB_URL URL_Insert_Studd];
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
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSString *success = jsonDict[@"success"];
            NSString *message = @"Successfully Updated.";;//jsonDict[@"message"];
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

