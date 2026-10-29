//
//  UsersECAT.m
//  Jewel Desk
//
//  Created by App Dev on 19/02/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "UsersECAT.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "SWRevealViewController.h"
#import "MMIHOMEPanel.h"
#import <objc/runtime.h>

@interface UsersECAT ()
{
    NSString *rights;
    NSMutableArray *allitems;
}
@end

@implementation UsersECAT

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];

    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];


    UIImage *image = [UIImage imageNamed:@"menu.png"];
    CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
    [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
    [someButton1 addTarget:revealController action:@selector(revealToggle:)
    forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    self.title = @"Users";
//    rights = [[NSUserDefaults standardUserDefaults]stringForKey:@"rights"];
//    NSLog(@"rights_user :::::::::::::: %@",rights);

    self.checkboxTitles = @[@"Catalogue", @"Tag Calculator", @"Quotation", @"My Order", @"Physical Stock",@"Customer Visit",@"Outstanding",@"Customer Feedback",@"Add Your Demand",@"Customer Entry",@"Undelivered",@"Today Bhav", @"Order Register", @"Repair Register"];
       self.checkboxButtons = [NSMutableArray array];
       
    mobile_edit = @"";
    [self scrollData_item];
}

-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    NSString *loginRequest = [NSString stringWithFormat:@"softid=%@",softid];
    NSString * URL_API = [WEB_URL URL_GET_USERS];
    
    NSLog(@"notification :::::::::::::::  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSURL *url = [NSURL URLWithString:URL_API];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_itemcat:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void) parseResponse_itemcat:(NSData *) data {
    @try {
        array_item = [[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            [[BusyIndicator sharedInstance]stopIndicator];
            
            NSArray *userlist = pDict[@"userlist"];
               
               if (![userlist isKindOfClass:[NSArray class]] || userlist.count == 0) {
                   NSLog(@"userlist is empty");
               } else if (userlist.count == 1 && [userlist.firstObject isKindOfClass:[NSArray class]] &&
                          ((NSArray *)userlist.firstObject).count == 0) {
                   NSLog(@"userlist contains an empty array");
               } else {
                   array_item = [pDict objectForKey:@"userlist"];
               }
            
            [self.tableView reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[array_item valueForKey:@"mobile"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    } else {
        // Remove old subviews to avoid duplication
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Item name label
    UILabel *lbl_itemname = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 150, 40)];
    lbl_itemname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    lbl_itemname.text = [NSString stringWithFormat:@"%@", [[array_item valueForKey:@"mobile"] objectAtIndex:indexPath.row]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lbl_itemname];
    
    CGFloat buttonWidth = 30;
    CGFloat buttonHeight = 30;
    CGFloat padding = 10;
   
    CGFloat startX = self.view.frame.size.width - padding - buttonWidth;

    // Delete button
    
    UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(startX, 5, buttonWidth, buttonHeight);
    [btn_delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    btn_delete.tag = indexPath.row;
    [btn_delete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn_delete];
    
    // Edit button
    
    startX -= (buttonWidth + padding);
    UIButton *btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_edit.frame = CGRectMake(startX, 5, buttonWidth, buttonHeight);
    [btn_edit setImage:[UIImage imageNamed:@"edit_row"] forState:UIControlStateNormal];
    btn_edit.tag = indexPath.row;
    [btn_edit addTarget:self action:@selector(btn_edit:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn_edit];
    
    // Permission button

    startX -= (buttonWidth + padding);
    UIButton *btn_permission = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_permission.frame = CGRectMake(startX, 5, buttonWidth, buttonHeight);
    [btn_permission setImage:[UIImage imageNamed:@"permission"] forState:UIControlStateNormal];
    btn_permission.tag = indexPath.row;
    [btn_permission addTarget:self action:@selector(btn_permission:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn_permission];
    
    return cell;
}

-(void)btn_permission:(UIButton*)sender
{
    NSInteger index_c = [sender tag];
    NSString * str_mobile = [[array_item valueForKey:@"mobile"] objectAtIndex:index_c];
    NSLog(@"mobile :::::::::::::::  %@",str_mobile);
    
    _siteList = [NSMutableArray array];
    _selectedSiteNames = [NSMutableArray array];
    _selectedSiteIds = [NSMutableArray array];
    _items = [NSMutableArray array];
    _selectedItems = [NSMutableArray array];

    [self getItemNameAPI:str_mobile isFirst:2];
}

-(void)btn_delete:(UIButton*)sender
{
    NSInteger index_c = [sender tag];
    NSString * str_mobile = [[array_item valueForKey:@"mobile"] objectAtIndex:index_c];
    NSLog(@"mobile :::::::::::::::  %@",str_mobile);
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        [self DeleteAPI:str_mobile];
    }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)btn_edit:(UIButton*)sender
{
    allitems = [NSMutableArray array];
    mobile_edit = @"";
    NSInteger index_c = [sender tag];
    mobile_edit = [[array_item valueForKey:@"mobile"] objectAtIndex:index_c];
    rights = [[array_item valueForKey:@"rights"] objectAtIndex:index_c];
    NSInteger rightsLength = rights.length;
    for (int i = 0; i < rightsLength; i++) {
        unichar character = [rights characterAtIndex:i];
        NSString *strdata = [NSString stringWithFormat:@"%c", character];
        [allitems addObject:strdata];
    }
    [self showCheckboxPopup];
}

- (void)DeleteAPI:(NSString *)mobile {
    NSLog(@"mobile *************  %@",mobile);
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString * URL_API = [WEB_URL URL_DELETE_USER];

    // Show Progress Dialog
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Loading..."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    loadingIndicator.center = CGPointMake(135.0, 65.5);
    [loadingIndicator startAnimating];
    [alert.view addSubview:loadingIndicator];
    [self presentViewController:alert animated:YES completion:nil];
    
    // Set URL
    NSURL *url = [NSURL URLWithString:URL_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // Set Parameters
    NSString *postString = [NSString stringWithFormat:@"mobile=%@&softid=%@", mobile, softid];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"postString *************  %@",postString);

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (!jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[jsonResponse objectForKey:@"success"] isEqualToString:@"1"])
                {
                    [self scrollData_item];
                    [self.tableView reloadData];
                } else {
                    NSString *message = [jsonResponse objectForKey:@"message"];
                    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:errorAlert animated:YES completion:nil];
                }
            });
        }
    }];
    
    [task resume];
}

