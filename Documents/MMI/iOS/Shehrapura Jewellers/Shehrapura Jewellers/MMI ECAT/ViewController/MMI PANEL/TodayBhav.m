//
//  TodayBhav.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 19/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "TodayBhav.h"

@interface TodayBhav ()

@end

@implementation TodayBhav

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Today Bhav";
    [self scrollData_item];
}

#pragma mark:- Api Method

-(void)scrollData_item {
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_GET_TODAYBHAV];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_todaybhav.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API =[WEB_URL URL_TODAYRATE];
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
                [self parseResponse_itemcat:data];
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

- (void) parseResponse_itemcat:(NSData *) data {
    @try {
        array_item=[[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
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
            [[BusyIndicator sharedInstance]stopIndicator];
            array_item = [[NSMutableArray alloc]init];
            array_item = [pDict objectForKey:@"ratelist"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            if ([array_item count] == 0) {
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"No Record Found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                            {}];
                [alert addAction:yesButton];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark:- UITableView Delegate and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[array_item valueForKey:@"rateid"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
    UILabel *lbl_job = [[UILabel alloc] init];
    lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-200, 30);
    [lbl_job setFont:[UIFont boldSystemFontOfSize:17.0]];
    lbl_job.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"stamp"] objectAtIndex:indexPath.row]];
    lbl_job.textAlignment=NSTextAlignmentLeft;
    lbl_job.textColor=[UIColor redColor];
    [cell.contentView addSubview:lbl_job];
    
    //    UILabel *lbl_narr = [[UILabel alloc] init];
    //    lbl_narr.frame = CGRectMake(self.view.frame.size.width-190,10, self.view.frame.size.width-100, 30);
    //    [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    //    lbl_narr.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"rate"] objectAtIndex:indexPath.row]];
    //    lbl_narr.textAlignment=NSTextAlignmentLeft;
    //    lbl_narr.adjustsFontSizeToFitWidth=YES;
    //    [cell.contentView addSubview:lbl_narr];
    
    UILabel *lbl_status = [[UILabel alloc] init];
    lbl_status.frame = CGRectMake(self.view.frame.size.width-120,10, self.view.frame.size.width-10, 30);
    [lbl_status setFont:[UIFont boldSystemFontOfSize:17.0]];
    lbl_status.text = [NSString stringWithFormat:@"₹ %@",[[array_item valueForKey:@"rate"] objectAtIndex:indexPath.row]];
    lbl_status.textAlignment=NSTextAlignmentLeft;
    lbl_status.adjustsFontSizeToFitWidth=YES;
    lbl_status.textColor=[UIColor colorWithRed:71.0/255 green:177/255.0 blue:111/255.0 alpha:1.0];
    
    [cell.contentView addSubview:lbl_status];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

@end
