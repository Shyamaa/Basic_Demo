//
//  Repair_class.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 20/07/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import "Repair_class.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"

@interface Repair_class ()

@end

@implementation Repair_class

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title=@"Repair";
    [self scrollData_item];

}


 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@",mobile];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_REPAIRSOFTWARES]];
    
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
    
            array_item = [pDict objectForKey:@"repair"];
            [self.tableview reloadData];
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [nsarray_mid count];
    return [[array_item valueForKey:@"jobno"] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *lbl_job = [[UILabel alloc] init];
    lbl_job.frame = CGRectMake(10,10, 300, 30);
    [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_job.text = [NSString stringWithFormat:@"Job No - %@",[[array_item valueForKey:@"jobno"] objectAtIndex:indexPath.row]];
    lbl_job.textAlignment=NSTextAlignmentLeft;
    lbl_job.textColor=[UIColor blackColor];
    lbl_job.numberOfLines=4;
    [cell.contentView addSubview:lbl_job];
    
    UILabel *lbl_narr = [[UILabel alloc] init];
    lbl_narr.frame = CGRectMake(10,35, 300, 30);
    [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_narr.text = [NSString stringWithFormat:@"Narr -  %@",[[array_item valueForKey:@"narr"] objectAtIndex:indexPath.row]];
    lbl_narr.textAlignment=NSTextAlignmentLeft;
    lbl_narr.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:lbl_narr];
    
    UILabel *lbl_status = [[UILabel alloc] init];
    lbl_status.frame = CGRectMake(10,60, 300, 30);
    [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_status.text = [NSString stringWithFormat:@"Status -  %@",[[array_item valueForKey:@"status"] objectAtIndex:indexPath.row]];
    lbl_status.textAlignment=NSTextAlignmentLeft;
    lbl_status.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:lbl_status];
 
    UILabel *lbl_date = [[UILabel alloc] init];
    lbl_date.frame = CGRectMake(10,85, 300, 30);
    [lbl_date setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_date.text = [NSString stringWithFormat:@"Date -  %@",[[array_item valueForKey:@"date"] objectAtIndex:indexPath.row]];
    lbl_date.textAlignment=NSTextAlignmentLeft;
    lbl_date.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:lbl_date];
    
    UILabel *lbl_duedate = [[UILabel alloc] init];
    lbl_duedate.frame = CGRectMake(10,110, 300, 30);
    [lbl_duedate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_duedate.text = [NSString stringWithFormat:@"Due Date -  %@",[[array_item valueForKey:@"duedate"] objectAtIndex:indexPath.row]];
    lbl_duedate.textAlignment=NSTextAlignmentLeft;
    lbl_duedate.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:lbl_duedate];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end
