//
//  RateBookVC.m
//  Jewel Desk
//
//  Created by App Dev on 15/05/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "RateBookVC.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "PopupRatebook.h"

#define MENUEWIDTH   250

@interface RateBookVC ()

@end

@implementation RateBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Rate Book";
    [self scrollData_item];
}

-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@",mobile];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_KITTY_LIST]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
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
        array_item = [[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
        
        NSError *error = nil;
        
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if(jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            [[BusyIndicator sharedInstance] stopIndicator];
            
            array_item = [pDict objectForKey:@"kittylist"];
            [self.tableview reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark: TableView Delegate and Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == alertTableView){
        NSLog(@"alert Item List Data count = %lu", (unsigned long)[array_AlertItemList count]);
        return [array_AlertItemList count];
    }else{
        return [array_item count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    if (tableView == alertTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *str_Date =[[array_AlertItemList valueForKey:@"tdate"] objectAtIndex:indexPath.row];
        NSString *str_Amount = [[array_AlertItemList valueForKey:@"amount"] objectAtIndex:indexPath.row];
        NSString *str_Mode = [[array_AlertItemList valueForKey:@"rmode"] objectAtIndex:indexPath.row];
        UILabel *lbl_itemname = [[UILabel alloc] init];
        lbl_itemname.frame = CGRectMake(10,5, tableView.frame.size.width, 40);
        [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        lbl_itemname.textAlignment = NSTextAlignmentLeft;
        lbl_itemname.textColor = [UIColor blackColor];
        lbl_itemname.numberOfLines = 2;
        lbl_itemname.text =  [NSString stringWithFormat:@"%@, Amount = %@,\nMode = %@",str_Date,str_Amount,str_Mode];
        [cell.contentView addSubview:lbl_itemname];
        
        return cell;
    }else{
        UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 46)];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.cornerRadius = 10.0; // Set corner radius to make it rounded
        cardView.layer.shadowColor = [[UIColor blackColor] CGColor];
        cardView.layer.shadowOpacity = 0.5;
        cardView.layer.shadowRadius = 2.0;
        cardView.layer.shadowOffset = CGSizeMake(0, 2);
        cardView.layer.borderWidth = 1.0;
        cardView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [cell.contentView addSubview:cardView];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(tableView.frame.size.width-50, 5, 40, 40);
        //[detailButton setTitle:@"Detail" forState:UIControlStateNormal];
        UIImage *icon = [UIImage imageNamed:@"info_icon"]; // Use your custom icon here
        [detailButton setImage:icon forState:UIControlStateNormal];
        detailButton.tag = indexPath.row;
        //detailButton.backgroundColor = [UIColor redColor];
        [detailButton addTarget:self action:@selector(detailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:detailButton];
        
        UIButton *btn_popup = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_popup setFrame:CGRectMake(tableView.frame.size.width - 160,5,100, 40)];
        [btn_popup setTitle:@"Rate Book" forState:UIControlStateNormal];
        [btn_popup addTarget:self action:@selector(btn_ratebook:) forControlEvents:UIControlEventTouchUpInside];
        btn_popup.tag = indexPath.row;
        [btn_popup setTintColor:[UIColor whiteColor]];
        btn_popup.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
        btn_popup.layer.cornerRadius = 10.0;
        [cell.contentView addSubview:btn_popup];
        
        UILabel *lbl_itemname = [[UILabel alloc] init];
        lbl_itemname.frame = CGRectMake(10,5, tableView.frame.size.width-170, 40);
        [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        lbl_itemname.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"kmno"] objectAtIndex:indexPath.row]];
        lbl_itemname.textAlignment = NSTextAlignmentLeft;
        lbl_itemname.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl_itemname];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str_ktid = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"ktid"] objectAtIndex:indexPath.row]];
    NSLog(@"str_ktid :::%@ ",str_ktid);
    
    NSString * str_stampid = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"stampid"] objectAtIndex:indexPath.row]];
    NSLog(@"str_stampid :::%@ ",str_stampid);
}