- (void)showCheckboxPopup {
    // 1. Create a full-screen black semi-transparent background
    UIViewController *checkboxContainerVC = [[UIViewController alloc] init];
    checkboxContainerVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    checkboxContainerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // 2. Create the centered white popup view
    CGFloat popupWidth = MIN([UIScreen mainScreen].bounds.size.width - 40, 350);
    CGFloat popupHeight = MIN([UIScreen mainScreen].bounds.size.height - 120, 580);
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, popupHeight)];
    popupView.center = checkboxContainerVC.view.center;
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.layer.cornerRadius = 16.0;
    popupView.layer.masksToBounds = YES;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [checkboxContainerVC.view addSubview:popupView];

    // 3. Title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, popupWidth, 28)];
    titleLabel.text = @"User Permission";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    [popupView addSubview:titleLabel];

    // 4. Separator line
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 8, popupWidth, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [popupView addSubview:separator];

    // 5. Scrollable checkbox list
    CGFloat listTop = CGRectGetMaxY(separator.frame) + 8;
    CGFloat listHeight = popupHeight - listTop - 70; // leave space for buttons
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, listTop, popupWidth, listHeight)];
    scrollView.showsVerticalScrollIndicator = YES;
    [popupView addSubview:scrollView];

    CGFloat checkboxY = 0;
    CGFloat checkboxHeight = 40;
    CGFloat checkboxSpacing = 8;
    CGFloat checkboxLeft = 20;
    CGFloat labelLeft = 60;
    CGFloat labelWidth = popupWidth - labelLeft - 20;
    [self.checkboxButtons removeAllObjects];
    for (int i = 0; i < self.checkboxTitles.count; i++) {
        UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        checkbox.frame = CGRectMake(checkboxLeft, checkboxY + 5, 40, 40);
        unichar character = [rights characterAtIndex:i];
        NSString *strdata = [NSString stringWithFormat:@"%c", character];
        // Use system images for checkboxes
        UIImage *uncheckedImage = [UIImage systemImageNamed:@"square"];
        UIImage *checkedImage = [UIImage systemImageNamed:@"checkmark.square.fill"];
        [checkbox setImage:uncheckedImage forState:UIControlStateNormal];
        [checkbox setImage:checkedImage forState:UIControlStateSelected];
        [checkbox setTintColor:[UIColor blackColor]];
        checkbox.selected = [strdata isEqualToString:@"0"];
        checkbox.tag = i;
        [checkbox addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:checkbox];
        [self.checkboxButtons addObject:checkbox];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, checkboxY, labelWidth, checkboxHeight)];
        label.text = self.checkboxTitles[i];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [scrollView addSubview:label];
        checkboxY += checkboxHeight + checkboxSpacing;
    }
    scrollView.contentSize = CGSizeMake(popupWidth, checkboxY);

    // 6. OK and Cancel buttons
    CGFloat buttonWidth = (popupWidth - 60) / 2;
    CGFloat buttonY = popupHeight - 60;
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    okButton.frame = CGRectMake(20, buttonY, buttonWidth, 44);
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    okButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"] ?: [UIColor systemRedColor];
    okButton.layer.cornerRadius = 8.0;
    okButton.clipsToBounds = YES;
    [okButton addTarget:self action:@selector(handleSelectedCheckboxes) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:okButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(CGRectGetMaxX(okButton.frame) + 20, buttonY, buttonWidth, 44);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    cancelButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"] ?: [UIColor systemRedColor];
    cancelButton.layer.cornerRadius = 8.0;
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(dismissFullScreenAlert) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:cancelButton];

    // 7. Present the popup
    [self presentViewController:checkboxContainerVC animated:YES completion:nil];
}

