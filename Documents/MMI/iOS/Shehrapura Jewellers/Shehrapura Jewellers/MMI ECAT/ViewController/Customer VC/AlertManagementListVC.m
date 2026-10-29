//
//  AlertManagementListVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 31/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AlertManagementListVC.h"
#import "SendAlertManagementVC.h"
#import "AlertManagementListCell.h"

#pragma mark: - AlertManagementListVC

@interface AlertManagementListVC()
{}
@end

@implementation AlertManagementListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Alert Management";
    [self setUpNavigationBtn];
    tblListData = [NSMutableArray array];
    [self apiGetAlertList];
}

#pragma mark: - Helper Methods

-(void)setUpNavigationBtn{
    // Create the button
    UIButton *btn_Send = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Send.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *phoneImage = [UIImage systemImageNamed:@"paperplane.circle.fill"];
    [btn_Send setBackgroundImage:phoneImage forState:UIControlStateNormal];
    // Configure button appearance
    [[btn_Send imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_Send.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_Send.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_Send.tintColor = [UIColor whiteColor];
    // Add the button action
    [btn_Send addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *sendBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Send];
    
    // Assign the UIBarButtonItem to the navigation item
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:sendBarButton, nil];
}

-(IBAction)nextBtnAction:(id)sender{
    SendAlertManagementVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SendAlertManagementVC"];
    __weak typeof(self) weakSelf = self;
    obj.onCloseTapped = ^{
        [weakSelf apiGetAlertList];
    };
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: - UITableView DataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tblListData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AlertManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertManagementListCell" forIndexPath:indexPath];
    
    cell.subView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.subView.layer.borderWidth = 1;
    cell.subView.layer.cornerRadius = 10;
    
    NSString *strTitle = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"msg"] objectAtIndex:indexPath.row]];
    NSString *trimmedString = [strTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.lblTitleName.text = trimmedString;
    
    NSString *strDate = [NSString stringWithFormat:@"%@",[[tblListData valueForKey:@"tdate"] objectAtIndex:indexPath.row]];
    cell.lblCategory.hidden = true;
    if (strDate.length > 0) {
        cell.lblDate.text = strDate;
        cell.lblCategory.hidden = false;
    }
    
    NSString *strCategory = [[tblListData valueForKey:@"category"] objectAtIndex:indexPath.row];
    strCategory = SafeString(strCategory);
    cell.lblCategory.hidden = true;
    if (strCategory.length > 0) {
        cell.lblCategory.text = [NSString stringWithFormat:@"Category - %@",strCategory];
        cell.lblCategory.hidden = false;
    }

    return cell;
}

#pragma mark -  API Method

- (void)apiGetAlertList{
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
                self->tblListData = [pDict objectForKey:@"alertadminlist"];
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
