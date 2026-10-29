//
//  OutStanding.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 01/08/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "OutStanding.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "OutstandingTblCell.h"

@interface OutStanding ()
{
    NSString *duepayment;
    BOOL isFilter;
}
@end

@implementation OutStanding

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Outstanding";
    [self setUpNavigationButton];
    isFilter = false;
    duepayment = @"0";
    [seg_control addTarget:self action:@selector(segmentChange:)forControlEvents:UIControlEventValueChanged];
    [self scrollData_item:@"CName" fromDate:@"" toDate:@""];
    [self apiCellResonListData];
    array_FilterList = @[@"CALL NOT PICK", @"WATING", @"UNATTAND", @"CALL BACK", @"CALL BY CUSTOMER", @"DEMO ON VISIT", @"NOT INTERESTED", @"WRONG NO", @"OS RESASON"];
}

- (void)setUpNavigationButton {
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    barFilterBtn.tintColor = [UIColor whiteColor];
    
    UIButton *btn_Short =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Short.frame = CGRectMake(0,5,30,30);
    [btn_Short setImage:[UIImage imageNamed:@"short"] forState:UIControlStateNormal];
    [btn_Short addTarget:self action:@selector(btn_ShortAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shortBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Short];
    shortBarButton.tintColor = [UIColor whiteColor];
    
    UIButton *btn_filterLine =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_filterLine.frame = CGRectMake(0,5,30,30);
    [btn_filterLine setImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease"] forState:UIControlStateNormal];
    [btn_filterLine addTarget:self action:@selector(btn_FilterLine) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *filterLineBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_filterLine];
    filterLineBarButton.tintColor = [UIColor whiteColor];
    
    UIButton *btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,5,30,30);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(searchNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: barSearchBtn, filterLineBarButton, shortBarButton, barFilterBtn, nil];
}

#pragma mark: - Navigation Button action

- (void)filterNavigationButtonAction {
    [self AlertViewFilter];
    isFilter = true;
}

- (void)btn_ShortAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cname" ascending:NO selector:@selector(caseInsensitiveCompare:)];
        array_item = [[array_item sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    } else {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cname" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        array_item = [[array_item sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    }
    
    [self.tableView_outstanding reloadData];
}

- (void)btn_FilterLine{
    [filterView setHidden:NO];
    NSArray *pickerData = @[@"Select Any", @"Date", @"CName", @"Amount", @"Gold", @"Silver"];
    [txtFilter addPickerWithData:pickerData searchEnabled:NO];
}

- (void)searchNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    searchBar.hidden = !sender.selected;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        array_item = masterArray_item;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"cname"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            return ([name containsString:searchLower]);
        }];
        array_item = [[masterArray_item filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    [self.tableView_outstanding reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [array_item removeAllObjects];
    array_item = masterArray_item;
    [self.tableView_outstanding reloadData];
}

#pragma mark:- Segment Method

-(void)segmentChange:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 0 ) {
        NSLog(@" ************************** ***** 0 yes");
        duepayment = @"0";
        [self scrollData_item:@"CName" fromDate:@"" toDate:@""];
        
    } else if (sender.selectedSegmentIndex == 1) {
        NSLog(@" ************************** ***** 1 yes");
        duepayment = @"1";
        [self scrollData_item:@"CName" fromDate:@"" toDate:@""];
        
    } else if (sender.selectedSegmentIndex == 2) {
        [fromToView setHidden:NO];
        [self setupDatePickerForTextField:txtDateFrom];
        [self setupDatePickerForTextField:txtDateTo];
    }
}

#pragma mark:- IBAction Method

- (IBAction)okBtnAction_FilterView:(id)sender{
    NSString *searchLower = [txtFilter.text lowercaseString];
    if ([searchLower isEqualToString:@"select any"]){
        [self scrollData_item:@"CName" fromDate:@"" toDate:@""];
    }else{
        [self scrollData_item:txtFilter.text fromDate:@"" toDate:@""];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->filterView setHidden:YES];
        [self->txtFilter resignFirstResponder];
        [self.tableView_outstanding reloadData];
    });
}

- (IBAction)cancelBtnAction_FilterView:(id)sender{
    [filterView setHidden:YES];
    [txtFilter resignFirstResponder];
}

