//
//  Reference.h
//  Dia Jewels
//
//  Created by MMI SOFTWARES PVT LTD on 12/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reference : BaseViewController
{
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextField *txt_interestedin;
    
    IBOutlet UIView *ContentView;
    IBOutlet UIButton *btn_register;
}

- (IBAction)btn_register:(id)sender;
@end

NS_ASSUME_NONNULL_END
