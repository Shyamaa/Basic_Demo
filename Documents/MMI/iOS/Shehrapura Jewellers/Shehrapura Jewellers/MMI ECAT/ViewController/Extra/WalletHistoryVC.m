//
//  WalletHistoryVC.m
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 11/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "WalletHistoryVC.h"

@interface WalletHistoryVC ()

@end

@implementation WalletHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title=@"Wallet History";
	
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
	[[BusyIndicator sharedInstance]startIndicator];
	NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
	NSString *loginRequest=[NSString stringWithFormat:@"userid=%@",userid];
	NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
	NSString *api = [NSString stringWithFormat:@""];
	NSURL *url = [NSURL URLWithString:api];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:data1];
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
		if ([data length] >0 && error == nil){
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
		
		nsarray_walletid_debit=[[NSMutableArray alloc]init];
		nsarray_amount_debit=[[NSMutableArray alloc]init];
		nsarray_type_debit=[[NSMutableArray alloc]init];
		nsarray_created_date_debit=[[NSMutableArray alloc]init];
		nsarray_type_status_debit=[[NSMutableArray alloc]init];
		nsarray_walletid_credit=[[NSMutableArray alloc]init];
		nsarray_amount_credit=[[NSMutableArray alloc]init];
		nsarray_type_credit=[[NSMutableArray alloc]init];
		nsarray_created_date_credit=[[NSMutableArray alloc]init];
		nsarray_type_status_credit=[[NSMutableArray alloc]init];
		
		[[BusyIndicator sharedInstance]stopIndicator];
		
		
		////////////// End processs load view
		NSString *myData = [[NSString alloc] initWithData:data
												 encoding:NSUTF8StringEncoding];
		NSLog(@"JSON data = %@", myData);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView_credit reloadData];
			[self.tableView_debit reloadData];
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
			
			
			[nsarray_walletid_credit addObject:@"ID"];
			[nsarray_amount_credit addObject:@"Price"];
			[nsarray_type_credit addObject:@"Type"];
			[nsarray_created_date_credit addObject:@"Date"];
			[nsarray_type_status_credit addObject:@"Status"];
			
			[nsarray_walletid_debit addObject:@"ID"];
			[nsarray_amount_debit addObject:@"Price"];
			[nsarray_type_debit addObject:@"Type"];
			[nsarray_created_date_debit addObject:@"Date"];
			[nsarray_type_status_debit addObject:@"Status"];
			
			NSMutableArray* arrayResponse = [pDict objectForKey:@"walletlist"];
			NSLog(@"222222222222 %@",arrayResponse);
			for (int i = 0; i < [arrayResponse count]; i++) {
				
				NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
				NSString *walletid = [dictObject objectForKey:@"id"];
				NSString *amount = [dictObject objectForKey:@"amount"];
				NSString *type = [dictObject objectForKey:@"type"];
				NSString *created_date = [dictObject objectForKey:@"created_date"];
				NSString *type_status = [dictObject objectForKey:@"type_status"];
				
				if ([type_status isEqualToString:@"0"]) {
					[nsarray_walletid_credit addObject:walletid];
					[nsarray_amount_credit addObject:amount];
					[nsarray_type_credit addObject:type];
					[nsarray_created_date_credit addObject:created_date];
					[nsarray_type_status_credit addObject:type_status];
				}else{
					[nsarray_walletid_debit addObject:walletid];
					[nsarray_amount_debit addObject:amount];
					[nsarray_type_debit addObject:type];
					[nsarray_created_date_debit addObject:created_date];
					[nsarray_type_status_debit addObject:type_status];
				}
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.tableView_credit reloadData];
					[self.tableView_debit reloadData];
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

	if (tableView==self.tableView_credit) {
		return [nsarray_walletid_credit count];

	}else{
		return [nsarray_walletid_debit count];
	}
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *myIdentifier = @"MyIdentifier";
	
	if (tableView==self.tableView_credit) {
		UITableViewCell *cell = [self.tableView_credit dequeueReusableCellWithIdentifier:myIdentifier];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (!cell) {
			cell = [[UITableViewCell alloc]init];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		
		
		if(indexPath.row==0){
			cell.backgroundColor=[UIColor colorWithRed:255/255.0f green:127/255.0f blue:0/255.0f alpha:1.0];
			UILabel *lbl_walletid = [[UILabel alloc] init];
			lbl_walletid.frame = CGRectMake(5,10, 60, 25);
			lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_walletid_credit objectAtIndex:indexPath.row]];
			lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_walletid.textColor=[UIColor whiteColor];
			lbl_walletid.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_walletid];
			
			UILabel *lbl_date = [[UILabel alloc] init];
			lbl_date.frame = CGRectMake(70,10, 100, 25);
			lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date_credit objectAtIndex:indexPath.row]];
			lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
			lbl_date.textColor=[UIColor whiteColor];
			lbl_date.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_date];
			
			
			UILabel *lbl_price = [[UILabel alloc] init];
			lbl_price.frame = CGRectMake(175,10, 100, 25);
			lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount_credit objectAtIndex:indexPath.row]];
			lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_price.textColor=[UIColor whiteColor];
			lbl_price.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_price];
			
			
			NSString *str_status=[nsarray_type_status_credit objectAtIndex:indexPath.row];
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
			lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_walletid_credit objectAtIndex:indexPath.row]];
			lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_walletid.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_walletid.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_walletid];
			
			UILabel *lbl_date = [[UILabel alloc] init];
			lbl_date.frame = CGRectMake(70,10, 100, 25);
			lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date_credit objectAtIndex:indexPath.row]];
			lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
			lbl_date.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_date.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_date];
			
			
			UILabel *lbl_price = [[UILabel alloc] init];
			lbl_price.frame = CGRectMake(175,10, 100, 25);
			lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount_credit objectAtIndex:indexPath.row]];
			lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_price.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_price.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_price];
			
			
			
			NSString *str_status=[nsarray_type_status_credit objectAtIndex:indexPath.row];
			UILabel *lbl_s_total = [[UILabel alloc] init];
			lbl_s_total.frame = CGRectMake(280,10, 100, 25);
			if ([str_status isEqualToString:@"0"]) {
				lbl_s_total.text = [NSString stringWithFormat:@"Credit"];
				lbl_s_total.textColor=[UIColor colorWithRed:0/255.0f green:102/255.0f blue:0/255.0f alpha:1.0];
				
			} else {
				lbl_s_total.text = [NSString stringWithFormat:@"Debit"];
				lbl_s_total.textColor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
				
			}
			
			lbl_s_total.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_s_total.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_s_total];
		}
		
		
		
		//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return cell;
	}else{
		UITableViewCell *cell = [self.tableView_debit dequeueReusableCellWithIdentifier:myIdentifier];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (!cell) {
			cell = [[UITableViewCell alloc]init];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		
		
		if(indexPath.row==0){
			cell.backgroundColor=[UIColor colorWithRed:255/255.0f green:127/255.0f blue:0/255.0f alpha:1.0];
			UILabel *lbl_walletid = [[UILabel alloc] init];
			lbl_walletid.frame = CGRectMake(5,10, 60, 25);
			lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_walletid_debit objectAtIndex:indexPath.row]];
			lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_walletid.textColor=[UIColor whiteColor];
			lbl_walletid.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_walletid];
			
			UILabel *lbl_date = [[UILabel alloc] init];
			lbl_date.frame = CGRectMake(70,10, 100, 25);
			lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date_debit objectAtIndex:indexPath.row]];
			lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
			lbl_date.textColor=[UIColor whiteColor];
			lbl_date.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_date];
			
			
			UILabel *lbl_price = [[UILabel alloc] init];
			lbl_price.frame = CGRectMake(175,10, 100, 25);
			lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount_debit objectAtIndex:indexPath.row]];
			lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_price.textColor=[UIColor whiteColor];
			lbl_price.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_price];
			
			
			NSString *str_status=[nsarray_type_status_debit objectAtIndex:indexPath.row];
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
			lbl_walletid.text = [NSString stringWithFormat:@"%@",[nsarray_walletid_debit objectAtIndex:indexPath.row]];
			lbl_walletid.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_walletid.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_walletid.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_walletid];
			
			UILabel *lbl_date = [[UILabel alloc] init];
			lbl_date.frame = CGRectMake(70,10, 100, 25);
			lbl_date.text = [NSString stringWithFormat:@"%@",[nsarray_created_date_debit objectAtIndex:indexPath.row]];
			lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:11];
			lbl_date.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_date.textAlignment=NSTextAlignmentCenter;
			
			[cell addSubview:lbl_date];
			
			
			UILabel *lbl_price = [[UILabel alloc] init];
			lbl_price.frame = CGRectMake(175,10, 100, 25);
			lbl_price.text = [NSString stringWithFormat:@"%@",[nsarray_amount_debit objectAtIndex:indexPath.row]];
			lbl_price.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_price.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
			lbl_price.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_price];
			
			
			
			NSString *str_status=[nsarray_type_status_debit objectAtIndex:indexPath.row];
			UILabel *lbl_s_total = [[UILabel alloc] init];
			lbl_s_total.frame = CGRectMake(280,10, 100, 25);
			if ([str_status isEqualToString:@"0"]) {
				lbl_s_total.text = [NSString stringWithFormat:@"Credit"];
				lbl_s_total.textColor=[UIColor colorWithRed:0/255.0f green:102/255.0f blue:0/255.0f alpha:1.0];
				
			} else {
				lbl_s_total.text = [NSString stringWithFormat:@"Debit"];
				lbl_s_total.textColor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
				
			}
			
			lbl_s_total.font = [UIFont fontWithName:@"Eras Demi ITC" size:12];
			lbl_s_total.textAlignment=NSTextAlignmentCenter;
			[cell addSubview:lbl_s_total];
		}
		
		
		
		//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return cell;
	}
	
	
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
