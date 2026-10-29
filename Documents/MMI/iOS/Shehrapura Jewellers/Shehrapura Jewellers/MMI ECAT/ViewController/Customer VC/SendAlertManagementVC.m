//
//  SendAlertManagementVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 31/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "SendAlertManagementVC.h"
#import "AlertManagementListCell.h"

@interface SendAlertManagementVC()
{
    NSString *str_placeholder;
    BOOL isFilter;
}
@end

@implementation SendAlertManagementVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Alert Management";
    areaListData = [NSMutableArray array];
    categoryListData = [NSMutableArray array];
    filterUserListData = [NSMutableArray array];
    [self setUpNavigationBtn];
    [self setUpView];
    isFilter = NO;
}

#pragma mark: - Helper Methods

-(void)setUpNavigationBtn{
    // Create the button
    UIButton *btn_Filter = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *phoneImage = [UIImage imageNamed:@"filter"];
    [btn_Filter setBackgroundImage:phoneImage forState:UIControlStateNormal];
    // Configure button appearance
    [[btn_Filter imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_Filter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_Filter.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
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
    [self apiGetAreaList];
    [self apiGetCategoryList];
}

-(void)setUpView{
    str_placeholder = @"Your message";
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtView.layer.cornerRadius = 10;
    txtView.textColor = [UIColor lightGrayColor];
    txtView.text = str_placeholder;
    
    [self setupDatePickerForTextField:txtClosingDay];
    NSArray *pickerData = @[@"Before Login", @"Retail", @"Admin", @"After login"];
    [txtCategory addPickerWithData:pickerData searchEnabled:NO];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"Start");
    if ([textView.text isEqualToString: str_placeholder]) {
        txtView.text = @"";
        txtView.textColor = [UIColor blackColor];
    }
    //[self setUpMessage];
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"End");
    if ([textView.text isEqualToString: @""]) {
        txtView.text = str_placeholder;
        txtView.textColor = [UIColor lightGrayColor];
    }
    //[self setUpMessage];
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"Start type");
    //txtView.text = @"Test API";
}

#pragma mark: - Button Action

-(IBAction)alertOKBtnAction:(id)sender{
//    if (txtSearchArea.text.length == 0) {
//        [self alertMsg:@"Please enter search area"];
//    }else
//        if (txtClosingDay.text.length == 0) {
//        [self alertMsg:@"Please select closing day"];
//    }else
        if (txtCategory.text.length == 0) {
        [self alertMsg:@"Please select category"];
    } else {
        [self apiGetFilterList];
        filterView.hidden = true;
    }
}

-(IBAction)alertCancleBtnAction:(id)sender{
    filterView.hidden = true;
}

-(IBAction)submitBtnAction:(id)sender{
    if (txtView.text.length == 0 || [txtView.text isEqualToString:str_placeholder]){
        [self alertMsg:@"Please enter your message"];
    }else if (isFilter == NO){
        [self alertMsg:@"Please selecte filter"];
    }else{
        [self sendAlertData:@"" type:@""];
    }
}

#pragma mark: - UITableView DataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filterUserListData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AlertManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertManagementListCell" forIndexPath:indexPath];
    
    cell.subView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.subView.layer.borderWidth = 1;
    cell.subView.layer.cornerRadius = 10;
    NSString *strImgUrl = [[filterUserListData valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
    [cell.imgView setShowActivityIndicatorView:YES];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString: strImgUrl] placeholderImage:[UIImage imageNamed:@"user"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    cell.lblTitleName.text = [NSString stringWithFormat:@"%@",[[filterUserListData valueForKey:@"username"] objectAtIndex:indexPath.row]];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[[filterUserListData valueForKey:@"mobile"] objectAtIndex:indexPath.row]];
    NSString *strCategory = [[filterUserListData valueForKey:@"category"] objectAtIndex:indexPath.row];
    strCategory = SafeString(strCategory);
    cell.lblCategory.text = [NSString stringWithFormat:@"Category - %@",strCategory];
    
    return cell;
}


#pragma mark -  API Method

- (void)apiGetAreaList{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GetAreaList]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"state_id=%@", @""];
    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);
    //request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
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
                self->areaListData = [pDict objectForKey:@"alertadminlist"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->txtSearchArea addPickerWithData:self->areaListData searchEnabled:NO];
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

- (void)apiGetCategoryList{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_CATEGORY]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"catname=%@",@"Not any category"];
    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
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
                self->categoryListData = [[pDict objectForKey:@"catlist"] mutableCopy];
                NSArray *categoryList = [self->categoryListData valueForKey:@"catname"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->txtCategory addPickerWithData:categoryList searchEnabled:NO];
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

