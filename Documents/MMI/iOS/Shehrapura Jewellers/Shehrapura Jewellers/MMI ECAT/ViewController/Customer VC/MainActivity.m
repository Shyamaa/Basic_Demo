//
//  MainActivity.m
//  MMI ECAT
//
//  Created by mmsoft116 on 04/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "MainActivity.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ProductGallery.h"
#import "OrderList.h"
#import "Aboutus.h"
#import "Suggestion.h"
#import "HomeVC.h"
#import "MyDemand.h"
#import "OrderSoftware.h"
#import "Repair_class.h"
#import "Kitty_ledger.h"
#import "Member_pointActivity.h"
#import "Brochures.h"
#import "ProductGroup.h"
#import "ItemListActivity.h"
#import "CategoryListActivity.h"
#import "TodayBhav.h"
#import "RateBookVC.h"
#import "UserListActivity.h"
#import "AddDemand.h"
#import "AddBanner.h"
#import "NewRateBookVc.h"
#import "ProfileVC.h"
#import "CompanyDetailsVC.h"
#import "RegisterConfigureVC.h"
#import "AlertManagementListVC.h"
#import "ApprovalVC.h"
#import "FeedbackVC.h"
#import "OrderHistoryVC.h"
#import "AgentReportVC.h"

#define MENUEWIDTH   250

@interface MainActivity ()<KIImagePagerDelegate, KIImagePagerDataSource>
{
    IBOutlet KIImagePager *_imagePager;
    IBOutlet KIImagePager *_imagePager2;
    NSString *msg_mobile;
}

@end

@implementation MainActivity

#pragma mark: - Class Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sherpura Jewellers";
    msg_mobile = @"";
    self.navigationItem.hidesBackButton = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
     
     UIImage* image = [UIImage imageNamed:@"menu.png"];
     CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
     UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
     [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
     [someButton1 addTarget:revealController action:@selector(revealToggle:)
     forControlEvents:UIControlEventTouchUpInside];
     
     UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
     self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    self.navigationController.delegate = self;
    self.navigationController.navigationItem.hidesBackButton =YES;
    
    NSLog(@"Width ::::::::::::::::::::::: %f",self.view.frame.size.width);
    NSLog(@"Hight ::::::::::::::::::::::: %f",self.view.frame.size.height);
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    if([mobile isEqualToString:@"9627746628"])
    {
        UIButton *btn_account =  [UIButton buttonWithType:UIButtonTypeCustom];
        btn_account.frame = CGRectMake(0,0,30,30);
        [btn_account addTarget:self action:@selector(btn_account) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn_account setBackgroundImage:image forState:UIControlStateNormal];
        
        UIBarButtonItem *btndelete = [[UIBarButtonItem alloc] initWithCustomView:btn_account];
        btndelete.tintColor = [UIColor whiteColor];
        //self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:btndelete, nil];
    }
    
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text=[NSString stringWithFormat:@"Welcome %@",username];
    
    //[self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home568" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    
    //    self.collectionView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    //    self.collectionView.alwaysBounceVertical = NO;
    //    self.collectionView.bounces = NO;
    //    [self.view addSubview:self.collectionView];
    //    [self.collectionView reloadData];
    
    //    UIButton *btn_call = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn_call addTarget:self
    //               action:@selector(btn_call:)
    //     forControlEvents:UIControlEventTouchDown];
    //    [btn_call setBackgroundImage:[UIImage imageNamed:@"ic_call.png"]
    //                      forState:UIControlStateNormal];
    //    btn_call.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-100, 40.0, 40.0);
    //    [self.view addSubview:btn_call];
    //
    //    UIButton *btn_whatsapp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn_whatsapp addTarget:self
    //               action:@selector(btn_whatsapp:)
    //     forControlEvents:UIControlEventTouchDown];
    //    [btn_whatsapp setBackgroundImage:[UIImage imageNamed:@"whatsapp.png"]
    //                      forState:UIControlStateNormal];
    //    btn_whatsapp.frame = CGRectMake(self.view.frame.size.width-55, self.view.frame.size.height-170, 50.0, 50.0);
    //    [self.view addSubview:btn_whatsapp];
    
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 5.5f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    [self GET_USER];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

#pragma mark: - Navigation Button Action

-(void)btn_account{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do You Want Delete Account?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        HomeVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark:- Button Action Method

- (IBAction)btn_call:(id)sender{
    msg_mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *str_mobile1 =  [NSString stringWithFormat:@"+91%@",msg_mobile];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:str_mobile1];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:nil];
}

