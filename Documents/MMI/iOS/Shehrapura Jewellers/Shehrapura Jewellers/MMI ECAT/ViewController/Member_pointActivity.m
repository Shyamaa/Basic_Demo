//
//  Member_pointActivity.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 20/07/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import "Member_pointActivity.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"

@interface Member_pointActivity ()

@end

@implementation Member_pointActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title=@"Member Point";
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
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_MEMBERPOINT]];
    
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

            array_memid = [[NSMutableArray alloc]init];
            array_refno = [[NSMutableArray alloc]init];
            array_tdate = [[NSMutableArray alloc]init];
            array_mpoints = [[NSMutableArray alloc]init];
            
            [array_memid addObject:@"ACNO"];
            [array_refno addObject:@"Name"];
            [array_tdate addObject:@"Date"];
            [array_mpoints addObject:@"Month"];

            array_item = [pDict objectForKey:@"memberpoint"];
            
            for (int i=0; i<[array_item count]; i++) {
                NSDictionary * dictObject = [array_item objectAtIndex:i];

                [array_memid addObject: [dictObject objectForKey:@"memid"]];
                [array_refno addObject: [dictObject objectForKey:@"refno"]];
                [array_tdate addObject: [dictObject objectForKey:@"tdate"]];
                [array_mpoints addObject: [dictObject objectForKey:@"mpoints"]];

            }
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
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array_memid count];
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
    
    NSLog(@"width ::::::::::::: %f",self.view.frame.size.width-200);
    
    if (indexPath.row ==0) {
        cell.backgroundColor = [UIColor blackColor];
        UILabel *lbl_job = [[UILabel alloc] init];
        lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-200, 30);
        [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_job.text = [NSString stringWithFormat:@"Ref No"];
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-190,10, self.view.frame.size.width-100, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.text = [NSString stringWithFormat:@"Date"];
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        lbl_narr.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_narr];
        
        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-90,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = [NSString stringWithFormat:@"Points"];
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        lbl_status.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_status];
    }else{
        cell.backgroundColor = [UIColor whiteColor];

        UILabel *lbl_job = [[UILabel alloc] init];
        lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-200, 30);
        [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_job.text = [NSString stringWithFormat:@"%@",[array_refno objectAtIndex:indexPath.row]];
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-190,10, self.view.frame.size.width-100, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.text = [NSString stringWithFormat:@"%@",[array_tdate objectAtIndex:indexPath.row]];
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:lbl_narr];
        
        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-90,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = [NSString stringWithFormat:@"%@",[array_mpoints objectAtIndex:indexPath.row]];
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:lbl_status];
    }
    
    
 

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   

}

@end