- (void)dismissFullScreenAlert {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)checkboxTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [allitems replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
}
- (void)handleSelectedCheckboxes {
    NSLog(@"allitems items: %@", allitems);
    
    NSString * str_item = [NSString stringWithFormat:@"%@",allitems];
    str_item = [str_item stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    str_item = [[str_item componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    str_item = [str_item stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"%@", str_item);
    [self dismissViewControllerAnimated:YES completion:nil];

    [self saveItemAPI:str_item];
    NSLog(@" str_item : %@", str_item);
}

//- (void)handleSelectedCheckboxes {
////    NSMutableArray *selectedItems = [NSMutableArray array];
//    
//    // Update 'allitems' based on checkbox selection
////    NSInteger count = MIN(self.checkboxButtons.count, self.checkboxTitles.count);
////    for (int i = 0; i < count; i++) {
////        UIButton *checkbox = self.checkboxButtons[i];
////        if (checkbox.isSelected) {
////            [allitems replaceObjectAtIndex:i withObject:@"1"];
////        } else {
////            [allitems replaceObjectAtIndex:i withObject:@"0"];
////        }
////    }
//    
////    NSLog(@"Selected items: %@", selectedItems);
//    NSLog(@"All items: %@", allitems);
//    
//    // Create the formatted string without unnecessary characters
//    NSString *str_item = [allitems componentsJoinedByString:@""];
//    
//    NSLog(@"Formatted str_item: %@", str_item);
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//

- (void)saveItemAPI:(NSString *)rights {
    UIActivityIndicatorView *pdialog = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    pdialog.center = self.view.center;
    [self.view addSubview:pdialog];
    [pdialog startAnimating];
    
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString * urlString = [WEB_URL URL_USER_PERMISSION];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSDictionary *params = @{
        @"mobile": mobile_edit,
        @"softid": softid,
        @"rights": rights
    };

    NSError *error = nil;
    if (error) {
        NSLog(@"Error serializing JSON: %@", error.localizedDescription);
        return;
    }

    request.HTTPBody = [[self encodeParameters:params] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [pdialog stopAnimating];
            [pdialog removeFromSuperview];
        });
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON Parse Error: %@", jsonError.localizedDescription);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Response JSON: %@", jsonObject);
            [pdialog stopAnimating];
            [pdialog removeFromSuperview];

            if ([jsonObject[@"success"] isEqualToString:@"1"]) {
                NSLog(@"Navigation to MMIHOMEPanel");
                [[NSUserDefaults standardUserDefaults] setObject:rights forKey:@"rights"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                MMIHOMEPanel *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                
                if (self.navigationController) {
                    [self.navigationController pushViewController:obj animated:YES];
                } else {
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:obj];
                    [self presentViewController:navController animated:YES completion:nil];
                }
            } else {
                NSString *message = jsonObject[@"message"] ?: @"Something went wrong.";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
    
    [dataTask resume];
}

// Helper method to encode parameters as URL query string
- (NSString *)encodeParameters:(NSDictionary *)params {
    NSMutableArray *encodedParams = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [encodedParams addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }];
    return [encodedParams componentsJoinedByString:@"&"];
}


- (void)getItemNameAPI:(NSString *)mobile isFirst:(BOOL)isFirst {
    
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *urlStr;
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        urlStr = [WEB_URL URL_GET_SITE];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        urlStr = [NSString stringWithFormat:@"http://%@/jwellyecat/get_site.php", ip];
    } else {
        urlStr = [WEB_URL URL_GET_SITE];
    }

    NSLog(@"urlStr :::::::::: %@",urlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];

    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSMutableString *postBody = [NSMutableString stringWithFormat:@"apptype=%@&mobile=%@", ECAT_TYPE, regmobile];

    if ([regmobile isEqualToString:mobile]) {
        [postBody appendString:@"&is_register=1"];
    } else {
        [postBody appendString:@"&is_register=0"];
    }

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];

        [postBody appendFormat:@"&ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@", ip, username, password, db, ftppath];
    }
    NSLog(@"postBody :::::::::: %@",postBody);

    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }

        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [[BusyIndicator sharedInstance] stopIndicator];

        if (!jsonError) {

            NSArray *sitelist = responseDict[@"sitelist"];
            if (isFirst) {
                [self.siteList removeAllObjects];
                [self.items removeAllObjects];
                [self.selectedItems removeAllObjects];
            }

            for (NSDictionary *siteDict in sitelist) {
                ObjectSiteModel *model = [[ObjectSiteModel alloc] initWithName:siteDict[@"site"] siteid:siteDict[@"siteid"]];
                [self.siteList addObject:model];
                [self.items addObject:model.sitename];
                [self.selectedItems addObject:@(NO)];
                self.serverSiteIds = siteDict[@"site_idds"];
            }
            
            if (isFirst) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDialog:mobile];
                });
            }
        }
    }];
    [task resume];
}