- (IBAction)okBtnAction_FromToView:(id)sender{
    if (txtDateFrom.text.length == 0 || txtDateTo.text.length == 0) {
        [self alertMsg:@"Please select due dates"];
    } else {
        [self scrollData_item:@"CName" fromDate:txtDateFrom.text toDate:txtDateTo.text];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->fromToView setHidden:YES];
        [self->txtDateFrom resignFirstResponder];
        [self->txtDateTo resignFirstResponder];
        [self.tableView_outstanding reloadData];
    });
}

- (IBAction)cancelBtnAction_FromToView:(id)sender{
    [fromToView setHidden:YES];
    [txtDateFrom resignFirstResponder];
    [txtDateTo resignFirstResponder];
    seg_control.selectedSegmentIndex = [duepayment isEqualToString:@"0"] ? 0 : 1;
    [self segmentChange:seg_control];
}

#pragma mark: - UITableView Datasouce and Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == alertTableView) {
        return isFilter ? 50 : 110;
    }else{
        return 180;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == alertTableView) {
        return isFilter ? array_FilterList.count : [array_todo count];
    }else{
        return [array_item count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView_outstanding dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == alertTableView) {
        if (isFilter) {
            UILabel *lbl_itemname = [[UILabel alloc] init];
            lbl_itemname.frame = CGRectMake(10,5, self.view.frame.size.width-20, 21);
            [lbl_itemname setFont: [UIFont systemFontOfSize:16]];
            lbl_itemname.text = [NSString stringWithFormat:@"%@",[array_FilterList objectAtIndex:indexPath.row]];
            lbl_itemname.textAlignment = NSTextAlignmentLeft;
            lbl_itemname.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl_itemname];
        }else{
            UILabel *lbl_itemname = [[UILabel alloc] init];
            lbl_itemname.frame = CGRectMake(10,5, self.view.frame.size.width-15, 21);
            [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl_itemname.text = [NSString stringWithFormat:@"%@",[[array_todo valueForKey:@"dtime"] objectAtIndex:indexPath.row]];
            lbl_itemname.textAlignment = NSTextAlignmentLeft;
            lbl_itemname.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl_itemname];
            
            UILabel *lbl01 = [[UILabel alloc] init];
            lbl01.frame = CGRectMake(10,25, 100, 21);
            [lbl01 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl01.text = [NSString stringWithFormat:@"Name"];
            lbl01.textAlignment = NSTextAlignmentLeft;
            lbl01.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl01];
            
            UILabel *lbl02 = [[UILabel alloc] init];
            lbl02.frame = CGRectMake(110,25, self.view.frame.size.width-15, 21);
            [lbl02 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl02.text = [NSString stringWithFormat:@"%@",[[array_todo valueForKey:@"cname"] objectAtIndex:indexPath.row]];
            lbl02.textAlignment = NSTextAlignmentLeft;
            lbl02.textColor = [UIColor blackColor];
            [cell.contentView addSubview:lbl02];
            
            UILabel *lbl03 = [[UILabel alloc] init];
            lbl03.frame = CGRectMake(10,45, 100, 21);
            [lbl03 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl03.text = [NSString stringWithFormat:@"Due Date"];
            lbl03.textAlignment = NSTextAlignmentLeft;
            lbl03.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl03];
            
            NSString * str_pay = [[array_todo valueForKey:@"tdate"] objectAtIndex:indexPath.row];
            NSString * str_dtime = [[array_todo valueForKey:@"rtime"] objectAtIndex:indexPath.row];
            NSString *str_var = [NSString stringWithFormat:@" %@ Time : %@",str_pay,str_dtime];
            
            
            UILabel *lbl04 = [[UILabel alloc] init];
            lbl04.frame = CGRectMake(110,45, self.view.frame.size.width-15, 21);
            [lbl04 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl04.text = [NSString stringWithFormat:@"%@",str_var];
            lbl04.textAlignment = NSTextAlignmentLeft;
            lbl04.textColor = [UIColor blackColor];
            [cell.contentView addSubview:lbl04];
            
            UILabel *lbl05 = [[UILabel alloc] init];
            lbl05.frame = CGRectMake(10,65, 100, 21);
            [lbl05 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl05.text = [NSString stringWithFormat:@"Status"];
            lbl05.textAlignment = NSTextAlignmentLeft;
            lbl05.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl05];
            
            UILabel *lbl06 = [[UILabel alloc] init];
            lbl06.frame = CGRectMake(110,65, self.view.frame.size.width-15, 21);
            [lbl06 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl06.text = [NSString stringWithFormat:@"%@",[[array_todo valueForKey:@"status"] objectAtIndex:indexPath.row]];
            lbl06.textAlignment = NSTextAlignmentLeft;
            lbl06.textColor = [UIColor blackColor];
            [cell.contentView addSubview:lbl06];
            
            UILabel *lbl07 = [[UILabel alloc] init];
            lbl07.frame = CGRectMake(10,85, 100, 21);
            [lbl07 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl07.text = [NSString stringWithFormat:@"Remarks"];
            lbl07.textAlignment = NSTextAlignmentLeft;
            lbl07.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl07];
            
            UILabel *lbl08 = [[UILabel alloc] init];
            lbl08.frame = CGRectMake(110,85, self.view.frame.size.width-15, 21);
            [lbl08 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            lbl08.text = [NSString stringWithFormat:@"%@",[[array_todo valueForKey:@"narr"] objectAtIndex:indexPath.row]];
            lbl08.textAlignment = NSTextAlignmentLeft;
            lbl08.textColor = [UIColor blackColor];
            [cell.contentView addSubview:lbl08];
        }
    }else{
        OutstandingTblCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"OutstandingTblCell" forIndexPath:indexPath];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        orderCell.subContainView.layer.borderWidth = 1;
        orderCell.subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
        
        orderCell.lblName.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"cname"] objectAtIndex:indexPath.row]];
        orderCell.lblGrWt.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"grwt"] objectAtIndex:indexPath.row]];
        orderCell.lblRemark.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"remarks"] objectAtIndex:indexPath.row]];
        orderCell.lblSilver.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"fine2"] objectAtIndex:indexPath.row]];
        orderCell.lblGold.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"fine1"] objectAtIndex:indexPath.row]];
        orderCell.lblAmount.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"amount"] objectAtIndex:indexPath.row]];
        NSString *strStatus = [[array_item valueForKey:@"status"] objectAtIndex:indexPath.row];
        NSString *statusValue = SafeString(strStatus);
        orderCell.lblStatus.text = @"";
        if (statusValue.length > 0) {
            orderCell.lblStatus.text = [NSString stringWithFormat:@"%@",strStatus];
        }
        orderCell.lblPayDate.text = [[array_item valueForKey:@"paydate"] objectAtIndex:indexPath.row];
        orderCell.lblLastDate.text = [[array_item valueForKey:@"dtime"] objectAtIndex:indexPath.row];
        
        orderCell.btnSMS.tag = indexPath.row;
        orderCell.btnCall.tag = indexPath.row;
        orderCell.btnWhatsUp.tag = indexPath.row;
        orderCell.btnHistory.tag = indexPath.row;
        orderCell.btnEndCall.tag = indexPath.row;
        
        [orderCell.btnSMS addTarget:self action:@selector(btn_sms:) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.btnCall addTarget:self action:@selector(btn_Call:) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.btnWhatsUp addTarget:self action:@selector(btn_whatsapp:) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.btnHistory addTarget:self action:@selector(btn_history:) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.btnEndCall addTarget:self action:@selector(btn_EndCall:) forControlEvents:UIControlEventTouchUpInside];
        
        orderCell.btnSMS.layer.borderWidth = 1.0f;
        orderCell.btnSMS.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
        orderCell.btnWhatsUp.layer.borderWidth = 1.0f;
        orderCell.btnWhatsUp.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
        orderCell.btnCall.layer.borderWidth = 1.0f;
        orderCell.btnCall.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
        orderCell.btnHistory.layer.borderWidth = 1.0f;
        orderCell.btnHistory.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
        orderCell.btnEndCall.layer.borderWidth = 1.0f;
        orderCell.btnEndCall.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
        
        [orderCell.btnEndCall setHidden:YES];
        NSString *phoneNumber = [[array_item valueForKey:@"mobile"]  objectAtIndex: indexPath.row];
        if ([phoneNumber isEqual: @""]){
            [orderCell.btnSMS setHidden:YES];
            [orderCell.btnCall setHidden:YES];
            //[orderCell.btnHistory setHidden:YES];
        }else{
            [orderCell.btnSMS setHidden:NO];
            [orderCell.btnCall setHidden:NO];
            //[orderCell.btnHistory setHidden:NO];
        }
        NSString *status = [[array_item valueForKey:@"done"]  objectAtIndex: indexPath.row];
        if ([status isEqual: @"00000"] || [status isEqual: @"1"]){
            [orderCell.btnCall setHidden:NO];
            [orderCell.btnEndCall setHidden:YES];
        }else{
            [orderCell.btnCall setHidden:YES];
            NSString *trnid = [[array_item valueForKey:@"trnid"]  objectAtIndex: indexPath.row];
            if ([trnid isEqual: @""]){
                [orderCell.btnEndCall setHidden:YES];
            }else{
                [orderCell.btnEndCall setHidden:NO];
            }
        }
        return orderCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView == alertTableView) && isFilter) {
        NSString *strSelectedLower = [NSString stringWithFormat:@"%@",[array_FilterList objectAtIndex:indexPath.row]];
        NSLog(@"Select item %@",strSelectedLower);
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                NSString *strStatus = item[@"status"];
                NSString *statusValue = [SafeString(strStatus) lowercaseString];
                return ([statusValue containsString:strSelectedLower]);
            }];
            array_item = [[masterArray_item filteredArrayUsingPredicate:predicate] mutableCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_outstanding reloadData];
            [self->alertController dismissViewControllerAnimated:YES completion:nil];
        });
}

