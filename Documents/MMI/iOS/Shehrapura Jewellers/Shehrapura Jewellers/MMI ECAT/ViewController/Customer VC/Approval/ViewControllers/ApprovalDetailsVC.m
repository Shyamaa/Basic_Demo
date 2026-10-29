//
//  ApprovalDetailsVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 20/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalDetailsVC.h"
#import "ApprovalProductListVC.h"

@implementation ApprovalDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Pending Approval";
    
    // Setup date pickers for date fields
    [self setupDatePickerForTextField:txtDateFrom];
    [self setupDatePickerForTextField:txtDateTo];
    
    // Disable editing for some fields
    [self makeFieldsReadOnly];
    
    // Fetch and load customer data from server
    [self apiGetCustomerData];
}

#pragma mark - UI Setup

- (void)makeFieldsReadOnly {
    NSArray<UITextField *> *textFields = @[txtCustomer, txtItem, txtCategory];
    for (UITextField *tf in textFields) {
        tf.enabled = NO;
        tf.backgroundColor = [UIColor colorNamed:@"border_Color"];
    }
}

- (void)setData {
    txtCustomer.text    = self.approvalDetail.username ?: @"";
    txtItem.text        = self.approvalDetail.ino ?: @"";
    txtCategory.text    = @""; // Update if you have category data in model
    txtWeight_From.text = self.approvalDetail.wtf ?: @"";
    txtWeight_To.text   = self.approvalDetail.wtt ?: @"";
    txtAmount_From.text = self.approvalDetail.amtf ?: @"";
    txtAmount_To.text   = self.approvalDetail.amtt ?: @"";
    txtRemark.text      = @""; // Update if remarks exist
    txtDateFrom.text    = self.approvalDetail.dtimef ?: @"";
    txtDateTo.text      = self.approvalDetail.dtimet ?: @"";
    txtHours.text       = self.approvalDetail.hours ?: @"";
}

#pragma mark - Actions

- (IBAction)btnOKAction:(id)sender {
    // Prepare parameters dictionary using modern Objective-C literals
    NSMutableDictionary *params = [@{
        @"ino": self.approvalDetail.ino ?: @"",
        @"wtt": txtWeight_To.text ?: @"",
        @"wtf": txtWeight_From.text ?: @"",
        @"amtf": txtAmount_From.text ?: @"",
        @"amtt": txtAmount_To.text ?: @"",
        @"dfrom": txtDateFrom.text ?: @"",
        @"dto": txtDateTo.text ?: @"",
        @"hour": txtHours.text ?: @"",
        @"mobile": [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"] ?: @"",
        @"id": _approvalItem.demid ?: @"",
        @"act": @"form"
    } mutableCopy];

    // Initialize and push next view controller with parameters
    ApprovalProductListVC *vc = [[ApprovalProductListVC alloc] init];
    vc.filterParams = params;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API Calls

- (void)apiGetCustomerData {
    NSString *demid = _approvalItem.demid;
    if (!demid || demid.length == 0) {
        [self alertMsg:@"Invalid ID"];
        return;
    }

    [[BusyIndicator sharedInstance] startIndicator];
    NSString *urlString = [[webUrlconstant sharedInstance] URL_GET_Fcustomer];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"demid=%@", demid];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        // Always stop indicator on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertMsg:error.localizedDescription];
            });
            return;
        }

        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError || ![json isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertMsg:@"Invalid response from server."];
            });
            return;
        }

        NSArray *customerArray = json[@"customer"];
        if ([customerArray isKindOfClass:[NSArray class]] && customerArray.count > 0) {
            NSDictionary *firstRecord = customerArray[0];
            strongSelf.approvalDetail = [ApprovalDetailItem itemFromJSON:firstRecord];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertMsg:@"No customer data found."];
            });
        }
    }];
    
    [task resume];
}

@end