- (void)showDialog:(NSString *)mobile {
    // 1. Create a full-screen black semi-transparent background
    UIViewController *dialogVC = [[UIViewController alloc] init];
    dialogVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    dialogVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // 2. Create the centered white popup view
    CGFloat popupWidth = MIN([UIScreen mainScreen].bounds.size.width - 40, 350);
    CGFloat popupHeight = MIN([UIScreen mainScreen].bounds.size.height - 120, 580);
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, popupHeight)];
    popupView.center = dialogVC.view.center;
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.layer.cornerRadius = 16.0;
    popupView.layer.masksToBounds = YES;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [dialogVC.view addSubview:popupView];

    // 3. Title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, popupWidth, 28)];
    titleLabel.text = @"Select Site :-";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    [popupView addSubview:titleLabel];

    // 4. Separator line
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 8, popupWidth, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [popupView addSubview:separator];

    // 5. Scrollable checkbox list
    CGFloat listTop = CGRectGetMaxY(separator.frame) + 8;
    CGFloat listHeight = popupHeight - listTop - 70; // leave space for buttons
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, listTop, popupWidth, listHeight)];
    scrollView.showsVerticalScrollIndicator = YES;
    [popupView addSubview:scrollView];

    CGFloat checkboxY = 0;
    CGFloat checkboxHeight = 40;
    CGFloat checkboxSpacing = 8;
    CGFloat checkboxLeft = 20;
    CGFloat labelLeft = 60;
    CGFloat labelWidth = popupWidth - labelLeft - 20;

    // Clear previous selections
    [self.selectedSiteNames removeAllObjects];
    [self.selectedSiteIds removeAllObjects];
    if (!self.selectedItems) self.selectedItems = [NSMutableArray array];
    [self.selectedItems removeAllObjects];
    for (int i = 0; i < self.items.count; i++) {
        [self.selectedItems addObject:@(NO)];
    }

    for (int i = 0; i < self.items.count; i++) {
        NSString *site = self.items[i];
        ObjectSiteModel *model = self.siteList[i];
        BOOL isSelected = [self.selectedItems[i] boolValue];
        UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        checkbox.frame = CGRectMake(checkboxLeft, checkboxY + 5, 40, 40);
        UIImage *uncheckedImage = [UIImage systemImageNamed:@"square"];
        UIImage *checkedImage = [UIImage systemImageNamed:@"checkmark.square.fill"];
        [checkbox setImage:uncheckedImage forState:UIControlStateNormal];
        [checkbox setImage:checkedImage forState:UIControlStateSelected];
        checkbox.selected = isSelected;
        checkbox.tintColor = [UIColor blackColor];
        checkbox.tag = i;
        [checkbox addTarget:self action:@selector(siteCheckboxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:checkbox];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, checkboxY, labelWidth, checkboxHeight)];
        label.text = site;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [scrollView addSubview:label];

        checkboxY += checkboxHeight + checkboxSpacing;
    }
    scrollView.contentSize = CGSizeMake(popupWidth, checkboxY);

    // 6. Submit and Cancel buttons
    CGFloat buttonWidth = (popupWidth - 60) / 2;
    CGFloat buttonY = popupHeight - 60;
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(20, buttonY, buttonWidth, 44);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    submitButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"] ?: [UIColor systemRedColor];
    submitButton.layer.cornerRadius = 8.0;
    submitButton.clipsToBounds = YES;
    submitButton.tag = 1001;
    [submitButton addTarget:self action:@selector(submitSiteSelection:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(submitButton, "dialogMobile", mobile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(submitButton, "dialogVC", dialogVC, OBJC_ASSOCIATION_ASSIGN);
    [popupView addSubview:submitButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(CGRectGetMaxX(submitButton.frame) + 20, buttonY, buttonWidth, 44);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    cancelButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"] ?: [UIColor systemRedColor];
    cancelButton.layer.cornerRadius = 8.0;
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(cancelSiteSelection:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(cancelButton, "dialogVC", dialogVC, OBJC_ASSOCIATION_ASSIGN);
    [popupView addSubview:cancelButton];

    // 7. Present the popup
    [self presentViewController:dialogVC animated:YES completion:nil];
}

// Helper for checkbox tap
- (void)siteCheckboxTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    BOOL checked = [self.selectedItems[idx] boolValue];
    self.selectedItems[idx] = @(!checked);
    sender.selected = !checked;
    NSString *site = self.items[idx];
    ObjectSiteModel *model = self.siteList[idx];
    if (!checked) {
        if (![self.selectedSiteNames containsObject:site]) {
            [self.selectedSiteNames addObject:site];
            [self.selectedSiteIds addObject:model.siteid];
        }
    } else {
        [self.selectedSiteNames removeObject:site];
        [self.selectedSiteIds removeObject:model.siteid];
    }
}

// Helper for submit
- (void)submitSiteSelection:(UIButton *)sender {
    NSString *mobile = objc_getAssociatedObject(sender, "dialogMobile");
    UIViewController *dialogVC = objc_getAssociatedObject(sender, "dialogVC");
    [dialogVC dismissViewControllerAnimated:YES completion:^{
        [self saveSelectedSites:mobile];
    }];
}

// Helper for cancel
- (void)cancelSiteSelection:(UIButton *)sender {
    UIViewController *dialogVC = objc_getAssociatedObject(sender, "dialogVC");
    [dialogVC dismissViewControllerAnimated:YES completion:^{
        [self.selectedSiteNames removeAllObjects];
        [self.selectedSiteIds removeAllObjects];
    }];
}

- (void)saveSelectedSites:(NSString *)mobile {

    NSMutableString *site_names = [NSMutableString string];
    NSMutableString *site_ids = [NSMutableString string];

    for (NSString *name in self.selectedSiteNames) {
        [site_names appendFormat:@"%@,", name];
    }

    for (ObjectSiteModel *model in self.siteList) {
        if ([self.selectedSiteNames containsObject:model.sitename]) {
            [site_ids appendFormat:@"%@,", model.siteid];
        }
    }
    NSLog(@"Selected site_names: %@", site_names);
    NSLog(@"Selected site_ids: %@", site_ids);
    [self saveSitesAPI:mobile sitename:site_names siteid:site_ids];
}

- (void)saveSitesAPI:(NSString *)mobile sitename:(NSString *)sitename  siteid:(NSString *)siteid {
    
    NSLog(@"Saving site selection for mobile: %@", mobile);
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    // Show loading
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *urlString;
    if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        urlString = [NSString stringWithFormat:@"http://%@/jwellyecat/save_siteaccess.php", ip];
    } else {
        urlString = [WEB_URL URL_SAVE_SITEACCESS];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSMutableString *postBody = [NSMutableString string];
    [postBody appendFormat:@"apptype=%@", ECAT_TYPE];

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [postBody appendFormat:@"&ip=%@", [prefs stringForKey:@"ip"]];
        [postBody appendFormat:@"&ipusername=%@", [prefs stringForKey:@"ipusername"]];
        [postBody appendFormat:@"&password=%@", [prefs stringForKey:@"pswd"]];
        [postBody appendFormat:@"&dbname=%@", [prefs stringForKey:@"db"]];
        [postBody appendFormat:@"&ftppath=%@", [prefs stringForKey:@"ftppath"]];
    }

    [postBody appendFormat:@"&site_ids=%@", siteid];
    [postBody appendFormat:@"&site_names=%@", sitename];
    [postBody appendFormat:@"&mobile=%@", mobile];

    NSData *bodyData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [alert dismissViewControllerAnimated:YES completion:nil];
              });

              if (error) {
                  NSLog(@"Error: %@", error.localizedDescription);
                  return;
              }

              NSError *jsonError;
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

              if (!jsonError) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      NSString *message = json[@"message"];
                      [self showToast:message];
                      // Call Get_Itemname_Api equivalent
                      [self getItemNameAPI:mobile isFirst:3];
                  });
              } else {
                  NSLog(@"JSON Error: %@", jsonError.localizedDescription);
              }
          }];

    [task resume];
}

- (void)showToast:(NSString *)message {
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:toast animated:YES completion:nil];

    int duration = 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
