//
//  SubMenu.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 25/02/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "SubMenu.h"
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

#define MENUEWIDTH   250

@interface SubMenu ()

@end

@implementation SubMenu
@synthesize itemid,activity;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title = activity;
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text=[NSString stringWithFormat:@"Welcome %@",username];
    NSLog(@"Width ::::::::::::::::::::::: %f",self.view.frame.size.width);
    NSLog(@"Hight ::::::::::::::::::::::: %f",self.view.frame.size.height);
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home" bundle:nil] forCellWithReuseIdentifier:@"CELL"];

    self.collectionView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];

    NSLog(@"welcom home");
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

    NSString *category=@"-1";
    NSString *loginRequest=[NSString stringWithFormat:@"category=%@&itemid=%@",category,itemid];
    NSLog(@"response :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_HOME]];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
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
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
        }
    }] resume];
}


- (void) parseResponse_category:(NSData *) data {
    @try {
        
        ////////////// End processs load view
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
            
            nsarray_homeid = [[NSMutableArray alloc]init];
            nsarray_image = [[NSMutableArray alloc]init];
            nsarray_type = [[NSMutableArray alloc]init];
            nsarray_caption = [[NSMutableArray alloc]init];
            nsarray_subid = [[NSMutableArray alloc]init];
            nsarray_menutype = [[NSMutableArray alloc]init];
            nsarray_clickurl = [[NSMutableArray alloc]init];

            NSMutableArray* arrayResponse = [pDict objectForKey:@"item"];
            NSLog(@"tg_master :: %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++) {
                
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [nsarray_image count];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[nsarray_image objectAtIndex:indexPath.row]]
                                 placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
           
   [cell.imgeDataArray setUserInteractionEnabled:YES];
   cell.imgeDataArray.tag = indexPath.row;
   cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFit;
   
   cell.lbl_counter.hidden=YES;
   cell.btn_addcart.hidden=YES;
   cell.lblTitle.text=[nsarray_caption objectAtIndex:indexPath.row];
   cell.lblTitle.textAlignment=NSTextAlignmentCenter;
   cell.lbl_data.hidden=YES;
    
   cell.layoutMargins = UIEdgeInsetsZero;
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str_type=[nsarray_type objectAtIndex:indexPath.row];
    NSString * str_apppassword = [nsarray_apppassword objectAtIndex:indexPath.row];
    NSString * str_clickurl = [nsarray_clickurl objectAtIndex:indexPath.row];
    NSString * str_caption = [nsarray_caption objectAtIndex:indexPath.row];

    WebActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
    obj.str_type = str_caption;
    obj.str_url = str_clickurl;
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = self.collectionView.frame.size.width/2-3;
    return CGSizeMake(width, 140);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 2, 0,2);
}

@end
