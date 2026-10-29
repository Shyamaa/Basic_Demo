//
//  OrderDetailsInfo.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 04/10/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "OrderDetailsInfo.h"
#import "imgfullVC.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OrderDetailsInfo

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Item Detail";
    [self setUpOrderData];
}

-(void)setUpOrderData{
    if(_dicItemData){
        NSLog(@"Order Details : %@", _dicItemData);
        lblOrderId.text = [NSString stringWithFormat:@"Order NO : %@",[_dicItemData valueForKey:@"orderno"]];
        lblItemName.text = [NSString stringWithFormat:@"Item Name : %@",[_dicItemData valueForKey:@"item_idesc"]];
        lblQuantity.text = [NSString stringWithFormat:@"Quantity : %@",[_dicItemData valueForKey:@"item_qty"]];
        
        NSURL *URL;
        URL = [NSURL URLWithString:[_dicItemData valueForKey:@"imgname"]];
        NSString *myString = [URL absoluteString];
        [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        [imgItemImage sd_setImageWithURL:[NSURL URLWithString:myString]
                        placeholderImage:[UIImage imageNamed:@"1024.png"] options: SDWebImageRefreshCached];
        
        lblOrderDate.text = [NSString stringWithFormat:@"Order Date : %@",[_dicItemData valueForKey:@"item_date"]];
        lblDueDate.text = [NSString stringWithFormat:@"Due Date : %@",[_dicItemData valueForKey:@"duedate"]];
        lblStatus.text = [NSString stringWithFormat:@"Status : %@",[_dicItemData valueForKey:@"status"]];
    }
}

- (IBAction)btnImgFull:(UIButton *)sender {
    imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = [_dicItemData valueForKey:@"imgname"];
    obj.str_img2 = [_dicItemData valueForKey:@"imgnameA"];
    obj.str_img3 = [_dicItemData valueForKey:@"imgnameB"];
    obj.str_img4 = [_dicItemData valueForKey:@"imgnameC"];
    obj.str_img5 = @"";//[_dicItemData valueForKey:@"imgname"];
    [self.navigationController pushViewController:obj animated:YES];
}

@end

NS_ASSUME_NONNULL_END
