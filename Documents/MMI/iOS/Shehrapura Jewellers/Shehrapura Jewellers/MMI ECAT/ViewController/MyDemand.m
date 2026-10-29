//
//  MyDemand.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 15/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "MyDemand.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"

@interface MyDemand ()
{
    UIButton *btnAdd_Cart;
}
@end

@implementation MyDemand
{
 
    CustomPopUp *mPopUp;
     
}
-(void)btn_CartMenu
{
    [self Popup];
//    [mPopUp show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Demand";
    btnAdd_Cart =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAdd_Cart.frame = CGRectMake(0,8,30,30);
    [btnAdd_Cart addTarget:self action:@selector(btn_CartMenu) forControlEvents:UIControlEventTouchUpInside];
    [[btnAdd_Cart imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnAdd_Cart.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btnAdd_Cart.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithCustomView:btnAdd_Cart];
    about.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:about, nil];
    
    [self scrollData_item];
    
    mPopUp = [CustomPopUp new];
    [mPopUp initAlertwithParent:self withDelegate:self];
    
//    [mPopUp setBackgroundColor:[UIColor redColor]];
    
//    CGRect someRect = CGRectMake(0.0, 0.0, 100.0, 30.0);
//    UITextField* text = [[UITextField alloc] initWithFrame:someRect];
//    UIView* view = [[UIView alloc] initWithFrame:someRect];
//    [text setText:@"New"];
//    [text setBackgroundColor:[UIColor redColor]];
//    [view addSubview:text];
//    [mPopUp addSubview:view];
    
    
}

-(void) okClicked{
    
    NSLog(@"Close");

    [mPopUp hide];
     
}
 
-(void) cancelClicked{
    NSLog(@"Cancel");
}
 
-(IBAction)showAlert :(id)sender{
    [mPopUp show];
}
 
-(IBAction)dummyClick :(id)sender{
     
    NSLog(@"Click Dummy");
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
    
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_FDEMAND]];
    
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
            
            
            
            array_item = [pDict objectForKey:@"demand"];
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
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [nsarray_mid count];
    return [[array_item valueForKey:@"ino"] count];
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
    
    UIView *subContainView = [[UIView alloc] init];
    subContainView.frame = CGRectMake(2,2, tableView.frame.size.width - 4, 116);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 10;
    subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(10,10, subContainView.frame.size.width - 10, 30);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_itemname.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"ino"] objectAtIndex:indexPath.row]];
    lbl_itemname.textAlignment=NSTextAlignmentLeft;
    lbl_itemname.textColor=[UIColor blackColor];
    lbl_itemname.numberOfLines=4;
    [cell addSubview:lbl_itemname];
    
    UILabel *lbl_item01 = [[UILabel alloc] init];
    lbl_item01.frame = CGRectMake(10,40, 150, 20);
    [lbl_item01 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item01.text = [NSString stringWithFormat:@"Wt From : %@",[[array_item valueForKey:@"wtf"] objectAtIndex:indexPath.row]];
    lbl_item01.textAlignment=NSTextAlignmentLeft;
    lbl_item01.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:lbl_item01];
    
    UILabel *lbl_item02 = [[UILabel alloc] init];
    lbl_item02.frame = CGRectMake(160,40, 150, 20);
    [lbl_item02 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item02.text = [NSString stringWithFormat:@"Wt To : %@",[[array_item valueForKey:@"wtt"] objectAtIndex:indexPath.row]];
    lbl_item02.textAlignment=NSTextAlignmentLeft;
    lbl_item02.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:lbl_item02];
    
    UILabel *lbl_item11 = [[UILabel alloc] init];
    lbl_item11.frame = CGRectMake(10,65, 150, 20);
    [lbl_item11 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item11.text = [NSString stringWithFormat:@"Amount From : %@",[[array_item valueForKey:@"amtf"] objectAtIndex:indexPath.row]];
    lbl_item11.textAlignment=NSTextAlignmentLeft;
    lbl_item11.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:lbl_item11];
    
    UILabel *lbl_item12 = [[UILabel alloc] init];
    lbl_item12.frame = CGRectMake(160,65, 150, 20);
    [lbl_item12 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item12.text = [NSString stringWithFormat:@"Amount To : %@",[[array_item valueForKey:@"amtt"] objectAtIndex:indexPath.row]];
    lbl_item12.textAlignment=NSTextAlignmentLeft;
    lbl_item12.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:lbl_item12];
    
    NSString *str_status = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"approved"] objectAtIndex:indexPath.row]];
    UILabel *lbl_item13 = [[UILabel alloc] init];
    lbl_item13.frame = CGRectMake(10,90, 250, 20);
    [lbl_item13 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    if ([str_status isEqualToString:@"0"]) {
        lbl_item13.text = [NSString stringWithFormat:@"Pending"];
    }else{
        lbl_item13.text = [NSString stringWithFormat:@"Approved"];
    }
    lbl_item13.textAlignment=NSTextAlignmentLeft;
    lbl_item13.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:lbl_item13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    str_tsnolist = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"tsnolist"] objectAtIndex:indexPath.row]];
    NSLog(@"str_tsnolist :::%@ ",str_tsnolist);
    
    if ([str_tsnolist isEqualToString:@"0"] || str_tsnolist.length ==0) {
        
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Detail not found"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        ino = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"ino"] objectAtIndex:indexPath.row]];
        str_flag = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"flag"] objectAtIndex:indexPath.row]];
        str_demid = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"demid"] objectAtIndex:indexPath.row]];
        [self CDemanTimeAPI];
    }

}