#pragma mark:- TableCell Bution Action Method

-(void)btn_Call:(UIButton*)sender{
    NSString *phoneNumber = [[array_item valueForKey:@"mobile"]  objectAtIndex: sender.tag];
    if (![phoneNumber isEqual: @""]){
        
       NSString *acno =   [[array_item valueForKey:@"acno"] objectAtIndex:sender.tag];

        NSString * str_done = [[array_item valueForKey:@"done"] objectAtIndex:sender.tag];
        if ([str_done isEqualToString:@"00000"]) {
            [self save_todo:acno calltype:@"0" duedate:@"" remarks:@"" rtime:@"" trnid:@"" narr:@""];
        }else if ([str_done isEqualToString:@"1"]) {
            [self save_todo:acno calltype:@"0" duedate:@"" remarks:@"" rtime:@"" trnid:@"" narr:@""];
        }else{
            
        }
       
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self phoneCallMethod:phoneNumber];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            OutstandingTblCell *cell = [self.tableView_outstanding cellForRowAtIndexPath:indexPath];
            [cell.btnCall setHidden:YES];
            [cell.btnEndCall setHidden:NO];
            self.resonView.tag = sender.tag;
        });
    }
}

-(void)btn_EndCall:(UIButton*)sender{
    [self.resonView setHidden: NO];
    [self setUpEmptyResonView];
}