- (IBAction)btn_whatsapp:(id)sender{
    msg_mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    /*
    NSString *str_mobile1 =  [NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=+91%@&text=",msg_mobile];
    NSString *str_mobile =  [NSString stringWithFormat:@"whatsapp://send?phone=+91%@&text=",msg_mobile];
    NSURL *whatsappURL = [NSURL URLWithString:str_mobile1];
    NSURL *whatsappBusinessURL = [NSURL URLWithString:str_mobile];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:whatsappBusinessURL]) {
        [[UIApplication sharedApplication] openURL:whatsappBusinessURL options:@{} completionHandler:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"WhatsApp nor WhatsApp Business is installed on this device" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    */
    [self shareOnWhatsApp:@"" phone:msg_mobile]; // For Both option show
}

#pragma mark:- Bottom TabBar Button Action Method

- (IBAction)bottomTabAction:(UIButton *)sender{
    if (sender.tag == 1){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = @"About us";
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else if (sender.tag == 2){
        Contactus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
        obj.str_type = @"Contact us";
        
        [self.navigationController pushViewController:obj animated:YES];
    }else if (sender.tag == 3){
        ProfileVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.frame.size.width - 30)/2;
    return CGSizeMake(width, 160);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [nsarray_image count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[nsarray_image objectAtIndex:indexPath.row]]
                          placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
    cell.imgeDataArray.tag = indexPath.row;
    cell.lblTitle.text = [nsarray_caption objectAtIndex:indexPath.row];
    cell.back_view.layer.borderColor = [UIColor colorNamed:@"border_Color"].CGColor;
    cell.back_view.layer.borderWidth = 1;
    cell.back_view.layer.cornerRadius = 5;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str_type=[nsarray_type objectAtIndex:indexPath.row];
    NSString * str_clickurl = [nsarray_clickurl objectAtIndex:indexPath.row];
    NSString * str_itemid = [nsarray_homeid objectAtIndex:indexPath.row];
    NSLog(@"str_type = %@",str_type);
    if ([str_type isEqualToString:@"Login"]) {
        LoginVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Product Gallery"]){
        if (str_clickurl.length == 0) {
            ProductGallery *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
            obj.str_igroup =@"";
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }else if([str_type isEqualToString:@"Product Group"]){
        if (str_clickurl.length == 0){
            ProductGroup *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGroup"];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }else if([str_type isEqualToString:@"Company Details"]){
        CompanyDetailsVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyDetailsVC"];
        obj.isOpenFromHome = true;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Admin Order Management"]){
        OrderHistoryVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Order Management"]){
        OrderList *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"About us"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = str_type;
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Suggestions"]){
        Suggestion *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
        obj.str_type = @"Suggestion";
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Logout"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want logout?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            HomeVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            [self.navigationController pushViewController:obj animated:YES];
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if([str_type isEqualToString:@"My Demand"]){
        MyDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDemand"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"About us"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = str_type;
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Contact us"]){
        if (str_clickurl.length == 0) {
            Contactus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
            obj.str_type = str_type;
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }else if([str_type isEqualToString:@"Why Membership"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = str_type;
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Why us"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = str_type;
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Reference"]){
        Reference *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Reference"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Suggestion"]){
        Suggestion *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
        obj.str_type = @"Suggestion";
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Alerts"]){
        NotificationVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Kitty"]){
        if (str_clickurl.length == 0) {
            Kitty_ledger *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Kitty_ledger"];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }else if([str_type isEqualToString:@"Member Points"]){
        if (str_clickurl.length == 0)
        {
            Member_pointActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Member_pointActivity"];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }else if([str_type isEqualToString:@"Coupan"]){
        WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
        obj.str_type = str_type;
        obj.str_url = str_clickurl;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Order"]){
        OrderSoftware *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderSoftware"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Repair"]){
        Repair_class *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Repair_class"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Brochures"]){
        Brochures *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Brochures"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Kitty Online"]){
        SubMenu *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SubMenu"];
        obj.itemid = str_itemid;
        obj.activity = str_type;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Bank Detail"]){
        BankDetail *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"BankDetail"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Add Item"]){
        CategoryListActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Add Design"]){
        ItemListActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Today Rate"]){
        TodayBhav *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"TodayBhav"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Shipping Policy"]){
        WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
        obj.str_type = str_type;
        obj.str_url = str_clickurl;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Cancellation Policy"]){
        WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
        obj.str_type = str_type;
        obj.str_url = str_clickurl;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Refund Policy"]){
        WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
        obj.str_type = str_type;
        obj.str_url = str_clickurl;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Privacy Policy"]){
        WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
        obj.str_type = str_type;
        obj.str_url = str_clickurl;
        [self.navigationController pushViewController:obj animated:YES];
    }
    //    else if([str_type isEqualToString:@"Rate Book"]){
    //        RateBookVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"RateBookVC"];
    //        [self.navigationController pushViewController:obj animated:YES];
    //    }
    else if([str_type isEqualToString:@"User Updation Entry"]){
        UserListActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"UserListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Add Your Demand"]){
        AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if([str_type isEqualToString:@"Add Banner"]){
        AddBanner *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBanner"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Draw"] || [str_type isEqualToString:@"Incentive"] || [str_type isEqualToString:@"Rate Book"] || [str_type isEqualToString:@"Digital Gold"] || [str_type isEqualToString:@"Incentive Lumsum"] || [str_type isEqualToString:@"Incentive/Bonus"])
    {
        NSString * str_groupid = [array_groupid objectAtIndex:indexPath.row];
        NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
        
        NewRateBookVc *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRateBookVc"];
        obj.strKittyType = str_type;
        obj.str_groupid = str_groupid;
        obj.str_activity = @"Rate Book";
        obj.str_mobile = mobile;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Kitty Customer"]){
        NewRateBookVc *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRateBookVc"];
        obj.strKittyType = @"0";
        obj.str_groupid = @"0";
        obj.str_activity = @"Kitty Customer";
        obj.str_mobile = @"";
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Register Config"]){
        RegisterConfigureVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterConfigureVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Alert Management"]){
        AlertManagementListVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertManagementListVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Approval"]){
        ApprovalVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ApprovalVC"];
        //obj.isOpenFromHome = true;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Customers Query & Feedback"]){
        FeedbackVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackVC"];
        //obj.isOpenFromHome = true;
        [self.navigationController pushViewController:obj animated:YES];
    }else if([str_type isEqualToString:@"Agent Report"]){
        AgentReportVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AgentReportVC"];
        [self.navigationController pushViewController:obj animated:YES];
    }
}


#pragma mark:- Api Methods

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *loginRequest = [NSString stringWithFormat:@"category=%@&mobile=%@&userid=%@&itemid=%@",category,mobile,userid,@"0"];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat: @"%@", [WEB_URL URL_HOME]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
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
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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
            
            nsarray_homeid = [[NSMutableArray alloc]init];
            nsarray_image = [[NSMutableArray alloc]init];
            nsarray_type = [[NSMutableArray alloc]init];
            nsarray_caption = [[NSMutableArray alloc]init];
            nsarray_subid = [[NSMutableArray alloc]init];
            nsarray_menutype = [[NSMutableArray alloc]init];
            nsarray_clickurl = [[NSMutableArray alloc]init];
            array_groupid = [[NSMutableArray alloc]init];
            
            array_bannerlist = [pDict objectForKey:@"bannerlist"];
            [_imagePager reloadData];
            
            NSMutableArray *arrayResponse = [pDict objectForKey:@"item"];
            
            for (int i = 0; i < [arrayResponse count]; i++)
            {
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                NSString *itemid = [dictObject objectForKey:@"itemid"];
                NSString *imgurl = [dictObject objectForKey:@"imgurl"];
                NSString *type = [dictObject objectForKey:@"type"];
                NSString *caption = [dictObject objectForKey:@"caption"];
                NSString *subid = [dictObject objectForKey:@"subid"];
                NSString *menutype = [dictObject objectForKey:@"menutype"];
                NSString *clickurl = [dictObject objectForKey:@"clickurl"];
                NSString *groupid = [dictObject objectForKey:@"groupid"];
                
                imgurl = [imgurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [nsarray_homeid addObject:itemid];
                [nsarray_image addObject:imgurl];
                [nsarray_type addObject:type];
                [nsarray_caption addObject:caption];
                [nsarray_subid addObject:subid];
                [nsarray_menutype addObject:menutype];
                [nsarray_clickurl addObject:clickurl];
                [array_groupid addObject:groupid];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)GET_USER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *loginRequest = [NSString stringWithFormat:@"mobile=%@", mobile];
    NSData *data1 = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[WEB_URL URL_USERDETAIL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (data.length > 0 && !error) {
                [self parseLogin_Api:data];
            } else if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Empty Response");
            }
        });
    }] resume];
    
}