-(void)CDemanTimeAPI {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];

    NSString *loginRequest=[NSString stringWithFormat:@"demid=%@",str_demid];
    //    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_UPDATECTIME]];
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
                [self parseCDemanTimeAPI:data];
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


- (void)parseCDemanTimeAPI:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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
            
            if ([str_success isEqualToString:@"1"] || [str_success isEqualToString:@"0"]) {
                NSLog(@"str_flag ::::::::::::::: %@",str_flag);

            
                if ([str_flag isEqualToString:@"1"]) {
                    ProductGallery *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
                    obj.str_tsnolist=str_tsnolist;
                    obj.str_activity=@"CDemand";
                    obj.str_igroup =@"";
                    [self.navigationController pushViewController:obj animated:YES];
                }else{
                    Showitem *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"Showitem"];
                    obj.str_tsnolist=str_tsnolist;
                    obj.str_activity=@"CDemand";
                    obj.str_idesc=ino;
                    NSLog(@"str_tsnolist ::::::::::::::: %@",str_tsnolist);
                    [self.navigationController pushViewController:obj animated:YES];
                }
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
//                                                NSLog(@"you pressed Yes, please button");
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




-(void)Popup{

    view1 = [[UIView alloc] initWithFrame:CGRectMake(40, 30, self.view.frame.size.width - 80, 300.0f)];
    view1.backgroundColor = [UIColor colorNamed:@"border_Color"];
    view1.center = self.view.center;
    view1.layer.cornerRadius = 10;
    view1.layer.masksToBounds = true;
    [[self view] addSubview:view1];
    
    CGRect someRect_remarks = CGRectMake(40,40, view1.frame.size.width - 80, 40);
    text_item = [[UITextField alloc] initWithFrame:someRect_remarks];
    text_item.placeholder=@"Select Item";
    text_item.textAlignment=NSTextAlignmentCenter;
    text_item.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:text_item];
    
//    CGRect frame = CGRectMake(30.0, 60.0, 240, 10.0);
//    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
//    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
//    [slider setBackgroundColor:[UIColor clearColor]];
//    slider.minimumValue = 0.0;
//    slider.maximumValue = 50.0;
//    slider.continuous = YES;
//    slider.value = 25.0;
//    [view1 addSubview:slider];
    
    double halfRect = (someRect_remarks.size.width/2);
    
    CGRect someRect_wt = CGRectMake(40, 95, halfRect, 40.0);
    text_wtfrom = [[UITextField alloc] initWithFrame:someRect_wt];
    text_wtfrom.placeholder=@"Wt From";
    text_wtfrom.textAlignment=NSTextAlignmentCenter;
    text_wtfrom.borderStyle = UITextBorderStyleRoundedRect;
    text_wtfrom.keyboardType = UIKeyboardTypeDecimalPad;
    [view1 addSubview:text_wtfrom];
    
    CGRect someRect_wtto = CGRectMake(halfRect+42, 95, halfRect, 40.0);
    text_wtto = [[UITextField alloc] initWithFrame:someRect_wtto];
    text_wtto.placeholder=@"Wt To";
    text_wtto.textAlignment=NSTextAlignmentCenter;
    text_wtto.borderStyle = UITextBorderStyleRoundedRect;
    text_wtto.keyboardType = UIKeyboardTypeDecimalPad;
    [view1 addSubview:text_wtto];
    
