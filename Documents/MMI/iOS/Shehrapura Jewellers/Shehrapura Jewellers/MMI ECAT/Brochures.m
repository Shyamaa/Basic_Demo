//
//  Brochures.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 03/12/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import "Brochures.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "UIImageView+WebCache.h"
#import "MyCell.h"
#import "imgfullVC.h"

@interface Brochures ()

@end

@implementation Brochures

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Brochures";
    if(_openWithSidMenu){
        [self setUpLeftMenuBtn];
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_brochures" bundle:nil] forCellWithReuseIdentifier:@"CELL"];

    self.collectionView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
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
    NSString *loginRequest=[NSString stringWithFormat:@"category=%@",category];
    NSLog(@"response :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GET_BROCHURES]];
    
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
            
            nsarray_brochuresid = [[NSMutableArray alloc]init];
            nsarray_name = [[NSMutableArray alloc]init];
            nsarray_imgurl = [[NSMutableArray alloc]init];
           
            NSMutableArray* arrayResponse = [pDict objectForKey:@"item"];
            NSLog(@"tg_master :: %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++) {
                
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                NSString *brochuresid = [dictObject objectForKey:@"brochuresid"];
                NSString *name = [dictObject objectForKey:@"name"];
                NSString *imgurl = [dictObject objectForKey:@"imgurl"];
          
                imgurl = [imgurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [nsarray_brochuresid addObject:brochuresid];
                [nsarray_name addObject:name];
                [nsarray_imgurl addObject:imgurl];
              
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
    
    return [nsarray_brochuresid count];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[nsarray_imgurl objectAtIndex:indexPath.row]]
                                 placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
           
   [cell.imgeDataArray setUserInteractionEnabled:YES];
   cell.imgeDataArray.tag = indexPath.row;
   cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFit;
   
   cell.lbl_counter.hidden=YES;
   cell.btn_addcart.hidden=YES;
   cell.lblTitle.text=[nsarray_name objectAtIndex:indexPath.row];
   cell.lblTitle.textAlignment=NSTextAlignmentCenter;
   cell.lbl_data.hidden=YES;
    
   cell.layoutMargins = UIEdgeInsetsZero;
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str_image = [nsarray_imgurl objectAtIndex:indexPath.row];
    
    imgfullVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = str_image;
    obj.str_img2 = @"";
    obj.str_img3 = @"";
    obj.str_img4 = @"";
    obj.str_img5 = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = self.collectionView.frame.size.width/2-3;
    return CGSizeMake(width, 300);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 2, 0,2);
}



@end
