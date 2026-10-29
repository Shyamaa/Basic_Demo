//
//  HomeVC.m
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 07/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "HomeVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ProductGallery.h"
#import "AgentLogin.h"
#import "Aboutus.h"
#import "Contactus.h"
#import "Suggestion.h"
#import "Reference.h"
#import "RegisterVC.h"
#import "TodayBhav.h"
#import "HomeBannerCell.h"

#define MENUEWIDTH   250

@interface HomeVC ()<KIImagePagerDelegate, KIImagePagerDataSource>
{
    NSString *msg_mobile;
    IBOutlet KIImagePager *_imagePager;

}
@end

@implementation HomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
        [self setUpNavigationLogo];
    }else{
        // Set navigation title on the left side
        [self setNavigationTitleOnLeft:@"Sherpura Jewellers"];
    }
	NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
	lbl_welcome.text = [NSString stringWithFormat:@"Welcome %@",username];
    //[self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home568" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    [self.collectionView reloadData];

    NSLog(@"welcom home");
    [_imagePager setSlideshowTimeInterval:5.5];
    
    [self GET_ITEMSHOW];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollData_HOME];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollData_HOME {
   
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *category = @"-1";
    NSString *loginRequest=[NSString stringWithFormat:@"category=%@&appfrom=ios",category];
    NSLog(@"response :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_MAIN_URL]];
    
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
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
        }
    }] resume];
}