- (void)parseLogin_Api:(NSData *) data {
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
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSLog(@"pDict ::::::::::::::: %@",pDict);
            NSMutableArray *array_success = [pDict objectForKey:@"success"];
            NSString *str_success = [array_success description];
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"])
            {
                NSMutableArray *nsarray_loginid = [pDict objectForKey:@"loginid"];
                NSString *str_loginid = [nsarray_loginid description];
                NSMutableArray*nsarray_username = [pDict objectForKey:@"username"];
                NSString *str_username = [nsarray_username description];
                NSMutableArray*nsarray_mobile = [pDict objectForKey:@"mobile"];
                NSString *str_mobile = [nsarray_mobile description];
                NSMutableArray *nsarray_category = [pDict objectForKey:@"category"];
                category = [nsarray_category description];
                NSMutableArray *nsarray_mdob = [pDict objectForKey:@"mdob"];
                NSString *mdob = [nsarray_mdob description];
                NSMutableArray *nsarray_spousename = [pDict objectForKey:@"spousename"];
                NSString *spousename = [nsarray_spousename description];
                NSMutableArray *ns_sdob = [pDict objectForKey:@"sdob"];
                NSString *sdob = [ns_sdob description];
                NSMutableArray *ns_anniversary = [pDict objectForKey:@"anniversary"];
                NSString *anniversary = [ns_anniversary description];
                NSMutableArray *nsarray_address = [pDict objectForKey:@"address"];
                NSString *address = [nsarray_address description];
                NSMutableArray *nsarray_sprofile = [pDict objectForKey:@"profile"];
                NSString *profile = [nsarray_sprofile description];
                NSMutableArray *nsarray_firmname = [pDict objectForKey:@"firmname"];
                NSString *firmname = [nsarray_firmname description];
                NSMutableArray *nsarray_landno = [pDict objectForKey:@"landno"];
                NSString *landno = [nsarray_landno description];
                NSMutableArray *ns_area = [pDict objectForKey:@"area"];
                NSString *area = [ns_area description];
                NSMutableArray *nsarray_closingdate = [pDict objectForKey:@"closingdate"];
                NSString *closingdate = [nsarray_closingdate description];
                NSMutableArray *nsarray_orderdelete = [pDict objectForKey:@"orderdelete"];
                NSString *orderdelete = [nsarray_orderdelete description];
                NSMutableArray *nsarray_profiledisplay = [pDict objectForKey:@"profiledisplay"];
                NSString *profiledisplay = [nsarray_profiledisplay description];
                NSMutableArray *ns_emailid= [pDict objectForKey:@"emailid"];
                NSString *emailid = [ns_emailid description];
                NSMutableArray *nsarray_branchid = [pDict objectForKey:@"branchid"];
                NSString *branchid = [nsarray_branchid description];
                
                [[NSUserDefaults standardUserDefaults] setObject:str_loginid forKey:@"loginid"];
                [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:category forKey:@"category"];
                [[NSUserDefaults standardUserDefaults] setObject:mdob forKey:@"mdob"];
                [[NSUserDefaults standardUserDefaults] setObject:spousename forKey:@"spousename"];
                [[NSUserDefaults standardUserDefaults] setObject:sdob forKey:@"sdob"];
                [[NSUserDefaults standardUserDefaults] setObject:anniversary forKey:@"anniversary"];
                [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] setObject:profile forKey:@"profile"];
                [[NSUserDefaults standardUserDefaults] setObject:firmname forKey:@"firmname"];
                [[NSUserDefaults standardUserDefaults] setObject:landno forKey:@"landno"];
                [[NSUserDefaults standardUserDefaults] setObject:area forKey:@"area"];
                [[NSUserDefaults standardUserDefaults] setObject:closingdate forKey:@"closingdate"];
                [[NSUserDefaults standardUserDefaults] setObject:orderdelete forKey:@"orderdelete"];
                [[NSUserDefaults standardUserDefaults] setObject:profiledisplay forKey:@"profiledisplay"];
                [[NSUserDefaults standardUserDefaults] setObject:emailid forKey:@"emailid"];
                [[NSUserDefaults standardUserDefaults] setObject:branchid forKey:@"branchid"];
                
                if ([category isEqualToString:@"Not any category"])
                {
                    [self scrollData_Category];
                } else {
                    [self scrollData_Category];
                    [self GET_ITEMSHOW];
                }
            } else {
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
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

-(void)GET_ITEMSHOW {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSData *bodyData = [[NSString stringWithFormat:@"mobile=%@&apptype=3&apptype_4=3", mobile] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[WEB_URL URL_ITEMSHOW]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (data.length > 0 && !error) {
                [self parseLogin_showapi:data];
            } else {
                NSLog(@"%@", error ? [NSString stringWithFormat:@"Error: %@", error] : @"Empty Response, not sure why?");
            }
        });
    }] resume];
}


