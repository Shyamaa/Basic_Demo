//
//  UndeliveredDetail.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 24/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "UndeliveredDetail.h"

@interface UndeliveredDetail ()
{
    double int_actualwt;
}
@end

@implementation UndeliveredDetail
@synthesize str_cname,str_trnid;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = str_cname;
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&trnid=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath,str_trnid];
        URL_API =[WEB_URL URL_GET_UNDEL_DETAIL];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_undeliverdetail.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@&trnid=%@",apptype,mobile,ftppath,str_trnid];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&trnid=%@",apptype,mobile,str_trnid];
        URL_API =[WEB_URL URL_GET_UNDEL_DETAIL];
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

            array_additrn = [[NSMutableArray alloc]init];

            array_itrnid = [[NSMutableArray alloc]init];
            array_idesc = [[NSMutableArray alloc]init];
            array_iwt = [[NSMutableArray alloc]init];
            array_actualwt = [[NSMutableArray alloc]init];
            array_unit = [[NSMutableArray alloc]init];
            array_tno = [[NSMutableArray alloc]init];

            [array_itrnid addObject:@""];
            [array_idesc addObject:@""];
            [array_iwt addObject:@""];
            [array_actualwt addObject:@""];
            [array_unit addObject:@""];
            [array_tno addObject:@""];
            [array_additrn addObject:@""];

            double int_totwl = 0.0;

            NSMutableArray *array_item = [pDict objectForKey:@"unliveredlist"];
            for (int i = 0; i < [array_item count]; i++) {
                
                [array_itrnid addObject:[[array_item objectAtIndex:i] objectForKey:@"itrnid"]];
                [array_idesc addObject:[[array_item objectAtIndex:i] objectForKey:@"idesc"]];
                [array_iwt addObject:[[array_item objectAtIndex:i] objectForKey:@"iwt"]];
                [array_actualwt addObject:[[array_item objectAtIndex:i] objectForKey:@"actualwt"]];
                [array_unit addObject:[[array_item objectAtIndex:i] objectForKey:@"unit"]];
                [array_tno addObject:[[array_item objectAtIndex:i] objectForKey:@"tno"]];
                
                [array_additrn addObject:@""];
                NSString *str_iwt = [[array_item objectAtIndex:i] objectForKey:@"iwt"];
                int_totwl = int_totwl+[str_iwt doubleValue];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            lbl_wt.text = [NSString stringWithFormat:@"%f",int_totwl];
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
    return [array_itrnid count];
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
        lbl_job.text = @"Item";
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.numberOfLines = 2;
        lbl_job.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_refno = [[UILabel alloc] init];
        lbl_refno.frame = CGRectMake(self.view.frame.size.width-260,10, self.view.frame.size.width-190, 30);
        [lbl_refno setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_refno.text = @"Qty";
        lbl_refno.textAlignment=NSTextAlignmentLeft;
        lbl_refno.textColor=[UIColor whiteColor];
        lbl_refno.numberOfLines = 2;
        [cell.contentView addSubview:lbl_refno];
        
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-150,10, self.view.frame.size.width-80, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.text = @"";
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        lbl_narr.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_narr];

        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-80,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = @"Unit";
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        lbl_status.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:lbl_status];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
       
        UILabel *lbl_job = [[UILabel alloc] init];
        lbl_job.frame = CGRectMake(10,10, self.view.frame.size.width-270, 30);
        [lbl_job setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_job.text = [NSString stringWithFormat:@"%@",[array_idesc objectAtIndex:indexPath.row]];
        lbl_job.textAlignment=NSTextAlignmentLeft;
        lbl_job.numberOfLines = 2;
        lbl_job.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_job];
        
        UILabel *lbl_refno = [[UILabel alloc] init];
        lbl_refno.frame = CGRectMake(self.view.frame.size.width-260,10, self.view.frame.size.width-190, 30);
        [lbl_refno setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_refno.text = [NSString stringWithFormat:@"%@",[array_iwt objectAtIndex:indexPath.row]];
        lbl_refno.textAlignment=NSTextAlignmentLeft;
        lbl_refno.textColor=[UIColor blackColor];
        lbl_refno.numberOfLines = 2;
        [cell.contentView addSubview:lbl_refno];
        
        NSString *str_actualwt = [array_actualwt objectAtIndex:indexPath.row];
        
        UILabel *lbl_narr = [[UILabel alloc] init];
        lbl_narr.frame = CGRectMake(self.view.frame.size.width-150,10, self.view.frame.size.width-80, 30);
        [lbl_narr setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_narr.textAlignment=NSTextAlignmentLeft;
        lbl_narr.adjustsFontSizeToFitWidth=YES;
        lbl_narr.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_narr];
        if([str_actualwt isEqualToString:@"0"]){
            lbl_narr.text = @"0.000";
        }else{
            lbl_narr.text = [NSString stringWithFormat:@"%@",[array_actualwt objectAtIndex:indexPath.row]];
        }

        UILabel *lbl_status = [[UILabel alloc] init];
        lbl_status.frame = CGRectMake(self.view.frame.size.width-80,10, self.view.frame.size.width-10, 30);
        [lbl_status setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_status.text = [NSString stringWithFormat:@"%@",[array_unit objectAtIndex:indexPath.row]];
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.adjustsFontSizeToFitWidth=YES;
        lbl_status.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_status];
        
    
        UIButton * btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_delete.frame = CGRectMake(self.view.frame.size.width-40,10, 30, 30);
        btn_delete.titleLabel.font = [UIFont systemFontOfSize:15.0];
        UIImage *image_minus;
        NSString * str_iwt = @"";
        if([str_actualwt isEqualToString:@"0"]){
            image_minus = [UIImage imageNamed:@"uncheckcircle.png"];
        }else{
            image_minus = [UIImage imageNamed:@"checkcircle.png"];
        }
        [btn_delete setBackgroundImage:image_minus forState:UIControlStateNormal];
        btn_delete.tag = indexPath.row;
        [btn_delete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_delete];
        
    }
    
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)btn_delete:(UIButton*)sender
{
    NSInteger index_c = [sender tag];
    NSString *s_actual = [array_actualwt objectAtIndex:index_c];
    if([s_actual isEqualToString:@"0"]){
        NSString *str_actualwt = [array_iwt objectAtIndex:index_c];
        [array_actualwt replaceObjectAtIndex:index_c withObject:str_actualwt];
        int_actualwt = int_actualwt+[str_actualwt doubleValue];
        
        NSString *str_itrnid = [array_itrnid objectAtIndex:index_c];
        NSString *str_tno = [array_tno objectAtIndex:index_c];
        NSString *str_iwwt = [array_iwt objectAtIndex:index_c];

        NSString * string3 = [NSString stringWithFormat:@"%@,%@,%@,%@",str_itrnid,str_trnid,str_iwwt,str_tno];
        [array_additrn replaceObjectAtIndex:index_c withObject:string3];
    }else{
        int_actualwt = int_actualwt-[s_actual doubleValue];
        [array_actualwt replaceObjectAtIndex:index_c withObject:@"0"];
        [array_additrn replaceObjectAtIndex:index_c withObject:@"0"];
    }
    [self.tableView reloadData];
    lbl_wt1.text = [NSString stringWithFormat:@"%f",int_actualwt];
}