-(void)btn_sms:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    //    CustomTodo *alertView = [[CustomTodo alloc] initWithTitle:@"Alert Title" message:@"This is a custom alert message." cancelButtonTitle:@"OK"];
    //    [alertView show];
    
    NSString * strMobile = [[array_item valueForKey:@"mobile"] objectAtIndex:index_c];
    
    NSString * strName = [[array_item valueForKey:@"cname"] objectAtIndex:index_c];
    NSString * strFine1 = [[array_item valueForKey:@"fine1"] objectAtIndex:index_c];
    NSString * strFine2 = [[array_item valueForKey:@"fine2"] objectAtIndex:index_c];
    NSString * strAmount = [[array_item valueForKey:@"amount"] objectAtIndex:index_c];
    
    strMobile = [strMobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *gold = @"";
    if (![strFine1 isEqualToString:@"0.000"]) {
        gold = [NSString stringWithFormat:@", Gold %@", strFine1];
    }
    
    NSString *silver = @"";
    if (![strFine2 isEqualToString:@"0.000"]) {
        silver = [NSString stringWithFormat:@", Silver %@,", strFine2];
    }
    
    NSString *firmname = @"";
    NSString * company = @"";
    if (![company isEqualToString:@""]) {
        firmname = [NSString stringWithFormat:@"FIRM \n%@", company];
    }
    
    NSString *dcSts = @"";
    if ([strAmount intValue] >= 0) {
        dcSts = @"DEBIT";
    } else {
        dcSts = @"CREDIT";
    }
    NSString *messageData = [NSString stringWithFormat: @"Dear %@, Reminder for balance %@ amount.\nPlease pay balance of %@ %@ Amount Rs. %@.\nPLEASE CHECK & CONFIRM.\nThanks.", strName,dcSts,gold,silver,strAmount];
    //[self phoneSMSMethod:messageData number:strMobile];
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        // Optionally, you can pre-fill the recipient and message content
        messageController.recipients = @[strMobile]; // Replace with actual recipient phone number
        messageController.body = messageData;
        // Present the message composer
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Your device doesn't support SMS."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)btn_history:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString * str_pay = [[array_item valueForKey:@"acno"] objectAtIndex:index_c];
    [self apiCellHistoryData:str_pay];
}

