//
//  NotificationVC.m
//  Dia Jewels
//
//  Created by MMI SOFTWARES PVT LTD on 12/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "NotificationVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"


@interface NotificationVC ()
{
    UIButton *btnAdd_Cart;
}
@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
        [self setUpNavigationLogo];
    }else{
        self.title =@"Notification";
    }
    [self scrollData_item];
}


 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];

    NSString *loginRequest=[NSString stringWithFormat:@"category=%@&mobile=%@&grade=%@&rating=%@&closingday=%@&area=%@",category,mobile,@"0",@"0",@"0",@"0"];
    NSLog(@"notification :::::::::::::::  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_NOTIFICATION]];
    NSLog(@"api  :::::::::::::::: %@",api);

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


- (void) parseResponse_itemcat:(NSData *) data {
    @try {
        array_item=[[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
        
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
            
        
            array_item = [pDict objectForKey:@"alertlist"];
            [self.tableview reloadData];

            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [nsarray_mid count];
    return [[array_item valueForKey:@"alertid"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *subContainView = [[UIView alloc] init];
    subContainView.frame = CGRectMake(10,10, tableView.frame.size.width - 20, 60);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 10;
    subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_item01 = [[UILabel alloc] init];
    lbl_item01.frame = CGRectMake(10,8, self.view.frame.size.width-15, 20);
    [lbl_item01 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item01.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"msg"] objectAtIndex:indexPath.row]];
    lbl_item01.textAlignment = NSTextAlignmentLeft;
    lbl_item01.adjustsFontSizeToFitWidth = YES;
    [subContainView addSubview:lbl_item01];
    
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(10,32, self.view.frame.size.width-15, 20);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_itemname.text = [NSString stringWithFormat:@"Date : %@",[[array_item valueForKey:@"tdate"] objectAtIndex:indexPath.row]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor=[UIColor lightGrayColor];
    [subContainView addSubview:lbl_itemname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    str_tsnolist = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"tsnolist"] objectAtIndex:indexPath.row]];
//    NSLog(@"str_tsnolist :::%@ ",str_tsnolist);
//
//    if ([str_tsnolist isEqualToString:@"0"] || str_tsnolist.length ==0) {
//
//
//        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Detail not found"
//                                                                      message:@""
//                                                               preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                    }];
//        [alert addAction:yesButton];
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }else{
//        ino = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"ino"] objectAtIndex:indexPath.row]];
//        str_flag = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"flag"] objectAtIndex:indexPath.row]];
//        str_demid = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"demid"] objectAtIndex:indexPath.row]];
//        [self CDemanTimeAPI];
//    }

}



@end
