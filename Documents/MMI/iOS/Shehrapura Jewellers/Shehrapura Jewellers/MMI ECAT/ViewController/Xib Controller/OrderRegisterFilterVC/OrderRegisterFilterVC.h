//
//  OrderRegisterFilterVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol FilterOrderRegisterDataDelegate <NSObject>

- (void)didFinishFilterOrderWithData:(NSData *)apiData customerData:(NSDictionary *)cdata;  // Delegate method to send data back
@end

@interface OrderRegisterFilterVC : BaseViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id<FilterOrderRegisterDataDelegate> delegate;
@property (nonatomic, strong) NSMutableArray * arrayDataItem;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pickerDataList;

// Add any properties or methods you need here
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *txtContact;
@property (nonatomic, strong) IBOutlet UITextField *txtStatus;
@property (nonatomic, strong) IBOutlet UITextField *txtSearchItem;
@property (nonatomic, strong) IBOutlet UITextField *txtStamp;
@property (nonatomic, strong) IBOutlet UITextField *txtParty;
@property (nonatomic, strong) IBOutlet UITextField *txtKarigar;
@property (nonatomic, strong) IBOutlet UITextField *txtWTFrom;
@property (nonatomic, strong) IBOutlet UITextField *txtWtTo;
@property (nonatomic, strong) IBOutlet UITextField *txtDateFrom;
@property (nonatomic, strong) IBOutlet UITextField *txtDateTo;
@end
