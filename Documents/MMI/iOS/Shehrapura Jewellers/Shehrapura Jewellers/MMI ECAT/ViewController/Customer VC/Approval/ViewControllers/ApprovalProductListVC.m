//
//  ApprovalProductListVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalProductListVC.h"
#import "ApprovalProductCell.h"

@interface ApprovalProductListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ApprovalProductItem *> *productList;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedProductList;

@end

@implementation ApprovalProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Product List";
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;

    self.productList = [NSMutableArray array];
    self.selectedProductList = [NSMutableArray array];
    
    [self setupTableView];
    [self fetchProductList];
}

#pragma mark - UI Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[ApprovalProductCell class] forCellReuseIdentifier:@"ApprovalProductCell"];
    [self.view addSubview:self.tableView];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    saveButton.layer.cornerRadius = 10;
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    [NSLayoutConstraint activateConstraints:@[
        [saveButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [saveButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [saveButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-10],
        [saveButton.heightAnchor constraintEqualToConstant:50],

        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:saveButton.topAnchor constant:-10]
    ]];
}

#pragma mark - Actions

- (void)saveButtonTapped {
    // Collect selected product tgno strings
    NSArray<ApprovalProductItem *> *selectedItems = [self.productList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
    
    if (selectedItems.count == 0) {
        [self showAlertWithTitle:@"Alert" message:@"Please select at least one item."];
        return;
    }

    [self.selectedProductList removeAllObjects];
    for (ApprovalProductItem *item in selectedItems) {
        NSLog(@"Selected item: %@ (%@)", item.tgno, item.tsno);
        if (item.tgno) {
            [self.selectedProductList addObject:item.tgno];
        }
    }

    [self saveProductList];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (ApprovalProductCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApprovalProductCell" forIndexPath:indexPath];
    ApprovalProductItem *item = self.productList[indexPath.row];
    [cell configureWithItem:item];

    // Use weak/strong to avoid retain cycle in block
    __weak typeof(self) weakSelf = self;
    cell.selectionChanged = ^(BOOL selected) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        item.selected = selected;
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // No action on tap, or implement if needed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - API Methods

- (void)fetchProductList {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *str_idesc = self.filterParams[@"ino"] ?: @"";
    NSString *str_grade = @""; // You can add grade if needed
    NSString *str_selectall = @""; // Add if needed
    
    NSString *urlStr = [[webUrlconstant sharedInstance] URL_GET_FltCategory];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"idesc=%@&grade=%@&selectall=%@", str_idesc, str_grade, str_selectall];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:@"Error" message:error.localizedDescription];
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![json isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:@"Error" message:@"Invalid response from server."];
            });
            return;
        }
        
        NSArray *records = json[@"records"];
        if ([records isKindOfClass:[NSArray class]]) {
            [strongSelf.productList removeAllObjects];
            for (NSDictionary *dict in records) {
                ApprovalProductItem *item = [[ApprovalProductItem alloc] initWithDictionary:dict];
                [strongSelf.productList addObject:item];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:@"Notice" message:@"No product data found."];
            });
        }
    }];
    
    [task resume];
}

- (void)saveProductList {
    if (self.selectedProductList.count == 0) {
        [self showAlertWithTitle:@"Alert" message:@"No products selected to save."];
        return;
    }

    [[BusyIndicator sharedInstance] startIndicator];

    NSString *joinedString = [self.selectedProductList componentsJoinedByString:@","];
    NSString *demid = self.filterParams[@"id"] ?: @"";
    NSString *mobile = self.filterParams[@"mobile"] ?: @"";

    NSString *urlStr = [[webUrlconstant sharedInstance] URL_SaveTag];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"tsno=%@&demid=%@&mobile=%@", joinedString, demid, mobile];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:@"Error" message:error.localizedDescription];
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![json isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:@"Error" message:@"Invalid response from server."];
            });
            return;
        }
        
        NSString *message = json[@"message"] ?: @"No message received.";
        BOOL status = [json[@"status"] boolValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (status) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:okAction];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            } else {
                [strongSelf showAlertWithTitle:@"Error" message:message];
            }
        });
    }];
    
    [task resume];
}

#pragma mark - Helper

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertWithTitle:title message:message];
        });
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
