//
//  FeedbackVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "FeedbackVC.h"

@implementation FeedbackVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Customer Feedback";
    [self setUpNavigationBtn];
    arraytblListData = [NSMutableArray array];
    arrayMasterListData = [NSMutableArray array];
    txtViewMsg.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    txtViewMsg.layer.borderWidth = 1;
    [self fetchFeedbackList];
    txtViewMsg.text = @"Enter Message";
}

-(void)setUpNavigationBtn{
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,8,35,35);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(shareNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barSearchBtn, nil];
}

- (void)shareNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        [searchBar setHidden:false];
    }else{
        [searchBar setHidden:true];
        [searchBar resignFirstResponder];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"Start");
    if ([textView.text isEqualToString: @"Enter Message"]) {
        txtViewMsg.text = @"";
        txtViewMsg.textColor = [UIColor blackColor];
    }
    //[self setUpMessage];
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"End");
    if ([textView.text isEqualToString: @""]) {
        txtViewMsg.text = @"Enter Message";
        txtViewMsg.textColor = [UIColor lightGrayColor];
    }
    //[self setUpMessage];
    return true;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        arraytblListData = arrayMasterListData;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"fdate"] lowercaseString];
            NSString *mobile = [item[@"mobile"] lowercaseString];
            NSString *userId = [item[@"narr"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            
            return ([name containsString:searchLower] ||
                    [mobile containsString:searchLower] ||
                    [userId containsString:searchLower]);
        }];
        arraytblListData = [[arrayMasterListData filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [tableview reloadData];
    // });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [arraytblListData removeAllObjects];
    arraytblListData = arrayMasterListData;
    [tableview reloadData];
}

#pragma mark: - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  120;//UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arraytblListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *subContainView = [[UIView alloc] init];
    subContainView.frame = CGRectMake(10, 5, tableView.frame.size.width - 20, 110);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 10;
    subContainView.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_Name = [[UILabel alloc] init];
    lbl_Name.frame = CGRectMake(10, 10, subContainView.frame.size.width - 100, 25);
    [lbl_Name setFont: [UIFont boldSystemFontOfSize:17]];
    lbl_Name.adjustsFontSizeToFitWidth = YES;
    lbl_Name.minimumScaleFactor = 0.7;
    //[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [subContainView addSubview:lbl_Name];
    
    UILabel *lbl_Date = [[UILabel alloc] init];
    lbl_Date.frame = CGRectMake(10, 40, subContainView.frame.size.width - 100, 25);
    [lbl_Date setFont: [UIFont systemFontOfSize:15]];
    [subContainView addSubview:lbl_Date];
    
    UILabel *lbl_Msg = [[UILabel alloc] init];
    lbl_Msg.frame = CGRectMake(10, 70, subContainView.frame.size.width - 100, 25);
    [lbl_Msg setFont: [UIFont systemFontOfSize:15]];
    [subContainView addSubview:lbl_Msg];
    
    
    NSString *str_Name = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"mobile"] objectAtIndex:indexPath.row]];
    NSString *str_Date = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"fdate"] objectAtIndex:indexPath.row]];
    NSString *str_narr = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"narr"] objectAtIndex:indexPath.row]];
    NSString *str_reply = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"reply"] objectAtIndex:indexPath.row]];
    
    lbl_Name.text = str_Name;
    lbl_Date.text = str_Date;
    lbl_Msg.text = str_narr;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(subContainView.frame.size.width-50, 15, 40, 40);
    UIImage *icon = [UIImage imageNamed:@"delete"]; // Use your custom icon here
    //[deleteButton setImage:icon forState:UIControlStateNormal];
    [deleteButton setBackgroundImage: icon forState: UIControlStateNormal];
    deleteButton.tag = indexPath.row;
    [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButton];
    
    //UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *phoneImage = [UIImage systemImageNamed:@"paperplane.circle.fill"];
    sendButton.frame = CGRectMake(subContainView.frame.size.width-50, 65, 40, 40);
   // UIImage *ricon = [UIImage imageNamed:@"quotation.png"]; // Use your custom icon here
    //[sendButton setImage:phoneImage forState:UIControlStateNormal];
    [sendButton setBackgroundImage: phoneImage forState: UIControlStateNormal];
    sendButton.tintColor = [UIColor colorNamed:@"appRed_Color"];
    sendButton.tag = indexPath.row;
    [sendButton addTarget:self action:@selector(sendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:sendButton];
    
    
    return cell;
}

