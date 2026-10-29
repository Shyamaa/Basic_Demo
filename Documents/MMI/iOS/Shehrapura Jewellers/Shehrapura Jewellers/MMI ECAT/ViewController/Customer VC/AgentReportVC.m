//
//  AgentReportVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/09/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AgentReportVC.h"

#pragma mark - Custom NewRateBook UITableViewCell

@interface AgentReportVCTablCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblMode;
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;
@property (nonatomic, strong) IBOutlet UILabel *lblAmount;

@end

@implementation AgentReportVCTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
@end


@implementation AgentReportVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Agent Report";
    agentReportListData = [NSMutableArray array];
    [self setUpNavigationBtn];
    [self apiGetAgentList];
}

#pragma mark: - Helper Methods

-(void)setUpNavigationBtn{
    // Create the button
    UIButton *btn_Filter = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *phoneImage = [UIImage systemImageNamed:@"calendar"];
    [btn_Filter setBackgroundImage:phoneImage forState:UIControlStateNormal];
    btn_Filter.tintColor = [UIColor whiteColor];
    // Add the button action
    [btn_Filter addTarget:self action:@selector(filterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
     
    // Assign the UIBarButtonItem to the navigation item
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:filterBarButton, nil];
}

-(void)filterBtnAction:(UIButton*)sender{
    filterView.hidden = false;
    [self setupDatePickerForTextField:txtDateFrom];
    [self setupDatePickerForTextField:txtDateTo];
}

-(IBAction)filterButtonsAction:(UIButton *)sender{
    if (sender.tag == 11) {
        filterView.hidden = true;
    } else {
        if (txtDateFrom.text.length > 0 && txtDateTo.text.length > 0) {
            filterView.hidden = true;
        } else {
            [self alertMsg:@"Please select dates"];
        }
    }
}

#pragma mark: - UITableView DataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return agentReportListData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AgentReportVCTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentReportVCTablCell" forIndexPath:indexPath];
    
    cell.subView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.subView.layer.borderWidth = 1;
    cell.subView.layer.cornerRadius = 10;
    
    cell.lblName.text = [NSString stringWithFormat:@"%@",[[agentReportListData valueForKey:@"username"] objectAtIndex:indexPath.row]];
    cell.lblMode.text = [NSString stringWithFormat:@"%@",[[agentReportListData valueForKey:@"mode"] objectAtIndex:indexPath.row]];
    cell.lblMobile.text = [NSString stringWithFormat:@"%@",[[agentReportListData valueForKey:@"mobile"] objectAtIndex:indexPath.row]];
    cell.lblAmount.text = [NSString stringWithFormat:@"%@",[[agentReportListData valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -  API Method

- (void)apiGetAgentList{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GetAlertManagementList]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSLog(@"Register config Url = %@", url);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [[BusyIndicator sharedInstance]stopIndicator];
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"Register config Response = %@", jsonDict);
                NSMutableDictionary *pDict = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                              error:&error];
                self->agentReportListData = [pDict objectForKey:@"alertadminlist"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->tblView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertMsg:jsonError.localizedDescription];
                });
            }
        } else {
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:error.localizedDescription];
            });
        }
    }];
    [task resume];
}

@end
