//
//  WalletVC.m
//  AirMobileShop
//
//  Created by Suresh Soni on 09/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "WalletVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"


@interface WalletVC ()

@end

@implementation WalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.title=@"My Orders";
    
    [self scrollData_Category];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *loginRequest=[NSString stringWithFormat:@"userid=%@",userid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_ITEMLIST]];
    
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
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
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


- (void) parseResponse_category:(NSData *) data {
    @try {
        
        nsarray_walletid=[[NSMutableArray alloc]init];
        nsarray_amount=[[NSMutableArray alloc]init];
        nsarray_type=[[NSMutableArray alloc]init];
        nsarray_created_date=[[NSMutableArray alloc]init];
        nsarray_type_status=[[NSMutableArray alloc]init];
		nsarray_id=[[NSMutableArray alloc]init];

        [[BusyIndicator sharedInstance]stopIndicator];
        
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_Order reloadData];
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
            
            
            [nsarray_walletid addObject:@"ID"];
            [nsarray_amount addObject:@"Price"];
            [nsarray_type addObject:@"Type"];
            [nsarray_created_date addObject:@"Date"];
            [nsarray_type_status addObject:@"Status"];
			[nsarray_id addObject:@"ID"];

			
            NSMutableArray* arrayResponse = [pDict objectForKey:@"walletlist"];
            NSLog(@"222222222222 %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++) {
                
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                NSString *walletid = [dictObject objectForKey:@"id"];
                NSString *amount = [dictObject objectForKey:@"amount"];
                NSString *type = [dictObject objectForKey:@"type"];
                NSString *created_date = [dictObject objectForKey:@"created_date"];
                NSString *type_status = [dictObject objectForKey:@"type_status"];
                
                [nsarray_walletid addObject:walletid];
                [nsarray_amount addObject:amount];
                [nsarray_type addObject:type];
                [nsarray_created_date addObject:created_date];
                [nsarray_type_status addObject:type_status];
                
				
				int a=i;
				a++;
				NSLog(@"a::%d",a);
				NSString* stra = [NSString stringWithFormat:@"%i", a];
				NSLog(@"stra::%@",stra);

				[nsarray_id addObject:stra];
                
                //                [nsarray_membership addObject:membership];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView_Order reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [nsarray_mid count];
    return [nsarray_id count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView_Order dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    UIImageView *additionalSeparator;
//    if (IS_iPhone6Plus) {
//        additionalSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,404,40)];
//    } else if(IS_iPhone6){
//        additionalSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,365,40)];
//    }else if(IS_iPhone5){
//        additionalSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,310,40)];
//    }else if(IS_iPhone4){
//        additionalSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,310,40)];
//    }else{
//        additionalSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,365,40)];
//
//    }
//    additionalSeparator.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0 alpha:1.0];
//    [cell.contentView addSubview:additionalSeparator];
	
	if(indexPath.row==0){
		cell.backgroundColor=[UIColor colorWithRed:255/255.0f green:127/255.0f blue:0/255.0f alpha:1.0];
		UILabel *lbl_walletid = [[UILabel alloc] init];
		lbl_walletid.frame = CGRectMake(5,10, 60, 25);
		lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_id objectAtIndex:indexPath.row]];
		lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_walletid.textColor=[UIColor whiteColor];
		lbl_walletid.textAlignment=NSTextAlignmentCenter;
		
		[cell addSubview:lbl_walletid];
		
		UILabel *lbl_date = [[UILabel alloc] init];
		lbl_date.frame = CGRectMake(70,10, 100, 25);
		lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date objectAtIndex:indexPath.row]];
		lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
		lbl_date.textColor=[UIColor whiteColor];
		lbl_date.textAlignment=NSTextAlignmentCenter;
		
		[cell addSubview:lbl_date];
		
		
		UILabel *lbl_price = [[UILabel alloc] init];
		lbl_price.frame = CGRectMake(175,10, 100, 25);
		lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount objectAtIndex:indexPath.row]];
		lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_price.textColor=[UIColor whiteColor];
		lbl_price.textAlignment=NSTextAlignmentCenter;
		[cell addSubview:lbl_price];
		
	
		NSString *str_status=[nsarray_type_status objectAtIndex:indexPath.row];
		UILabel *lbl_s_total = [[UILabel alloc] init];
		lbl_s_total.frame = CGRectMake(280,10, 100, 25);
		lbl_s_total.text = [NSString stringWithFormat:@"%@",str_status];
		lbl_s_total.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_s_total.textColor=[UIColor whiteColor];
		lbl_s_total.textAlignment=NSTextAlignmentCenter;
		[cell addSubview:lbl_s_total];
	}else{
		cell.backgroundColor=[UIColor colorWithRed:225.0/255.0f green:225.0/255.0f blue:225.0/255.0f alpha:1.0];
		UILabel *lbl_walletid = [[UILabel alloc] init];
		lbl_walletid.frame = CGRectMake(5,10, 60, 25);
		lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_id objectAtIndex:indexPath.row]];
		lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_walletid.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
		lbl_walletid.textAlignment=NSTextAlignmentCenter;
		
		[cell addSubview:lbl_walletid];
		
		UILabel *lbl_date = [[UILabel alloc] init];
		lbl_date.frame = CGRectMake(70,10, 100, 25);
		lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date objectAtIndex:indexPath.row]];
		lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
		lbl_date.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
		lbl_date.textAlignment=NSTextAlignmentCenter;
		
		[cell addSubview:lbl_date];
		
		
		UILabel *lbl_price = [[UILabel alloc] init];
		lbl_price.frame = CGRectMake(175,10, 100, 25);
		lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount objectAtIndex:indexPath.row]];
		lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_price.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
		lbl_price.textAlignment=NSTextAlignmentCenter;
		[cell addSubview:lbl_price];
		
		
		
		NSString *str_status=[nsarray_type_status objectAtIndex:indexPath.row];
		UILabel *lbl_s_total = [[UILabel alloc] init];
		lbl_s_total.frame = CGRectMake(280,10, 100, 25);
		if ([str_status isEqualToString:@"1"]) {
			lbl_s_total.text = [NSString stringWithFormat:@"Paid"];
		} else {
			lbl_s_total.text = [NSString stringWithFormat:@"Unpaid"];
		}
		
		lbl_s_total.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
		lbl_s_total.textColor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
		lbl_s_total.textAlignment=NSTextAlignmentCenter;
		[cell addSubview:lbl_s_total];
	}
	

    
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NewsDetailsVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsVC"];
    //    obj.str_news_img=[nsarray_image objectAtIndex:indexPath.row];
    //    obj.str_news_heading=[nsarray_title objectAtIndex:indexPath.row];
    //
    //    obj.str_news_narr=[nsarray_rem2 objectAtIndex:indexPath.row];
    //    obj.str_news_narr2=[nsarray_story objectAtIndex:indexPath.row];
    //
    //    obj.str_news_date=[nsarray_rem1 objectAtIndex:indexPath.row];
    //
    //    [self.navigationController pushViewController:obj animated:YES];
}


@end
