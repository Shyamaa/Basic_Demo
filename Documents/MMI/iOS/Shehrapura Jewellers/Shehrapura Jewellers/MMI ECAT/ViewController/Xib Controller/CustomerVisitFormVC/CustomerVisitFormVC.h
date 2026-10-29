//
//  CustomerVisitFormVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 05/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CutomerDataDelegate <NSObject>

- (void)didFinishCustomerWithData:(NSData *)apiData customerData:(NSDictionary *)cdata;  // Delegate method to send data back

@end

@interface CustomerVisitFormVC : BaseViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<CutomerDataDelegate> delegate;
@property (nonatomic, weak) NSString *visid;
@property (nonatomic, strong) UIDatePicker *datePicker;

// Add any properties or methods you need here
@property (nonatomic, strong) IBOutlet UITextField *txtContactNo1;
@property (nonatomic, strong) IBOutlet UITextField *txtContactNo2;
@property (nonatomic, strong) IBOutlet UITextField *txtPartyName;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress1;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress2;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress3;
@property (nonatomic, strong) IBOutlet UITextField *txtLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtCity;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtDob;
@property (nonatomic, strong) IBOutlet UITextField *txtDoa;

@end

