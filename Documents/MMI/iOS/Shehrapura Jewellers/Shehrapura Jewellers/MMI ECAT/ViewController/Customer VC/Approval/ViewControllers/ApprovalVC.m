//
//  ApprovalVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 20/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalVC.h"
#import "ApprovalItem.h"
#import "ApprovalCell.h"
#import "ApprovalDetailsVC.h"
#import "CustomerVisitItemListVC.h"
#import "ApprovalProductListVC.h"

typedef NS_ENUM(NSInteger, CustomerCategoryType) {
    CustomerType = 0,
    ItemType = 1,
    CategoryType = 2
};

@interface ApprovalVC ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ApprovalItem *> *approvalList;
@property (nonatomic, strong) NSMutableArray *itemList;

@end

@implementation ApprovalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Approval";
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    self.approvalList = [NSMutableArray array];
    self.itemList = [NSMutableArray array];
    
    txtItem.delegate = self;
    [self setupNavigationBar];
    [self setupTableView];
    [self fetchApprovalList];
    [self setupDatePickerForTextField:txtDateFrom];
    [self setupDatePickerForTextField:txtDateTo];
}

- (void)setupNavigationBar {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(openBtnAddAction)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)openBtnAddAction {
    [self.view bringSubviewToFront:viewAddApproval];
    viewAddApproval.hidden = false;
    
    // Chain API calls to avoid race condition
    __weak typeof(self) weakSelf = self;
    [self fetchCustomerItemCategoryList:CustomerType completion:^{
        [weakSelf fetchCustomerItemCategoryList:ItemType completion:^{
            [weakSelf fetchCustomerItemCategoryList:CategoryType completion:nil];
        }];
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtItem) {
        [self openList];
        return NO;
    } else {
        [textField resignFirstResponder];
        return YES;
    }
}

- (void)openList {
    UIStoryboard *customerVisitSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerVisitItemListVC *popVc = [customerVisitSb instantiateViewControllerWithIdentifier:@"CustomerVisitItemListVC"];
    popVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popVc.str_page_type = @"Approval";
    popVc.listData = self.itemList;
    
    __weak typeof(self) weakSelf = self;
    popVc.completionHandler = ^(NSMutableArray *listData) {
        NSLog(@"Received from child: %@", listData);
        NSString *joinedString = [listData componentsJoinedByString:@", "];
        NSLog(@"%@", joinedString);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf->txtItem.text = joinedString;
    };
    [self presentViewController:popVc animated:YES completion:nil];
}

#pragma mark - Setup TableView

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView registerClass:[ApprovalCell class] forCellReuseIdentifier:@"ApprovalCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

#pragma mark - Button Actions

-(IBAction)btnOKAction:(UIButton *)sender {
    if (sender.tag == 600) {
        viewAddApproval.hidden = true;
    } else {
        viewAddApproval.hidden = true;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"ino"]    = txtItem.text ?: @"";
        params[@"dfrom"]  = txtDateFrom.text ?: @"";
        params[@"dto"]    = txtDateTo.text ?: @"";
        params[@"hour"]   = txtHours.text ?: @"";
        params[@"mobile"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"] ?: @"";
        
        params[@"id"]  = @"0";
        params[@"act"] = @"form";
        
        ApprovalProductListVC *vc = [[ApprovalProductListVC alloc] init];
        vc.filterParams = params;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.approvalList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApprovalCell" forIndexPath:indexPath];
    ApprovalItem *item = self.approvalList[indexPath.row];
    [cell configureWithItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalItem *item = self.approvalList[indexPath.row];
    
    if (![item.status isEqualToString:@"Pending"]) {
        [self alertMsg:@"Only pending approvals can be opened."];
        return;
    }
    
    ApprovalDetailsVC *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ApprovalDetailsVC"];
    detailsVC.approvalItem = item;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - API Methods

- (void)fetchApprovalList {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *urlStr = [[webUrlconstant sharedInstance] URL_GET_Fillgrid];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"mobile=%@", mobile];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });
        
        if (data && !error) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (json && !jsonError) {
                NSArray *records = json[@"records"];
                if ([records isKindOfClass:[NSArray class]]) {
                    [weakSelf.approvalList removeAllObjects];
                    for (NSDictionary *dict in records) {
                        ApprovalItem *item = [[ApprovalItem alloc] initWithDictionary:dict];
                        [weakSelf.approvalList addObject:item];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf alertMsg:error.localizedDescription];
            });
        }
    }];
    
    [task resume];
}

- (void)fetchCustomerItemCategoryList:(CustomerCategoryType)type completion:(void (^)(void))completion {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *urlStr = [[webUrlconstant sharedInstance] URL_GET_SelCustomer];
    switch (type) {
        case ItemType:
            urlStr = [[webUrlconstant sharedInstance] URL_DITEM];
            break;
        case CategoryType:
            urlStr = [[webUrlconstant sharedInstance] URL_GET_CelCategory];
            break;
        case CustomerType:
        default:
            urlStr = [[webUrlconstant sharedInstance] URL_GET_SelCustomer];
            break;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (data && !error) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (json && !jsonError) {
                NSLog(@"Json Response %@", json);
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (type) {
                        case CustomerType: {
                            if ([json[@"customer"] isKindOfClass:[NSArray class]]) {
                                NSArray *customerArray = json[@"customer"];
                                NSArray *customerNames = [customerArray valueForKey:@"customer"];
                                strongSelf->txtCustomer.text = customerNames.firstObject ?: @"";
                                [strongSelf->txtCustomer addPickerWithData:customerNames searchEnabled:NO];
                            }
                            break;
                        }
                        case ItemType: {
                            if ([json[@"idesc"] isKindOfClass:[NSArray class]]) {
                                NSArray *idescArray = json[@"idesc"];
                                weakSelf.itemList = [[idescArray valueForKey:@"idesc"] mutableCopy];
                                strongSelf->txtItem.text = weakSelf.itemList.firstObject ?: @"";
                                [strongSelf->txtItem addPickerWithData:weakSelf.itemList searchEnabled:NO];
                            }
                            break;
                        }
                        case CategoryType: {
                            if ([json[@"grade"] isKindOfClass:[NSArray class]]) {
                                NSArray *gradeArray = json[@"grade"];
                                NSArray *categoryArray = [gradeArray valueForKey:@"grade"];
                                strongSelf->txtCategory.text = categoryArray.firstObject ?: @"";
                                [strongSelf->txtCategory addPickerWithData:categoryArray searchEnabled:NO];
                            }
                            break;
                        }
                    }
                    if (completion) {
                        completion();
                    }
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf alertMsg:error.localizedDescription];
                if (completion) {
                    completion();
                }
            });
        }
    }];
    
    [task resume];
}

@end