- (void)parseLogin_showapi:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON_data = %@", myData);
        
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
            
            NSLog(@"pDict ::::::::::::::: %@",pDict);
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            NSMutableArray *ns_cus_details = [pDict objectForKey:@"cus_details"];
            NSString *cus_details = [ns_cus_details description];
            NSMutableArray *ns_msg_mobile = [pDict objectForKey:@"com_mobile"];
            msg_mobile = [ns_msg_mobile description];
            NSLog(@"msg_mobile ::::::::::::::::  %@",msg_mobile);
            
            NSMutableArray *ns_vist_reason = [pDict objectForKey:@"vist_reason"];
            NSString *vist_reason = [ns_vist_reason description];
            NSMutableArray *ns_qty = [pDict objectForKey:@"qty"];
            NSString *qty = [ns_qty description];
            NSMutableArray*ns_rgap = [pDict objectForKey:@"rgap"];
            NSString * rgap = [ns_rgap description];
            NSMutableArray *ns_chqty = [pDict objectForKey:@"chqty"];
            NSString *chqty = [ns_chqty description];
            NSMutableArray *ns_sorder = [pDict objectForKey:@"sorder"];
            NSString *sorder = [ns_sorder description];
            NSMutableArray *ns_interested = [pDict objectForKey:@"interested"];
            NSString *interested = [ns_interested description];
            NSMutableArray *ns_addyourdemand = [pDict objectForKey:@"addyourdemand"];
            NSString *addyourdemand = [ns_addyourdemand description];
            NSMutableArray *ns_wtgap = [pDict objectForKey:@"wtgap"];
            NSString *wtgap = [ns_wtgap description];
            NSMutableArray *ns_wtdec = [pDict objectForKey:@"wtdec"];
            NSString *wtdec = [ns_wtdec description];
            NSMutableArray *ns_printer = [pDict objectForKey:@"printer"];
            NSString *printer = [ns_printer description];
            NSMutableArray *ns_aprval_stk = [pDict objectForKey:@"aprval_stk"];
            NSString *aprval_stk = [ns_aprval_stk description];
            NSMutableArray *ns_tgstatus = [pDict objectForKey:@"tgstatus"];
            NSString *tgstatus = [ns_tgstatus description];
            
            NSMutableArray *ns_status = [pDict objectForKey:@"status"];
            NSString *status = [ns_status description];
            
            NSMutableArray *ns_instk = [pDict objectForKey:@"instk"];
            NSString *instk = [ns_instk description];
            NSMutableArray *ns_outstk = [pDict objectForKey:@"outstk"];
            NSString *outstk = [ns_outstk description];
            NSMutableArray *ns_disrate = [pDict objectForKey:@"disrate"];
            NSString *disrate = [ns_disrate description];
            NSMutableArray *ns_itemlist = [pDict objectForKey:@"itemlist"];
            NSString *itemlist = [ns_itemlist description];
            NSMutableArray *ns_m_id = [pDict objectForKey:@"m_id"];
            NSString *m_id = [ns_m_id description];
            NSMutableArray *nsTemplate = [pDict objectForKey:@"template"];
            NSString *strTemplate = [nsTemplate description];
            
            [[NSUserDefaults standardUserDefaults] setObject:cus_details forKey:@"cus_details"];
            [[NSUserDefaults standardUserDefaults] setObject:vist_reason forKey:@"vist_reason"];
            [[NSUserDefaults standardUserDefaults] setObject:qty forKey:@"qty"];
            [[NSUserDefaults standardUserDefaults] setObject:rgap forKey:@"rgap"];
            [[NSUserDefaults standardUserDefaults] setObject:chqty forKey:@"chqty"];
            [[NSUserDefaults standardUserDefaults] setObject:sorder forKey:@"sorder"];
            [[NSUserDefaults standardUserDefaults] setObject:interested forKey:@"interested"];
            [[NSUserDefaults standardUserDefaults] setObject:addyourdemand forKey:@"addyourdemand"];
            [[NSUserDefaults standardUserDefaults] setObject:wtgap forKey:@"wtgap"];
            [[NSUserDefaults standardUserDefaults] setObject:wtdec forKey:@"wtdec"];
            [[NSUserDefaults standardUserDefaults] setObject:printer forKey:@"printer"];
            [[NSUserDefaults standardUserDefaults] setObject:tgstatus forKey:@"tgstatus"];
            [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"status"];
            [[NSUserDefaults standardUserDefaults] setObject:instk forKey:@"instk"];
            [[NSUserDefaults standardUserDefaults] setObject:outstk forKey:@"outstk"];
            [[NSUserDefaults standardUserDefaults] setObject:disrate forKey:@"disrate"];
            [[NSUserDefaults standardUserDefaults] setObject:itemlist forKey:@"itemlist"];
            [[NSUserDefaults standardUserDefaults] setObject:m_id forKey:@"m_id"];
            [[NSUserDefaults standardUserDefaults] setObject:strTemplate forKey:@"template"];
            [[NSUserDefaults standardUserDefaults] setObject:aprval_stk forKey:@"aprval_stk"];
            
            if ([str_success isEqualToString:@"1"])
            {
                NSMutableArray *ns_item1 = [pDict objectForKey:@"item1"];
                NSString *item1 = [ns_item1 description];
                NSMutableArray *ns_item2 = [pDict objectForKey:@"item2"];
                NSString *item2 = [ns_item2 description];
                NSMutableArray *ns_item3 = [pDict objectForKey:@"item3"];
                NSString *item3 = [ns_item3 description];
                NSMutableArray *ns_item4 = [pDict objectForKey:@"item4"];
                NSString *item4 = [ns_item4 description];
                NSMutableArray *ns_item5 = [pDict objectForKey:@"item5"];
                NSString *item5 = [ns_item5 description];
                NSMutableArray *ns_item6 = [pDict objectForKey:@"item6"];
                NSString *item6 = [ns_item6 description];
                NSMutableArray *ns_idesc = [pDict objectForKey:@"idesc"];
                NSString *idesc = [ns_idesc description];
                NSMutableArray *ns_tgno = [pDict objectForKey:@"tgno"];
                NSString *tgno = [ns_tgno description];
                NSMutableArray *ns_gwt = [pDict objectForKey:@"gwt"];
                NSString *gwt = [ns_gwt description];
                NSMutableArray *ns_wt = [pDict objectForKey:@"wt"];
                NSString *wt = [ns_wt description];
                NSMutableArray *ns_sdiwt = [pDict objectForKey:@"sdiwt"];
                NSString *sdiwt = [ns_sdiwt description];
                NSMutableArray *ns_sstnwt = [pDict objectForKey:@"sstnwt"];
                NSString *sstnwt = [ns_sstnwt description];
                NSMutableArray *ns_stamp = [pDict objectForKey:@"stamp"];
                NSString *stamp = [ns_stamp description];
                NSMutableArray *ns_mrp = [pDict objectForKey:@"mrp"];
                NSString *mrp = [ns_mrp description];
                NSMutableArray *ns_gst = [pDict objectForKey:@"gst"];
                NSString *gst = [ns_gst description];
                NSMutableArray *ns_remarks = [pDict objectForKey:@"remarks"];
                NSString *remarks = [ns_remarks description];
                
                [[NSUserDefaults standardUserDefaults] setObject:idesc forKey:@"adddesign_idesc"];
                [[NSUserDefaults standardUserDefaults] setObject:tgno forKey:@"adddesign_tgno"];
                [[NSUserDefaults standardUserDefaults] setObject:gwt forKey:@"adddesign_gwt"];
                [[NSUserDefaults standardUserDefaults] setObject:wt forKey:@"adddesign_wt"];
                [[NSUserDefaults standardUserDefaults] setObject:sdiwt forKey:@"adddesign_sdiwt"];
                [[NSUserDefaults standardUserDefaults] setObject:sstnwt forKey:@"adddesign_sstnwt"];
                [[NSUserDefaults standardUserDefaults] setObject:stamp forKey:@"adddesign_stamp"];
                [[NSUserDefaults standardUserDefaults] setObject:mrp forKey:@"adddesign_mrp"];
                [[NSUserDefaults standardUserDefaults] setObject:gst forKey:@"adddesign_gst"];
                [[NSUserDefaults standardUserDefaults] setObject:remarks forKey:@"adddesign_remarks"];
                [[NSUserDefaults standardUserDefaults] setObject:item1 forKey:@"item1"];
                [[NSUserDefaults standardUserDefaults] setObject:item2 forKey:@"item2"];
                [[NSUserDefaults standardUserDefaults] setObject:item3 forKey:@"item3"];
                [[NSUserDefaults standardUserDefaults] setObject:item4 forKey:@"item4"];
                [[NSUserDefaults standardUserDefaults] setObject:item5 forKey:@"item5"];
                [[NSUserDefaults standardUserDefaults] setObject:item6 forKey:@"item6"];
                
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg preferredStyle:UIAlertControllerStyleAlert];
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


#pragma mark - KIImagePager DataSource

- (NSMutableArray *)arrayWithImages:(KIImagePager *)pager {
    if (array_bannerlist && [array_bannerlist isKindOfClass:[NSArray class]]) {
        return [[array_bannerlist valueForKey:@"imgurl"] mutableCopy];
    } else {
        NSLog(@"array_bannerlist is nil or not an NSArray");
        return [NSMutableArray array];
    }
}

-(UIImage *)placeHolderImageForImagePager:(KIImagePager *)pager{
    return [UIImage imageNamed:@"banner_Default"];
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager {
    return UIViewContentModeScaleAspectFill;
}

#pragma mark - KIImagePager Delegate

- (void)imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index {
    NSLog(@"Scrolled to Image at Index: %lu", (unsigned long)index);
}

- (void)imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"Selected Image at Index: %lu", (unsigned long)index);
    //array_bannerlist
    NSString *str_url = [[array_bannerlist valueForKey:@"imgurl"] objectAtIndex:index];
    str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = str_url;
    obj.str_img2 = @"";
    obj.str_img3 = @"";
    obj.str_img4 = @"";
    obj.str_img5 = @"";
    [self.navigationController pushViewController:obj animated:YES];
}
@end