-(void)btn_whatsapp:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString * strMobile = [[array_item valueForKey:@"mobile"] objectAtIndex:index_c];
    
    NSString * strName = [[array_item valueForKey:@"cname"] objectAtIndex:index_c];
    NSString * strFine1 = [[array_item valueForKey:@"fine1"] objectAtIndex:index_c];
    NSString * strFine2 = [[array_item valueForKey:@"fine2"] objectAtIndex:index_c];
    NSString * strAmount = [[array_item valueForKey:@"amount"] objectAtIndex:index_c];
    
    strMobile = [strMobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *gold = @"";
    if (![strFine1 isEqualToString:@"0.000"]) {
        gold = [NSString stringWithFormat:@", Gold %@", strFine1];
    }
    
    NSString *silver = @"";
    if (![strFine2 isEqualToString:@"0.000"]) {
        silver = [NSString stringWithFormat:@", Silver %@,", strFine2];
    }
    
    NSString *firmname = @"";
    NSString * company = @"";
    if (![company isEqualToString:@""]) {
        firmname = [NSString stringWithFormat:@"FIRM \n%@", company];
    }
    
    NSString *dcSts = @"";
    if ([strAmount intValue] >= 0) {
        dcSts = @"DEBIT";
    } else {
        dcSts = @"CREDIT";
    }
    
    NSString *messageData = [NSString stringWithFormat: @"Dear %@, Reminder for balance %@ amount.\nPlease pay balance of %@ %@ Amount Rs. %@.\nPLEASE CHECK & CONFIRM.\nThanks.", strName,dcSts,gold,silver,strAmount];
    [self shareOnWhatsApp:messageData phone:strMobile];
    
    /*
     NSString *messageData = @"Dear <CUSTOMER NAME>, Reminder for balance <DC> amount \\nPlease pay balance of <GOLD> <SILVER> Amount Rs. <AMOUNT>\\nPLEASE CHECK & CONFIRM";
     
     messageData = [messageData stringByReplacingOccurrencesOfString:@"<CUSTOMER NAME>" withString:strName];
     messageData = [messageData stringByReplacingOccurrencesOfString:@"<GOLD>" withString:gold];
     messageData = [messageData stringByReplacingOccurrencesOfString:@"<DC>" withString:dcSts];
     messageData = [messageData stringByReplacingOccurrencesOfString:@"<SILVER>" withString:silver];
     messageData = [messageData stringByReplacingOccurrencesOfString:@"<AMOUNT>" withString:strAmount];
     messageData = [messageData stringByAppendingString:firmname];
     
     NSString *str_mobile1 =  [NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=+91%@&text=",strMobile];
     NSString *str_mobile =  [NSString stringWithFormat:@"whatsapp://send?phone=+91%@&text=",messageData];
     NSURL *whatsappURL = [NSURL URLWithString:str_mobile1];
     NSURL *whatsappBusinessURL = [NSURL URLWithString:str_mobile];
     
     if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
     [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
     } else if ([[UIApplication sharedApplication] canOpenURL:whatsappBusinessURL]) {
     [[UIApplication sharedApplication] openURL:whatsappBusinessURL options:@{} completionHandler:nil];
     } else {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"WhatsApp nor WhatsApp Business is installed on this device" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     NSLog(@"Canelled");
     }];
     [alertController addAction:cancelAction];
     [self presentViewController:alertController animated:YES completion:nil];
     }
     */
}

#pragma mark: - Reson list View Method