- (void)apiGetFilterList{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *str_mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GET_MEMBERLIST]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *strFilter = @"YES";
    NSString *strSearchArea = txtSearchArea.text.length > 0 ? txtSearchArea.text : @"";
    NSString *strClosingDay = txtClosingDay.text.length > 0 ? txtClosingDay.text : @"";
    NSString *strCategory = txtCategory.text.length > 0 ? txtCategory.text : @"Not any category";
    NSString *strGrade = @"Not any grade";
    NSString *strRating = @"Not any rating";
    
    NSString *postString = [NSString stringWithFormat:@"mobile=%@&filter=%@&closingday=%@&area=%@&category=%@&grade=%@&rating=%@",str_mobile,strFilter,strClosingDay,strSearchArea,strCategory,strGrade,strRating];
    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [[BusyIndicator sharedInstance]stopIndicator];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Raw response string: %@", responseString);
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"Register config Response = %@", jsonDict);
                NSMutableDictionary *pDict = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                              error:&error];
                self->isFilter = YES;
                self->filterUserListData = [[pDict objectForKey:@"memberlist"] mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self->filterUserListData.count == 0){
                        [self alertMsg:@"Not found any user"];
                    }
                    self->tblView.hidden = self->filterUserListData.count > 0 ? false : true;
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


#pragma mark -  API Method
/*
- (void)sendAlertData:(NSString *)str_reg_menu type:(NSString *)str_type{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *strGrade = @"Not any grade";
    NSString *strRating = @"Not any rating";
    NSString *strSearchArea = txtSearchArea.text.length > 0 ? txtSearchArea.text : @"";
    NSString *strClosingDay = txtClosingDay.text.length > 0 ? txtClosingDay.text : @"";
    NSString *strCategory = txtCategory.text.length > 0 ? txtCategory.text : @"Not any category";
    
    
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_SendAlerts]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"msg=%@&grade=%@&rating=%@&area=%@&closingday=%@&category=%@",txtView.text,strGrade,strRating,strSearchArea,strClosingDay,strCategory];
    
    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [[BusyIndicator sharedInstance]stopIndicator];
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"Register config Response = %@", jsonDict);
                NSString *status = jsonDict[@"success"];
                NSString *message = jsonDict[@"message"];
                if ([status isEqualToString:@"1"]) {
                    for (NSInteger i = 0; i < [message length]; i++) {
                        NSString *character = [NSString stringWithFormat:@"%C", [message characterAtIndex:i]];
                        //[self->charArray addObject:character];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([str_reg_menu isEqualToString:@""]){
                            // [self setUpSelectedButton];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertMsg:message];
                    });
                }
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
*/
- (void)sendAlertData:(NSString *)str_reg_menu type:(NSString *)str_type {
    [[BusyIndicator sharedInstance] startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    // Safely extract or fallback to defaults
    NSString *strGrade = @"Not any grade";
    NSString *strRating = @"Not any rating";
    NSString *strSearchArea = txtSearchArea.text.length > 0 ? txtSearchArea.text : @"";
    NSString *strClosingDay = txtClosingDay.text.length > 0 ? txtClosingDay.text : @"";
    NSString *strCategory = txtCategory.text;
    NSString *strMessage = txtView.text.length > 0 ? txtView.text : @"";

    // URL encode each parameter
    NSString *(^encode)(NSString *) = ^NSString *(NSString *value) {
        return [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    };

    NSString *encodedMsg = encode(strMessage);
    NSString *encodedGrade = encode(strGrade);
    NSString *encodedRating = encode(strRating);
    NSString *encodedArea = encode(strSearchArea);
    NSString *encodedClosing = encode(strClosingDay);
    NSString *encodedCategory = encode(strCategory);

    NSString *postString = [NSString stringWithFormat:@"msg=%@&grade=%@&rating=%@&area=%@&closingday=%@&category=%@",
                            encodedMsg,
                            encodedGrade,
                            encodedRating,
                            encodedArea,
                            encodedClosing,
                            encodedCategory];

    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_SendAlerts]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // Optional

    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
        });

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:error.localizedDescription];
            });
            return;
        }

        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Raw response string: %@", responseString);

            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (jsonDict && [jsonDict isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"Parsed JSON: %@", jsonDict);

                    NSString *status = jsonDict[@"success"];
                    NSString *message = jsonDict[@"message"];

                    if ([status isEqualToString:@"1"]) {
                        if (str_reg_menu.length == 0) {
                            // [self setUpSelectedButton]; // Optional
                        } else {
                            //[self.navigationController popViewControllerAnimated:YES];
                            [self confirmAlert:message];
                        }
                    } else {
                        [self alertMsg:message ?: @"Unknown error"];
                    }
                } else {
                    if (responseString.length == 0) {
                        [self alertMsg:@"Server returned an empty response."];
                    } else {
                        //[self alertMsg:[NSString stringWithFormat:@"Unexpected response: %@", responseString]];
                        [self confirmAlert:@"Successfull send message"];
                    }
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:@"Empty response from server."];
            });
        }
    }];

    [task resume];
}

-(void)confirmAlert: (NSString *)strMsg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:strMsg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
        //Handel your yes please button action here
        [alert dismissViewControllerAnimated:YES completion:nil];
        if (self.onCloseTapped) {
            self.onCloseTapped();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