- (IBAction)btn_save:(id)sender {
    designparam=@"";
    for (int i = 0; i < [array_additrn count]; i++) {
        NSString * wt = [array_additrn objectAtIndex:i];
        if(![wt isEqualToString:@"0"]){
            if(designparam.length != 0){
                NSString *str_w = @": ,";
                wt = [str_w stringByAppendingString:wt];
            }
            designparam = [designparam stringByAppendingString:wt];
        }
    }
    NSLog(@"designparam ::::::::::  %@",designparam);
    
    if(designparam.length != 0){
        [self scrollData_Deleivered];
    }
}


-(void)scrollData_Deleivered {
    [[BusyIndicator sharedInstance]startIndicator];

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *delivered = @"NO";
    if([lbl_wt.text isEqualToString:lbl_wt1.text]){
        delivered =@"YES";
    }
    
    
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&trnid=%@&delivered=%@&designparam=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath,str_trnid,delivered,designparam];
        URL_API =[WEB_URL URL_INSERT_ITRNDEL];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_itrndel.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@&trnid=%@&delivered=%@&designparam=%@",apptype,mobile,ftppath,str_trnid,delivered,designparam];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&trnid=%@&delivered=%@&designparam=%@",apptype,mobile,str_trnid,delivered,designparam];
        URL_API =[WEB_URL URL_INSERT_ITRNDEL];
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
                [self parse_save:data];
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



- (void)parse_save:(NSData *) data {
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
                MMIHOMEPanel *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                [self.navigationController pushViewController:obj animated:YES];
            
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
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

@end