- (void)deleteButtonTapped:(UIButton *)sender {
    // Handle button tap action
    NSString *str_fbid = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"fbid"] objectAtIndex:sender.tag]];
    
    NSLog(@"delete : %@ ",str_fbid);
    
    NSInteger index_c = [sender tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Do you want remove it ?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self deleteFeedback:str_fbid];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendButtonTapped:(UIButton *)sender {
    // Handle button tap action
    NSString *str_fbid = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"fbid"] objectAtIndex:sender.tag]];
    NSString *str_Name = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"mobile"] objectAtIndex:sender.tag]];
    NSString *str_narr = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"narr"] objectAtIndex:sender.tag]];
    NSString *str_reply = [[arraytblListData valueForKey:@"reply"] objectAtIndex:sender.tag];
    NSLog(@"str_reply= %@",str_reply);
    str_reply = SafeString(str_reply);
    if (str_reply.length < 1 ){
        txtViewMsg.text = @"Enter Message";
        txtViewMsg.textColor = [UIColor lightGrayColor];
    }else if ([txtViewMsg.text isEqualToString: @"Enter Message"]) {
        txtViewMsg.text = str_reply;
        txtViewMsg.textColor = [UIColor blackColor];
    }
    
    lblName.text = str_Name;
    lblMsg.text = str_narr;
    
    NSLog(@"send : %@ ",str_fbid);
    NSInteger index_c = [sender tag];
    replyView.tag = index_c;
    replyView.hidden = false;
}

-(IBAction)btnSaveAction:(UIButton *)sender{
    NSLog(@"send view : %ld ",(long)replyView.tag);
    NSString *str_fbid = [NSString stringWithFormat:@"%@",[[arraytblListData valueForKey:@"fbid"] objectAtIndex:replyView.tag]];
    
    if(sender.tag == -4){
        replyView.hidden = true;
    }else{
        if (txtViewMsg.text.length == 0 || [txtViewMsg.text isEqualToString: @"Enter Message"]) {
            [self alertMsgWithTitle:@"Please enter a message" title:@"Alert"];
            return;
        }else{
            [self saveProductList:str_fbid];
            replyView.hidden = true;
        }
    }
}

#pragma mark - API Methods

- (void)fetchFeedbackList {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *urlStr = [[webUrlconstant sharedInstance] URL_Get_Feedback];
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
                NSArray *records = json[@"feedbacklist"];
                if ([records isKindOfClass:[NSArray class]]) {
                    [self->arrayMasterListData removeAllObjects];
                    [self->arraytblListData removeAllObjects];
                    self->arrayMasterListData = [records mutableCopy];
                    self->arraytblListData = [records mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->tableview reloadData];
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

- (void)saveProductList:(NSString *)str_fbid {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *str_reply = txtViewMsg.text;

    NSString *urlStr = [[webUrlconstant sharedInstance] URL_Reply_Feedback];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"reply=%@&fbid=%@", str_reply, str_fbid];
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
                [strongSelf alertMsgWithTitle:error.localizedDescription title:@"Error"];
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![json isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertMsgWithTitle:@"Invalid response from server." title:@"Error"];
            });
            return;
        }
        
        NSString *message = json[@"message"] ?: @"No message received.";
        BOOL status = [json[@"success"] boolValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (status) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                    [self fetchFeedbackList];
                }];
                [alert addAction:okAction];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            } else {
                [strongSelf alertMsgWithTitle:message title:@"Error"];
            }
        });
    }];
    
    [task resume];
}

- (void)deleteFeedback:(NSString *)str_fbid {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *urlStr = [[webUrlconstant sharedInstance] URL_Delete_Feedback];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"fbid=%@", str_fbid];
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
                NSString *message = json[@"message"];
                int status = [json[@"success"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                       message:message
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                            [self fetchFeedbackList];
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }else{
                        [self alertMsg:message];
                    }
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf alertMsg:error.localizedDescription];
            });
        }
    }];
    
    [task resume];
}

@end