- (void) parseResponse_category:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
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
            array_bannerlist = [[NSMutableArray alloc]init];

            array_bannerlist = [pDict objectForKey:@"bannerlist"];
            NSLog(@"array_bannerlist :: %@",array_bannerlist);
            [_imagePager reloadData];

            NSMutableArray* arrayResponse = [pDict objectForKey:@"item"];
            NSLog(@"tg_master :: %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++)
            {
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                
                NSString *itemid = [dictObject objectForKey:@"itemid"];
                NSString *imgurl = [dictObject objectForKey:@"imgurl"];
                NSString *type = [dictObject objectForKey:@"type"];
                NSString *caption = [dictObject objectForKey:@"caption"];
                NSString *apppswrd = [dictObject objectForKey:@"apppswrd"];
                NSString *subid = [dictObject objectForKey:@"subid"];
                NSString *menutype = [dictObject objectForKey:@"menutype"];
                NSString *clickurl = [dictObject objectForKey:@"clickurl"];

                imgurl = [imgurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [nsarray_homeid addObject:itemid];
                [nsarray_image addObject:imgurl];
                [nsarray_type addObject:type];
                [nsarray_caption addObject:caption];
                [nsarray_apppassword addObject:apppswrd];
                [nsarray_subid addObject:subid];
                [nsarray_menutype addObject:menutype];
                [nsarray_clickurl addObject:clickurl];

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




#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _bannerCollectionView){
        return 2;
    }else{
        return [nsarray_image count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        HomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
//        NSString *str_url = [nsarray_bannerImage objectAtIndex:indexPath.row];
//        [bannerCell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:str_url]
//                              placeholderImage:[UIImage imageNamed:@"banner_Default.png"]
//                                       options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        //bannerCell.bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
        return bannerCell;
    }else{
        MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
        [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[nsarray_image objectAtIndex:indexPath.row]]
                              placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
        //cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgeDataArray.tag = indexPath.row;
        cell.imgeDataArray.contentMode = UIViewContentModeRedraw;
        cell.lblTitle.text=[nsarray_caption objectAtIndex:indexPath.row];
        cell.lblTitle.textColor = [UIColor blackColor];
        cell.title_view.backgroundColor = [UIColor whiteColor];
        cell.back_view.layer.borderColor = [UIColor colorNamed:@"border_Color"].CGColor;
        cell.back_view.layer.borderWidth = 1;
        cell.back_view.layer.cornerRadius = 5;
        switch ([UIDevice currentDevice].userInterfaceIdiom) {
            case UIUserInterfaceIdiomPad:
                cell.lblTitle.font = [UIFont systemFontOfSize:24.0];
                break;

            case UIUserInterfaceIdiomPhone:
                cell.lblTitle.font = [UIFont systemFontOfSize:16.0];
                break;

            default:
                cell.lblTitle.font = [UIFont systemFontOfSize:16.0];
                break;
        }
        //cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collectionView){
        NSString * str_type = [nsarray_type objectAtIndex:indexPath.row];
        NSString * str_apppassword = [nsarray_apppassword objectAtIndex:indexPath.row];
        NSString * str_clickurl = [nsarray_clickurl objectAtIndex:indexPath.row];
        NSString * str_caption = [nsarray_caption objectAtIndex:indexPath.row];
        NSString * str_itemid = [nsarray_homeid objectAtIndex:indexPath.row];
        
        NSLog(@"str_caption ::: %@ ",str_caption);
        NSLog(@"str_type ::: %@ ",str_type);

        if ([str_type isEqualToString:@"Login"])
        {
            if ([str_apppassword isEqualToString:@"0"] || str_apppassword.length == 0)
            {
                LoginVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                [self.navigationController pushViewController:obj animated:YES];
            }else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Current password";
                    textField.secureTextEntry = YES;
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Current password %@", [[alertController textFields][0] text]);
                    
                    NSString *str_text = [[alertController textFields][0] text];
                    if ([str_text isEqualToString:str_apppassword])
                    {
                        LoginVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                        [self.navigationController pushViewController:obj animated:YES];
                    }else
                    {
                        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                                      message:@"Please enter right password"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                    {}];
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
                [alertController addAction:confirmAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Canelled");
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else if([str_type isEqualToString:@"Product Gallery"]){
            ProductGallery *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
            obj.str_igroup = @"";
            [self.navigationController pushViewController:obj animated:YES];
        } else if([str_type isEqualToString:@"Agent Login"]){
            AgentLogin *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AgentLogin"];
            [self.navigationController pushViewController:obj animated:YES];
        }else if ([str_type isEqualToString:@"Login"]) {
            LoginVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if([str_type isEqualToString:@"About us"]){
            Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
            obj.str_type = str_type;
            obj.isSideMenu = false;
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if([str_type isEqualToString:@"Contact us"]){
            if (str_clickurl.length==0)
            {
                Contactus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
                obj.str_type = str_type;
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                obj.str_type = str_caption;
                obj.str_url = str_clickurl;
                [self.navigationController pushViewController:obj animated:YES];
            }
        }
        else if([str_type isEqualToString:@"Suggestions"]){
            Suggestion *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
            obj.str_type = @"Suggestion";
            [self.navigationController pushViewController:obj animated:YES];
        } else if([str_type isEqualToString:@"Why Membership"]){
            if (str_clickurl.length==0) {
                Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
                obj.str_type = str_type;
                obj.isSideMenu = false;
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                obj.str_type = str_caption;
                obj.str_url = str_clickurl;
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if([str_type isEqualToString:@"Why us"]){
            if (str_clickurl.length==0) {
                Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
                obj.str_type = str_type;
                obj.isSideMenu = false;
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                WebActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                obj.str_type = str_caption;
                obj.str_url = str_clickurl;
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if([str_type isEqualToString:@"Member Points"])
        {
            if (str_clickurl.length == 0)
            {
                Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
                obj.str_type = str_type;
                obj.isSideMenu = false;
                [self.navigationController pushViewController:obj animated:YES];
            }else {
                WebActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                obj.str_type = str_caption;
                obj.str_url = str_clickurl;
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if([str_type isEqualToString:@"Kitty"]){
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_caption;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Request Membership"]){
            RegisterVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Kitty Online"]){
            SubMenu *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SubMenu"];
            obj.itemid = str_itemid;
            obj.activity = str_type;
            [self.navigationController pushViewController:obj animated:YES];
        } else if([str_type isEqualToString:@"Today Rate"])
        {
            TodayBhav *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayBhav"];
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Shiping Policy"])
        {
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Cancellation Policy"])
        {
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Refund Policy"])
        {
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Privacy Policy"] || [str_type isEqualToString:@"Term And Condition"]){
            WebActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
            obj.str_type = str_type;
            obj.str_url = str_clickurl;
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Brochures"]){
            Brochures *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Brochures"];
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        return  CGSizeMake(self.bannerCollectionView.frame.size.width - 10, self.bannerCollectionView.frame.size.height - 10);
    }else{
        CGFloat width = (self.collectionView.frame.size.width - 45)/2;
        return CGSizeMake(width, width);
    }
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(2, 2, 2,2);
//}

#pragma mark - KIImagePager DataSource

- (NSMutableArray *)arrayWithImages:(KIImagePager *)pager {
    if (array_bannerlist && [array_bannerlist isKindOfClass:[NSArray class]]) {
        return [[array_bannerlist valueForKey:@"imgurl"] mutableCopy];
    } else {
        NSLog(@"array_bannerlist is nil or not an NSArray");
        return [NSMutableArray array];
    }
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager {
    return UIViewContentModeScaleToFill;
}

#pragma mark - KIImagePager Delegate

- (void)imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index {
    NSLog(@"Scrolled to Image at Index: %lu", (unsigned long)index);
}

- (void)imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"Selected Image at Index: %lu", (unsigned long)index);
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

@end
