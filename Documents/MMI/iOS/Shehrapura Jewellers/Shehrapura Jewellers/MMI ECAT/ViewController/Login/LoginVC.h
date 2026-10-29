//
//  ViewController.h
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 06/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmPin.h"
#import "BaseViewController.h"

@interface LoginVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
	
	IBOutlet UITextField *txt_mobile;
    __weak IBOutlet UITextField *txt_swid;
    IBOutlet UIButton *btn_login;
	IBOutlet UIButton *btn_countrycode;
    IBOutlet UIButton *btn_register;
    NSMutableArray *arrayResponse_data;
	
    UITableView *alertTableView;
    UIAlertController *alertController;
    
	NSString *str_countrycode;
    NSString *str_countryname;

}
@property (nonatomic, strong) NSArray *countryname; // Array to hold country codes
@property (nonatomic, strong) NSArray *countryCodes; // Array to hold country codes


- (IBAction)btn_login:(id)sender;
- (IBAction)btn_register:(id)sender;

@end

