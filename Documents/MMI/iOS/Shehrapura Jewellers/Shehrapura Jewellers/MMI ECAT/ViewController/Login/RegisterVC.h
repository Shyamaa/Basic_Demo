//
//  RegisterVC.h
//  AirMobileShop
//
//  Created by Suresh Soni on 09/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListDataSource.h"
#import "CountryCell.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextField *txt_Email;
    IBOutlet UITextField *txt_FirmName;
    IBOutlet UITextField *txt_Address;
    IBOutlet UITextField *txt_GstIn;
    IBOutlet UITextField *txt_Pancard;
    IBOutlet UITextField *txt_interestedin;
    
    IBOutlet UIButton *btn_countrycode;

    IBOutlet UIView *ContentView;
    IBOutlet UIButton *btn_register;
    
    IBOutlet UIStackView *emailIdStackView;
    IBOutlet UIStackView *firmNameStackView;
    IBOutlet UIStackView *addressStackView;
    IBOutlet UIStackView *gstInStackView;
    IBOutlet UIStackView *panCardStackView;
    IBOutlet UIStackView *interestedInStackView;
    
    UITableView *alertTableView;
    UIAlertController *alertController;
    
    NSString *str_countrycode;
    NSString *str_countryname;
}
@property (nonatomic, retain) NSString *str_mobile;
@property (nonatomic, retain) NSString *str_ccode;
@property (nonatomic, retain) NSString *str_cname;

@property (nonatomic, strong) NSArray *countryname; // Array to hold country codes
@property (nonatomic, strong) NSArray *countryCodes; // Array to hold country codes


- (IBAction)btn_country:(id)sender;

- (IBAction)btn_register:(id)sender;
- (IBAction)btn_login:(id)sender;

@end

NS_ASSUME_NONNULL_END