//    CGRect frame1 = CGRectMake(30.0, 120.0, 240, 10.0);
//    UISlider *slider_amt = [[UISlider alloc] initWithFrame:frame1];
//    [slider_amt addTarget:self action:@selector(sliderAction1:) forControlEvents:UIControlEventValueChanged];
//    [slider_amt setBackgroundColor:[UIColor clearColor]];
//    slider_amt.minimumValue = 0.0;
//    slider_amt.maximumValue = 50.0;
//    slider_amt.continuous = YES;
//    slider_amt.value = 25.0;
//    [view1 addSubview:slider_amt];
    
    CGRect someRect_amtfrom = CGRectMake(40, 150, halfRect, 40.0);
    text_amtfrom = [[UITextField alloc] initWithFrame:someRect_amtfrom];
    text_amtfrom.placeholder=@"Amount From";
    text_amtfrom.textAlignment=NSTextAlignmentCenter;
    text_amtfrom.borderStyle = UITextBorderStyleRoundedRect;
    text_amtfrom.keyboardType = UIKeyboardTypeDecimalPad;
    [view1 addSubview:text_amtfrom];
    
    CGRect someRect_amtto = CGRectMake(halfRect+42, 150, halfRect, 40.0);
    text_amtto = [[UITextField alloc] initWithFrame:someRect_amtto];
    text_amtto.placeholder=@"Amount To";
    text_amtto.textAlignment=NSTextAlignmentCenter;
    text_amtto.borderStyle = UITextBorderStyleRoundedRect;
    text_amtto.keyboardType = UIKeyboardTypeDecimalPad;
    [view1 addSubview:text_amtto];
    
    UIButton * btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cancel.frame = CGRectMake(40, 220, halfRect, 50.0f);
    [btn_cancel setTitle:@"Cancle" forState: UIControlStateNormal];
    [btn_cancel setBackgroundColor:[UIColor colorNamed:@"appRed_Color"]];
    [btn_cancel addTarget:self action:@selector(btn_cancel:) forControlEvents:UIControlEventTouchUpInside];
    btn_cancel.layer.cornerRadius = 10;
    [view1 addSubview:btn_cancel];
    
    UIButton * btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(halfRect+42, 220, halfRect, 50.0f);
    [btn_save setTitle:@"OK" forState: UIControlStateNormal];
    [btn_save setBackgroundColor:[UIColor colorNamed:@"appRed_Color"]];
    [btn_save addTarget:self action:@selector(btn_ok:) forControlEvents:UIControlEventTouchUpInside];
    btn_save.layer.cornerRadius = 10;
    [view1 addSubview:btn_save];
    
   
    
    [self scrollData_Category];
    
}

//-(void)sliderAction:(id)sender
//{
//    UISlider *slider = (UISlider*)sender;
//    float value = slider.value;
//}
//-(void)sliderAction1:(id)sender
//{
//    UISlider *slider = (UISlider*)sender;
//    float value = slider.value;
//}

-(void)btn_ok:(UIButton*)sender
{
    
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        self->view1.hidden = YES;
                    }
                    completion:NULL];
    
    [self SAVE_API];
}

-(void)btn_cancel:(UIButton*)sender
{
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        self->view1.hidden = YES;
                    }
                    completion:NULL];
}


-(void)SAVE_API {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ino=text_item.text;
    NSString *wtf = text_wtfrom.text;
    NSString *wtt = text_wtto.text;
    NSString *amtf = text_amtfrom.text;
    NSString *amtt = text_amtto.text;
    NSString *approved = @"0";
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSString *loginRequest=[NSString stringWithFormat:@"ino=%@&wtf=%@&wtt=%@&amtf=%@&amtt=%@&approved=%@&mobile=%@",ino,wtf,wtt,amtf,amtt,approved,mobile];

    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_Idemand]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseSAVE_API:data];
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


- (void)parseSAVE_API:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            NSMutableDictionary *pDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"status"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"Ok"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action){
                    [self scrollData_item];
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self alertMsg:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)scrollData_Category {

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_DITEM]];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:api]
            completionHandler:^(NSData *data,
                            NSURLResponse *response,
                            NSError *error) {
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
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            nsarray_idesc = [[NSMutableArray alloc]init];

            NSMutableArray *arrayResponse = [pDict objectForKey:@"idesc"];
            NSLog(@"222222222222 %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++) {
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                NSString *idesc = [dictObject objectForKey:@"idesc"];
                [nsarray_idesc addObject:idesc];
                [[BusyIndicator sharedInstance]stopIndicator];
            }
            [text_item setPlaceholder:@"Selet item"];
            Picker_itemname = [[UIPickerView alloc]init];
            Picker_itemname.dataSource = self;
            Picker_itemname.delegate = self;
            Picker_itemname.showsSelectionIndicator = YES;

            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            //    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
            numberToolbar.items = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                   nil];
            [numberToolbar setTintColor:[UIColor whiteColor]];
            numberToolbar.barTintColor = [UIColor colorWithRed:0.0/255.0f green:124.0/255.0f blue:195.0/255.0f alpha:1.0];
            [numberToolbar sizeToFit];
            numberToolbar.translucent=NO;
            text_item.inputView = Picker_itemname;
            text_item.inputAccessoryView = numberToolbar;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
}

-(void)cancelNumberPad{
    [text_item resignFirstResponder];
    text_item.text = @"";
}
-(IBAction)doneWithNumberPad{

    [text_item resignFirstResponder];
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if(pickerView ==Picker_itemname) {
        return [nsarray_idesc count];
    }
    return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    //return [arrayExecutive objectAtIndex:row];
    if(pickerView ==Picker_itemname) {
        return [nsarray_idesc objectAtIndex:row];
    }
    return 0;

}
#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    //     [myExecutiveText setText:[arrayExecutive objectAtIndex:row]];
    if(pickerView ==Picker_itemname) {
        [text_item setText:[nsarray_idesc objectAtIndex:row]];
        stridesc=[nsarray_idesc objectAtIndex:row];
    }
}


@end
