//
//  Undelivered.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 24/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "Undelivered.h"
#import "UndeliveredDetail.h"

@interface Undelivered ()

@end

@implementation Undelivered

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Undelivered";
    [self scrollData_item];
}

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
        URL_API =[WEB_URL URL_GET_UNDELIVERED];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_undeliver.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API =[WEB_URL URL_GET_UNDELIVERED];
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
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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

            array_trnid = [[NSMutableArray alloc]init];
            array_cname = [[NSMutableArray alloc]init];
            array_refno = [[NSMutableArray alloc]init];
            array_tdate = [[NSMutableArray alloc]init];
            array_iwt = [[NSMutableArray alloc]init];
            
            [array_trnid addObject:@""];
            [array_cname addObject:@""];
            [array_refno addObject:@""];
            [array_tdate addObject:@""];
            [array_iwt addObject:@""];

            NSMutableArray *array_item = [pDict objectForKey:@"unliveredlist"];
           
            for (int i = 0; i < [array_item count]; i++)
            {
                [array_trnid addObject:[[array_item objectAtIndex:i] objectForKey:@"trnid"]];
                [array_cname addObject:[[array_item objectAtIndex:i] objectForKey:@"cname"]];
                [array_refno addObject:[[array_item objectAtIndex:i] objectForKey:@"refno"]];
                [array_tdate addObject:[[array_item objectAtIndex:i] objectForKey:@"tdate"]];
                [array_iwt addObject:[[array_item objectAtIndex:i] objectForKey:@"iwt"]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array_trnid count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    if(indexPath.row ==0){
        cell.backgroundColor = [UIColor blackColor];

        UILabel *lbl_job = [[UILabel alloc] init];
        lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-270, 30);
        [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_job.text = @"Name";
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.numberOfLines = 2;
        lbl_job.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_refno = [[UILabel alloc] init];
        lbl_refno.frame = CGRectMake(self.view.frame.size.width-260,10, self.view.frame.size.width-190, 30);
        [lbl_refno setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_refno.text = @"Ref No";
        lbl_refno.textAlignment=NSTextAlignmentLeft;
        lbl_refno.textColor=[UIColor whiteColor];
        lbl_refno.numberOfLines = 2;
        [cell.contentView addSubview:lbl_refno];
        
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-150,10, self.view.frame.size.width-80, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.text = @"Date";
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        lbl_narr.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_narr];

        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-70,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = @"GWt.";
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        lbl_status.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_status];
    }else{
        cell.backgroundColor = [UIColor whiteColor];

        UILabel *lbl_job = [[UILabel alloc] init];
        lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-270, 30);
        [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_job.text = [NSString stringWithFormat:@"%@",[array_cname objectAtIndex:indexPath.row]];
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.numberOfLines = 2;
        lbl_job.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_refno = [[UILabel alloc] init];
        lbl_refno.frame = CGRectMake(self.view.frame.size.width-260,10, self.view.frame.size.width-190, 30);
        [lbl_refno setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_refno.text = [NSString stringWithFormat:@"%@",[array_refno objectAtIndex:indexPath.row]];
        lbl_refno.textAlignment=NSTextAlignmentLeft;
        lbl_refno.textColor=[UIColor blackColor];
        lbl_refno.numberOfLines = 2;
        [cell.contentView addSubview:lbl_refno];
        
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-150,10, self.view.frame.size.width-80, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.text = [NSString stringWithFormat:@"%@",[array_tdate objectAtIndex:indexPath.row]];
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        lbl_narr.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_narr];

        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-70,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = [NSString stringWithFormat:@"₹ %@",[array_iwt objectAtIndex:indexPath.row]];
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        lbl_status.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_status];
    }
    
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
    }else{
        UndeliveredDetail *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"UndeliveredDetail"];
        obj.str_trnid = [array_trnid objectAtIndex:indexPath.row];
        obj.str_cname = [array_cname objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
    }
   
}


@end