-(void)setUpResonView:(NSArray *)resonList{
    [self setupDatePickerForTextField:self.txtDate];
    [self setupTimePickerForTextField:self.txtTime];
    NSArray *pickerData = [resonList valueForKey:@"reason"];
    [self.txtSelectReson addPickerWithData:pickerData searchEnabled:NO];
    self.txtViewRemark.layer.borderWidth = 1.0f;
    self.txtViewRemark.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)setUpEmptyResonView{
    self.txtDate.text = @"";
    self.txtTime.text = @"";
    self.txtSelectReson.text = @"";
    self.txtViewRemark.text = @"";
}

-(IBAction)btnOKAction:(UIButton*)sender{
    if (sender.tag == 11){
        [self.resonView setHidden: YES];
    }else{
        
        if (self.txtDate.text.length == 0 ) {
            [self alertMsg:@"Please Select date"];
        }else if (self.txtTime.text.length == 0 ) {
            [self alertMsg:@"Please Select time"];
        }else if (self.txtSelectReson.text.length == 0 ) {
            [self alertMsg:@"Please Select the reson"];
        }else{
            NSString *acno =   [[array_item valueForKey:@"acno"] objectAtIndex:self.resonView.tag];
             NSString *trnid =   [[array_item valueForKey:@"trnid"] objectAtIndex:self.resonView.tag];
            [self save_todo:acno calltype:@"1" duedate:self.txtDate.text remarks:self.txtViewRemark.text rtime:self.txtTime.text trnid:trnid narr:self.txtSelectReson.text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.resonView.tag inSection:0];
                OutstandingTblCell *cell = [self.tableView_outstanding cellForRowAtIndexPath:indexPath];
                [cell.btnCall setHidden:NO];
                [cell.btnEndCall setHidden:YES];
                [self.resonView setHidden: YES];
            });
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark: Alert Method

-(void)Alertswid {
    UIViewController *controller = [[UIViewController alloc]init];
    CGFloat tblHight = self.tableView_outstanding.frame.size.height;
    CGFloat tblListHight = 110 * [array_todo count];
    tblListHight = tblListHight < tblHight ? tblListHight : tblHight - 50;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, tblListHight);
    [controller setPreferredContentSize:rect.size];
    
    [alertTableView reloadData];
    alertTableView  = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [alertTableView setTag:1000];
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    [alertTableView setUserInteractionEnabled:YES];
    [alertTableView setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)AlertViewFilter{
    UIViewController *controller = [[UIViewController alloc]init];
    
    // 3. Title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, controller.view.frame.size.width, 28)];
    titleLabel.text = @"Select Status :-";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    [controller.view addSubview:titleLabel];

    // 4. Separator line
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 8, 480, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [controller.view addSubview:separator];
    
    
    CGFloat tblHight = self.tableView_outstanding.frame.size.height;
    CGFloat tblListHight = 50 * [array_FilterList count] + 50;
    tblListHight = tblListHight < tblHight ? tblListHight : tblHight - 50;
    CGRect rect = CGRectMake(0, CGRectGetMaxY(separator.frame) + 8, self.view.frame.size.width, tblListHight);
    [controller setPreferredContentSize:rect.size];
    
    [alertTableView reloadData];
    alertTableView  = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [alertTableView setTag:1000];
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    [alertTableView setUserInteractionEnabled:YES];
    [alertTableView setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->isFilter = false;
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark: Api Method

-(void)scrollData_item:(NSString *)strFilterBy fromDate:(NSString *)strFromDate toDate:(NSString *)strToDate {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];
    
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *itemstock = strFilterBy; // @"CName";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&duepayment=%@&smacno=%@&ECAT_TYPE_NEW=%@&itemstock=%@&fromDate=%@&toDate=%@",ip,ipusername,pswd,db,ftppath,apptype,duepayment,smacno,ECAT_TYPE,itemstock,strFromDate,strToDate];
        
        URL_API =[WEB_URL URL_OUTSTAND];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/outstand1.php",ip];
        loginRequest=[NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&duepayment=%@&smacno=%@&ECAT_TYPE_NEW=%@&itemstock=%@&fromDate=%@&toDate=%@",ip,ftppath,apptype,duepayment,smacno,ECAT_TYPE,itemstock,strFromDate,strToDate];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&itemstock=%@&fromDate=%@&toDate=%@",apptype,itemstock,strFromDate,strToDate];
        URL_API =[WEB_URL URL_OUTSTAND];
    }
    
    NSLog(@"notification :::::::::::::::  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSURL *url = [NSURL URLWithString:URL_API];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
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
        masterArray_item = [[NSMutableArray alloc] init];
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
            NSArray *sortedArray = [pDict objectForKey:@"outstandings"];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cname" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            array_item = [[sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
            masterArray_item = [array_item mutableCopy];
            [self.tableView_outstanding reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)apiCellHistoryData:(NSString *)str_acno  {
    NSLog(@"acno ************************** %@",str_acno);
    
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"]) 
    {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&acno=%@",apptype,ip,db,ipusername,pswd,ftppath,str_acno];
        
        URL_API = [WEB_URL URL_GETOUT];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_outlog.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&acno=%@",apptype,ftppath,str_acno];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&acno=%@",apptype,str_acno];
        URL_API =[WEB_URL URL_GETOUT];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"api ******************************** %@",api);
    NSLog(@"urlString ******************************** %@",urlString);

    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseHistoryResponse:data];
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

- (void) parseHistoryResponse:(NSData *) data {
    @try {
        
        [[BusyIndicator sharedInstance]stopIndicator];
        array_todo = [[NSMutableArray alloc]init];

        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            [[BusyIndicator sharedInstance]stopIndicator];
            array_todo = [pDict objectForKey:@"todolist"];

            NSLog(@"array_todo :: %@",array_todo);
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->alertTableView reloadData];
            });
            [self Alertswid];
                    
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}