- (void)btn_ratebook:(UIButton *)sender {
    // Handle button tap action
    NSLog(@"checkbox : %ld ",(long)sender.tag);
    NSInteger index_c = [sender tag];
    
    NSString * kmno = [[array_item valueForKey:@"kmno"] objectAtIndex:index_c];
    NSString * ktid = [[array_item valueForKey:@"ktid"] objectAtIndex:index_c];
    NSString * stampid = [[array_item valueForKey:@"stampid"] objectAtIndex:index_c];
    
    NSLog(@"kmno : %@ ",kmno);
    NSLog(@"ktid : %@ ",ktid);
    NSLog(@"stampid : %@ ",stampid);
    
    [self CHECK_TODAYRATE:kmno ktid:ktid stampid:stampid];
}


- (void)detailButtonTapped:(UIButton *)sender {
    // Handle button tap action
    NSLog(@"checkbox : %ld ",(long)sender.tag);
    NSInteger index_c = [sender tag];
    
    str_ktid = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"ktid"] objectAtIndex:index_c]];
    NSLog(@"str_ktid :::%@ ",str_ktid);
    [self scrollData_kitty];
}


-(void)Alertswid {
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width-10, [array_AlertItemList count]*50);
    [controller setPreferredContentSize:rect.size];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    //[alertTableView reloadData];
    alertTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    alertTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    alertTableView.tag = 1000;
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    // Register UITableViewCell class
    [alertTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"alertCell"];
    
    [controller.view addSubview:alertTableView];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    //[alertController addAction:cancelAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self->alertTableView reloadData];
    });
}

-(void)scrollData_kitty {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest=[NSString stringWithFormat:@"ktid=%@",str_ktid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_KITTY_TRAN]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_kitty:data];
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


- (void) parseResponse_kitty:(NSData *) data {
    @try {
        array_AlertItemList = [[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if(jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            [[BusyIndicator sharedInstance] stopIndicator];
            array_AlertItemList = [[pDict objectForKey:@"kttranlist"] mutableCopy];
            NSLog(@"alert Item List Data = %@", array_AlertItemList);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self Alertswid];
                //[self->alertTableView reloadData];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)CHECK_TODAYRATE:(NSString *)kmno ktid:(NSString *)ktid stampid:(NSString *)stampid 
{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest=[NSString stringWithFormat:@"stampid=%@",stampid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CHECK_TODAYRATE]];
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
                [self parseLogin_today:data];
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


- (void)parseLogin_today:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;

    NSDictionary *responseData = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:NSJSONReadingAllowFragments
                           error:&error];
    
    NSMutableArray* arrayResponse_msg = [responseData objectForKey:@"message"];
    NSString *str_msg = [arrayResponse_msg description];
    
    NSMutableArray* array_status = [responseData objectForKey:@"success"];
    NSString * str_status = [array_status description];
    
    if ([str_status isEqualToString:@"1"])
    {
        [[BusyIndicator sharedInstance]stopIndicator];

        PopupRatebook *popupVC = [[PopupRatebook alloc] init];
        popupVC.str_todayrate = str_msg;
    
        popupVC.completionHandler = ^(NSString *amount,NSString *wt, NSString *text2,NSString *btnaction) {
            [self SAVE_DATA:amount wt:wt];
        };
        popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:popupVC animated:YES completion:nil];
        
    }else{
        [self show:str_msg];
    }
}

-(void)show:(NSString *)str_msg 
{
    [[BusyIndicator sharedInstance]stopIndicator];

    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:str_msg
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)SAVE_DATA:(NSString *)amount wt:(NSString *)wt
{
    NSString *stampid =@"";
    NSString *ktid = @"";
    NSString *kmno = @"";
    NSString *bhavrate =@"";
    NSString *str_amt = @"";
    NSString *bhavwt = @"";
    NSString *mobile = @"";

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest = [NSString stringWithFormat:@"stampid=%@",stampid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_CHECK_TODAYRATE]];
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
                [self parseLogin_savetoday:data];
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


- (void) parseLogin_savetoday:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;

    NSDictionary *responseData = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:NSJSONReadingAllowFragments
                           error:&error];
    
    NSMutableArray *arrayResponse_msg = [responseData objectForKey:@"message"];
    NSString *str_msg = [arrayResponse_msg description];
    
    NSMutableArray *array_status = [responseData objectForKey:@"success"];
    NSString * str_status = [array_status description];
    
    if ([str_status isEqualToString:@"1"])
    {
        [[BusyIndicator sharedInstance]stopIndicator];
        [self show:str_msg];
    }else{
        [self show:str_msg];
    }
}


@end
