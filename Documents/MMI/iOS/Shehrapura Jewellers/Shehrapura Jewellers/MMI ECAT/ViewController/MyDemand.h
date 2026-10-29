//
//  MyDemand.h
//  RP Jewellers
//
//  Created by MMI SOFTWARES PVT LTD on 15/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopUp.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDemand : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,ClickDelegates>
{
    NSMutableArray *array_item;
    NSString *str_demid;
    NSString *str_flag;
    NSString * str_tsnolist;
    UIView *view1;
    
    UITextField *text_amtfrom;
    UITextField *text_amtto;
    UITextField *text_wtfrom;
    UITextField *text_wtto;
    UITextField *text_item;
    
    NSMutableArray *nsarray_idesc;

    NSInteger index;
    int myLastPressed;
    UIPickerView *Picker_itemname;
    NSString *stridesc;
    NSString *ino;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

NS_ASSUME_NONNULL_END