-(void)save_todo:(NSString *)str_acno calltype:(NSString *)calltype duedate:(NSString *)duedate remarks:(NSString *)remarks rtime:(NSString *)rtime trnid:(NSString *)trnid narr:(NSString *)narr  {

    [[BusyIndicator sharedInstance]startIndicator];
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *smacno = [[NSUserDefaults standardUserDefaults]stringForKey:@"smacno"];

    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"])
    {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&smacno=%@&acno=%@&calltype=%@&duedate=%@&rtime=%@&narr=%@&remarks=%@&trnid=%@",apptype,ip,db,ipusername,pswd,ftppath,smacno,str_acno,calltype,duedate,rtime,narr,remarks,trnid];
        
        URL_API = [WEB_URL URL_INSERT_TODO];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_todolist.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&smacno=%@&acno=%@&calltype=%@",apptype,ftppath,smacno,str_acno,calltype];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&smacno=%@&acno=%@&calltype=%@",apptype,smacno,str_acno,calltype];
        URL_API = [WEB_URL URL_INSERT_TODO];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"URL_API ******************************** %@",api);
    NSLog(@"URL_INSERT_TODO ******************************** %@",urlString);

    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseinsert_Api:data];
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


- (void)parseinsert_Api:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"URL_INSERT_TODO_data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
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
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"])
            {
                
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)apiResonList{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *dbname = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSDictionary *params = @{
        @"apptype" : apptype,
        @"ip" : ip,
        @"dbname" : dbname,
        @"ipusername": ipusername,
        @"password": pswd,
        @"ftppath" : ftppath,
    };
    
    NSLog(@"params: %@", params);
    [[APIManager sharedManager] POST: [WEB_URL URL_GET_Reason]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Insert Payment Response: %@", data);
            NSString *success = [data objectForKey:@"success"];
            NSString *orderId = [data objectForKey:@"orderid"];
            NSLog(@"Successfully = %@,  Orderid is = %@",success,orderId);
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.txtCity addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

- (void)apiCellResonListData{

    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];

    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"])
    {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,ip,db,ipusername,pswd,ftppath];
        
        URL_API = [WEB_URL URL_GET_Reason];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_outlog.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@",apptype,ftppath];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@",apptype];
        URL_API =[WEB_URL URL_GET_Reason];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"api ******************************** %@",api);
    NSLog(@"urlString ******************************** %@",urlString);

    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResonListResponse:data];
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

- (void) parseResonListResponse:(NSData *) data {
    @try {
        
        [[BusyIndicator sharedInstance]stopIndicator];
        array_todo = [[NSMutableArray alloc]init];

        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            [[BusyIndicator sharedInstance]stopIndicator];
            NSArray *array_list = [pDict objectForKey:@"reasonlist"];
            NSLog(@"array_todo :: %@",array_list);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpResonView:array_list];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
