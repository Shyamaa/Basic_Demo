//
//  OrderList.m
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "OrderList.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "MainActivity.h"
#import "OrderDetail.h"
#import "OrderListCell.h"
#import "AddDemand.h"
#import "CartItemTblCell.h"
#import "OrderDetailsInfo.h"

#define MENUEWIDTH   250

@interface OrderList ()
{
    BOOL isFilter;
}
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIButton *radioButton1;
@property (nonatomic, strong) UIButton *radioButton2;
@property (nonatomic, strong) UIButton *radioButton3;
@property (nonatomic, copy) NSString *selectedValue;
@property (nonatomic, copy) NSString *type;

@end

@implementation OrderList
@synthesize str_act;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Order";
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    
    nsarray_DetailsOrderListdata =[[NSMutableArray alloc]init];
    
    UIFont *largeFont = [UIFont systemFontOfSize:18.0]; // Change size as needed
    NSDictionary *whiteTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: largeFont
    };
    NSDictionary *blackTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor],
        NSFontAttributeName: largeFont
    };
    [segmentControl setTitleTextAttributes:blackTextAttributes forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:whiteTextAttributes forState:UIControlStateSelected];
    [self setUpNavigation];
    [self scrollData_Category];
    array_FilterList = @[@"ALL", @"Pending", @"In Progress", @"Complete", @"Delivered", @"Reject"];
}

#pragma mark:- Navigation Methods

-(void)setUpNavigation{
    UIButton *  btnAdd =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAdd.frame = CGRectMake(0,0,30,30);
    [btnAdd addTarget:self action:@selector(addBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [[btnAdd imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btnAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    barBtnAdd.tintColor = [UIColor whiteColor];
    
    UIButton *  btnFilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnFilter.frame = CGRectMake(0,0,30,30);
    [btnFilter addTarget:self action:@selector(filterBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter setTitle:@"Filter" forState: UIControlStateNormal];
    UIBarButtonItem *barBtnFilter = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];
    barBtnFilter.tintColor = [UIColor whiteColor];
    
    // Create the button
    UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(0, 0, 30, 30);
    
    // Set the image with template rendering mode
    UIImage *image = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn_delete setBackgroundImage:image forState:UIControlStateNormal];
    
    // Configure button appearance
    [[btn_delete imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_delete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_delete.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_delete.tintColor = [UIColor whiteColor];
    
    // Add the button action
    [btn_delete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithCustomView: btn_delete];
    
    // Assign the UIBarButtonItem to the navigation item
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    self.navigationItem.rightBarButtonItems = @[];
    if ([regmobile isEqualToString:mobile]) {
        if([ECAT_TYPE isEqualToString:@"3"]){
            self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects: barBtnAdd, deleteBarButton, nil];
        }else{
            if (segmentControl.selectedSegmentIndex == 1) {
                self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects: barBtnFilter, deleteBarButton, nil];
            }else{
                self.navigationItem.rightBarButtonItem = deleteBarButton;
            }
        }
    }else if([ECAT_TYPE isEqualToString:@"3"]){
        self.navigationItem.rightBarButtonItem = barBtnAdd;
    }
}

#pragma mark: - Navigation Button Action Methods

-(void)addBarBtnAction:(UIButton*)sender{
    AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)filterBarBtnAction:(UIButton*)sender{
    [self AlertViewFilter];
    isFilter = true;
}

-(void)btnDeleteAction:(UIButton*)sender{
    if ([nsarray_data count] > 0 && segmentControl.selectedSegmentIndex == 0) {
        [self setupPopupView];
    }else if ([nsarray_DetailsOrderListdata count] > 0 && segmentControl.selectedSegmentIndex == 1) {
        [self setupPopupView];
    } else {
        [self alertMsg:@"There is no item to delete."];
    }
}

- (void)setupPopupView {
    // Popup
    self.popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.popupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.popupView];
    
    //container view
    UIView *popupSubView = [[UIView alloc] initWithFrame:CGRectMake(40, (self.view.frame.size.height - 300) / 2, self.view.frame.size.width - 80, 300)];
    popupSubView.backgroundColor = [UIColor whiteColor];
    popupSubView.layer.cornerRadius = 10;
    [self.popupView addSubview: popupSubView];
    
    // Title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, popupSubView.frame.size.width - 20, 30)];
    titleLabel.text = @"Select an Option";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [popupSubView addSubview:titleLabel];
    
    // Create radio buttons
    self.radioButton1 = [self createRadioButtonWithTitle:@" All" frame:CGRectMake(20, 60, popupSubView.frame.size.width - 40, 30)];
    self.radioButton2 = [self createRadioButtonWithTitle:@" Quotation Orders" frame:CGRectMake(20, 100, popupSubView.frame.size.width - 40, 30)];
    self.radioButton3 = [self createRadioButtonWithTitle:@" Add Demand Orders" frame:CGRectMake(20, 140, popupSubView.frame.size.width - 40, 30)];
    
    [popupSubView addSubview:self.radioButton1];
    [popupSubView addSubview:self.radioButton2];
    [popupSubView addSubview:self.radioButton3];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(20, 200, (popupSubView.frame.size.width/2) - 30, 40);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor lightGrayColor];
    cancelButton.layer.cornerRadius = 5;
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [popupSubView addSubview:cancelButton];
    
    // Submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(cancelButton.frame.size.width + 30, 200, (popupSubView.frame.size.width/2) - 30, 40);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [popupSubView addSubview:submitButton];
}

-(void)cancelButtonTapped{
    [self.popupView removeFromSuperview];
}

- (UIButton *)createRadioButtonWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    radioButton.frame = frame;
    [radioButton setImage:[UIImage imageNamed:@"uncheckcircle"] forState:UIControlStateNormal];
    [radioButton setImage:[UIImage imageNamed:@"checkcircle"] forState:UIControlStateSelected];
    [radioButton setTitle:title forState:UIControlStateNormal];
    [radioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [radioButton addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return radioButton;
}

- (void)radioButtonTapped:(UIButton *)sender {
    // Deselect all radio buttons
    self.radioButton1.selected = NO;
    self.radioButton2.selected = NO;
    self.radioButton3.selected = NO;
    // Select the tapped radio button
    sender.selected = YES;
    // Update selectedValue based on the button title
    self.selectedValue = sender.titleLabel.text;
}

- (void)submitButtonTapped {
    if ( self.radioButton1.selected == NO && self.radioButton2.selected == NO &&self.radioButton3.selected == NO ) {
        [self alertMsg:@"Please select an option"];
    }else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
            if (self.radioButton1.selected) {
                self.type = @"1";
            } else if (self.radioButton2.selected) {
                self.type = @"2";
            } else {
                self.type = @"3";
            }
            NSLog(@"Selected Value: %@", self.selectedValue);
            NSLog(@"Type: %@", self.type);
            // Dismiss the popup
            [self dismissViewControllerAnimated:YES completion:nil];
            self.popupView.hidden = YES;
            [self DELETE_DATA];
        }];
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        // Determine the type based on the selected value
    }
}

#pragma mark - Table View Data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == filterTableView) {
        return 50;
    }else{
        return  segmentControl.selectedSegmentIndex == 0 ? 50 : UITableViewAutomaticDimension;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == filterTableView) {
        return array_FilterList.count;
    }else{
        return segmentControl.selectedSegmentIndex == 0 ? [nsarray_data count] : nsarray_DetailsOrderListdata.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == filterTableView) {
        static NSString *myIdentifier = @"MyIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (isFilter) {
            UILabel *lbl_itemname = [[UILabel alloc] init];
            lbl_itemname.frame = CGRectMake(10,10, tableView.frame.size.width-20, 30);
            [lbl_itemname setFont: [UIFont systemFontOfSize:16]];
            lbl_itemname.text = [NSString stringWithFormat:@"%@",[array_FilterList objectAtIndex:indexPath.row]];
            lbl_itemname.textAlignment = NSTextAlignmentCenter;
            lbl_itemname.textColor=[UIColor blackColor];
            [cell.contentView addSubview:lbl_itemname];
        }
        return cell;
    }else{
        if(segmentControl.selectedSegmentIndex == 1){
            CartItemTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemTblCell" forIndexPath:indexPath];
            // Configure the cell
            if (nsarray_DetailsOrderListdata.count == 0 || nsarray_DetailsOrderListdata.count < 1){
                return cell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.imgViewItem.layer setCornerRadius:8.0f];
            [cell.imgViewItem.layer setMasksToBounds:YES];
            [cell.imgViewItem.layer setBorderColor:[UIColor grayColor].CGColor];
            [cell.imgViewItem.layer setBorderWidth:1.0f];
            [cell.imgViewItem setShowActivityIndicatorView:YES];
            if (@available(iOS 13.0, *)) {
                [cell.imgViewItem setIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            } else {
                // Fallback on earlier versions
            }
            NSURL *URL;
            URL = [NSURL URLWithString:[[nsarray_DetailsOrderListdata valueForKey:@"imgname"] objectAtIndex:indexPath.row]];
            NSString *myString = [URL absoluteString];
            [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
            [cell.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                                placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
            
            cell.lblItemName.text = [NSString stringWithFormat:@"%@",[[nsarray_DetailsOrderListdata valueForKey:@"item_idesc"]  objectAtIndex:indexPath.row]];
            cell.lblItemTagNo.text = [NSString stringWithFormat:@"Tag No - %@",[[nsarray_DetailsOrderListdata valueForKey:@"item_tgno"]  objectAtIndex:indexPath.row]];
            cell.lblItemGrossWt.text = [NSString stringWithFormat:@"Gross Wt. - %@",[[nsarray_DetailsOrderListdata valueForKey:@"item_gwt"]  objectAtIndex:indexPath.row]];
            cell.lblItemQuantity.text = [NSString stringWithFormat:@"Quantity. - %@",[[nsarray_DetailsOrderListdata valueForKey:@"item_qty"]  objectAtIndex:indexPath.row]];
            cell.lblItemItemWt.text = [NSString stringWithFormat:@"Item Wt. - %@",[[nsarray_DetailsOrderListdata valueForKey:@"itemwt"]  objectAtIndex:indexPath.row]];
            cell.lblItemMrp.text = [NSString stringWithFormat:@"MRP - %@",[[nsarray_DetailsOrderListdata valueForKey:@"salemrp"]  objectAtIndex:indexPath.row]];
            NSString *strStamp = [[nsarray_DetailsOrderListdata valueForKey:@"stamp"]  objectAtIndex:indexPath.row];
            cell.lblItemStamp.hidden = true;
            if (SafeString(strStamp).length > 0) {
                cell.lblItemStamp.hidden = false;
                cell.lblItemStamp.text = [NSString stringWithFormat:@"Stamp - %@",strStamp];
            }
            
            NSString *strStatus = [[nsarray_DetailsOrderListdata valueForKey:@"status"]  objectAtIndex:indexPath.row];
            cell.lblItemStatus.hidden = true;
            if (SafeString(strStatus).length > 0) {
                cell.lblItemStatus.hidden = false;
                cell.lblItemStatus.text = [NSString stringWithFormat:@"Status - %@",strStatus];
            }
            
             NSString *strRemark = [[nsarray_DetailsOrderListdata valueForKey:@"remarks"]  objectAtIndex:indexPath.row];
             cell.lblItemRemark.hidden = true;
             if (SafeString(strRemark).length > 0) {
             cell.lblItemRemark.hidden = false;
             cell.lblItemRemark.text = [NSString stringWithFormat:@"Remarks - %@",strRemark];
             }
             
            cell.btnEdit.tag = indexPath.row;
            [cell.btnEdit addTarget:self action:@selector(btn_WhatsAppShare:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnDelete.tag = indexPath.row;
            [cell.btnDelete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnDelete.hidden = true;
            cell.btnEdit.hidden = true;
            
            NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
            //if ([ECAT_TYPE isEqualToString:@"3"]) {
            cell.btnDelete.hidden = false;
            cell.btnEdit.hidden = false;
            //}
            
            NSString *chqty = [[NSUserDefaults standardUserDefaults]stringForKey:@"chqty"];
            if ([chqty isEqualToString:@"2"]) {
                cell.btnEdit.hidden = true;
            }
            return cell;
        }else{
            OrderListCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
            
            orderCell.orderNoLabel.text = [NSString stringWithFormat:@"%@",[nsarray_orderno objectAtIndex:indexPath.row]];
            orderCell.remarkLabel.text = [NSString stringWithFormat:@"%@",[nsarray_remarks objectAtIndex:indexPath.row]];
            orderCell.wtLabel.text = [NSString stringWithFormat:@"%@",[nsarray_wt objectAtIndex:indexPath.row]];
            orderCell.dateLabel.text = [NSString stringWithFormat:@"%@",[nsarray_date objectAtIndex:indexPath.row]];
            orderCell.editButton.hidden = true;
            NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
            if([ECAT_TYPE isEqualToString:@"3"]){
                orderCell.editButton.hidden = true;
                orderCell.editButton.tag = indexPath.row;
                [orderCell.editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                NSString *strType = [[nsarray_data objectAtIndex:indexPath.row] valueForKey:@"type"];
                //NSLog(@"Type = %@",strType);
                if([strType isEqualToString:@"ORD"] || [strType isEqualToString:@"REP"]){
                    orderCell.editButton.hidden = false;
                }
                
            }
            return orderCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((tableView == filterTableView) && isFilter) {
        NSString *strSelectedLower = [NSString stringWithFormat:@"%@",[array_FilterList objectAtIndex:indexPath.row]];
        NSLog(@"Select item %@",strSelectedLower);
        [self URL_Filter_Item:strSelectedLower];
        /*
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *strStatus = item[@"status"];
            NSString *statusValue = [SafeString(strStatus) lowercaseString];
            return ([statusValue containsString:strSelectedLower]);
        }];
        //array_item = [[masterArray_item filteredArrayUsingPredicate:predicate] mutableCopy];
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self->alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }else{
        if (segmentControl.selectedSegmentIndex == 0) {
            OrderDetail *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetail"];
            obj.str_orderno = [nsarray_orderno objectAtIndex:indexPath.row];
            obj.str_odate = [nsarray_date objectAtIndex:indexPath.row];
            obj.str_wt = [nsarray_wt objectAtIndex:indexPath.row];
            obj.str_qty = [nsarray_qty objectAtIndex:indexPath.row];
            obj.str_username = [nsarray_username objectAtIndex:indexPath.row];
            obj.str_mobile = [nsarray_mobile objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
        }else if (segmentControl.selectedSegmentIndex == 1){
            OrderDetailsInfo *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsInfo"];
            obj.dicItemData = [nsarray_DetailsOrderListdata objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

#pragma mark: - tbl Button Action Methods

-(void)editBtnAction:(UIButton *)sender{
    NSDictionary *itemData = [nsarray_data objectAtIndex: sender.tag];
    AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
    obj.str_orderno = [nsarray_orderno objectAtIndex:sender.tag];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)btn_WhatsAppShare:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString *strItemId = [[nsarray_DetailsOrderListdata valueForKey:@"cart_id"]objectAtIndex:index_c];
}

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString *strItemId = [[nsarray_DetailsOrderListdata valueForKey:@"cart_id"]objectAtIndex:index_c];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Do you want delete?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        NSLog(@"Do you update delete api, now use cart delete api");
        [self URL_SINGLE_ITEM_DELETE:strItemId];
        
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    //    cart_id = [[nsarray_data valueForKey:@"cart_id"]objectAtIndex:index_c];
    //    [self URL_SINGLE_ITEM_DELETE];
}

#pragma mark: - Button Action Methods

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    [self.tableView reloadData];
    if (selectedIndex == 0) {
        headerStackView.hidden = false;
        headerHight.constant = 40;
        if (nsarray_data.count > 0) {
            //[self.tableView reloadData];
            [self setUpBottom];
        }else{
            [self scrollData_Category];
        }
    } else if (selectedIndex == 1) {
        NSLog(@"Second segment selected");
        headerStackView.hidden = true;
        headerHight.constant = 0;
        if (nsarray_DetailsOrderListdata.count > 0) {
            [self setUpDetailsBottom];
        }else{
            //[self scrollData_DetailsOrder];
            [self URL_Filter_Item:@"ALL"];
        }
    }
    [self setUpNavigation];
}

- (IBAction)btn_short:(UIButton *)sender {
    btn_short.selected = true;
    btn_details.selected = false;
    headerStackView.hidden = false;
    headerHight.constant = 40;
    if (nsarray_data.count > 0) {
        //[self.tableView reloadData];
        [self setUpBottom];
    }else{
        [self scrollData_Category];
    }
}

- (IBAction)btn_details:(UIButton *)sender {
    btn_short.selected = false;
    btn_details.selected = true;
    headerStackView.hidden = true;
    headerHight.constant = 0;
    if (nsarray_DetailsOrderListdata.count > 0) {
        [self setUpDetailsBottom];
    }else{
        //[self scrollData_DetailsOrder];
        [self URL_Filter_Item:@"ALL"];
    }
    //    OrderDetail *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetail"];
    //    obj.str_orderno = @"";
    //    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: - Helper Methods

-(void)setUpBottom{
    self.lblPcValue.text = [NSString stringWithFormat:@"PC - %lu", (unsigned long)[nsarray_data count]];
    float totalWtValue = 0.0;
    for (NSDictionary *dictObject in nsarray_data) {
        NSString *totalwt = dictObject[@"totalwt"];
        if ([totalwt respondsToSelector:@selector(floatValue)]) {
            float itemWtValue = [totalwt floatValue];
            totalWtValue += itemWtValue;
            NSLog(@"The float value is: %f", totalWtValue);
        } else {
            NSLog(@"The string is not a valid number");
        }
    }
    self.lblWtValue.text = [NSString stringWithFormat:@"Wt - %.2f", totalWtValue];
    [self.tableView reloadData];
}

-(void)setUpDetailsBottom{
    float totalWtValue = 0.0;
    for (NSDictionary *dictObject in nsarray_DetailsOrderListdata) {
        NSString *totalwt = dictObject[@"itemwt"];
        totalWtValue += [totalwt floatValue]; // floatValue returns 0.0 if invalid
    }
    self.lblPcValue.text = [NSString stringWithFormat:@"PC - %lu", (unsigned long)nsarray_DetailsOrderListdata.count];
    self.lblWtValue.text = [NSString stringWithFormat:@"Wt - %.2f", totalWtValue];
    [self.tableView reloadData];
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
    
    
    CGFloat tblHight = self.tableView.frame.size.height;
    CGFloat tblListHight = 50 * [array_FilterList count] + 40;
    tblListHight = tblListHight < tblHight ? tblListHight : tblHight - 50;
    CGRect rect = CGRectMake(0, 0, 275, tblListHight);
    [controller setPreferredContentSize:rect.size];
    
    filterTableView  = [[UITableView alloc]initWithFrame:rect];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    filterTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [filterTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [filterTableView setTag:1000];
    [controller.view addSubview:filterTableView];
    [controller.view bringSubviewToFront:filterTableView];
    [controller.view setUserInteractionEnabled:YES];
    [filterTableView setUserInteractionEnabled:YES];
    [filterTableView setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->isFilter = false;
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    [filterTableView reloadData];
}

- (NSString *)safeString:(id)value {
    if (value == nil || value == [NSNull null]) {
        return @"";
    }

    if (![value isKindOfClass:[NSString class]]) {
        value = [value description];
    }

    if ([value isEqualToString:@"(null)"]) {
        return @"";
    }

    return value;
}

#pragma mark: - Api Methods

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category  = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile    = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid    = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *pending = @"Pending";
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    userid = userid.length > 0 ? userid : @"";
    str_act = str_act.length > 0 ? str_act : @"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&act=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,pending,ip,db,ipusername,pswd,ftppath,str_act];
        URL_API =[WEB_URL URL_SHOW_ORDER];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno.php",ip];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@&ftppath=%@&act=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,pending,ftppath,str_act];
    }else{
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&category=%@&mobile=%@&userid=%@&rlid=%@&pending=%@&act=%@",ECAT_TYPE_NEW,apptype,category,mobile,userid,rlid,pending,str_act];
        
        URL_API =[WEB_URL URL_SHOW_ORDER];
    }
    
    NSLog(@"loginRequest orderlist ******************************* %@",loginRequest);
    NSLog(@"URL_API orderlist ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    //Apply the data to
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void) parseResponse_category:(NSData *) data {
    @try {
        //End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        //parsing the JSON response
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
            nsarray_data =[[NSMutableArray alloc]init];
            nsarray_remarks =[[NSMutableArray alloc]init];
            nsarray_wt =[[NSMutableArray alloc]init];
            nsarray_date =[[NSMutableArray alloc]init];
            nsarray_orderno =[[NSMutableArray alloc]init];
            nsarray_qty =[[NSMutableArray alloc]init];
            nsarray_username =[[NSMutableArray alloc]init];
            nsarray_mobile =[[NSMutableArray alloc]init];
            nsarray_data = [pDict objectForKey:@"ordernolist"];
            //            [nsarray_orderno addObject:@"Order No "];
            //            [nsarray_remarks addObject:@"Remarks "];
            //            [nsarray_wt addObject:@"Wt. "];
            //            [nsarray_date addObject:@"Date "];
            //            [nsarray_qty addObject:@"qty "];
            //            [nsarray_username addObject:@"username "];
            //            [nsarray_mobile addObject:@"Mobile "];
            float totalWtValue = 0.0;

            for (int i = 0; i < [nsarray_data count]; i++) {

                NSDictionary *dictObject = [nsarray_data objectAtIndex:i];

                NSString *orderno   = [self safeString:dictObject[@"orderno"]];
                NSString *remarks   = [self safeString:dictObject[@"ord_remark"]];
                NSString *totalwt   = [self safeString:dictObject[@"totalwt"]];
                NSString *item_date = [self safeString:dictObject[@"item_date"]];
                NSString *username  = [self safeString:dictObject[@"username"]];
                NSString *mobile    = [self safeString:dictObject[@"mobile"]];
                NSString *qty       = [self safeString:dictObject[@"qty"]];

                // Calculate total weight
                totalWtValue += [totalwt floatValue];

                // Add values to arrays
                [nsarray_orderno addObject:orderno];
                [nsarray_remarks addObject:remarks];
                [nsarray_wt addObject:totalwt];
                [nsarray_date addObject:item_date];
                [nsarray_username addObject:username];
                [nsarray_mobile addObject:mobile];
                [nsarray_qty addObject:qty];
            }
            NSLog(@"Total Weight: %.3f", totalWtValue);
            [self.tableView reloadData];
            [self setUpBottom];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)scrollData_DetailsOrder {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *activity=@"product";
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    NSString *str_orderno=@"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,str_orderno,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno_item.php",ip];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,str_orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@",apptype,category,mobile,userid,activity,rlid,str_orderno];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
    }
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    
    NSLog(@"URL_API ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    
    //Apply the data to
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_detailsOrder:data];
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

- (void) parseResponse_detailsOrder:(NSData *) data {
    @try {
        // End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments
                                                          error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            nsarray_DetailsOrderListdata = [pDict objectForKey:@"tg_master"];
            NSLog(@"nsarray_details data :: %@",nsarray_DetailsOrderListdata);
            [self setUpDetailsBottom];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)DELETE_DATA{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *is_admin = @"0";
    if ([regmobile isEqualToString:mobile]) {
        is_admin = @"1";
    }
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&is_admin=%@",ECAT_TYPE_NEW,apptype,mobile,self.type,ip,db,ipusername,pswd,ftppath,is_admin];
        
        URL_API = [WEB_URL URL_DELETE_ALL_ORDER];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_all_order.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@&is_admin=%@",ECAT_TYPE_NEW,apptype,mobile,self.type,is_admin];
    }else{
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@",ECAT_TYPE_NEW,apptype,mobile,self.type];
        URL_API = [WEB_URL URL_DELETE_ALL_ORDER];
    }
    NSLog(@"URL_API ***************** %@",URL_API);
    NSLog(@"loginRequest ***************** %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
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
                [self parseResponse_Save:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parseResponse_Save:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
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
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            if ([str_success isEqualToString:@"1"]){
                if (segmentControl.selectedSegmentIndex == 0) {
                    [self scrollData_Category];
                }else if (segmentControl.selectedSegmentIndex == 1) {
                    //[self scrollData_DetailsOrder];
                    [self URL_Filter_Item:@"ALL"];
                }
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                            {}];
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

-(void)URL_SINGLE_ITEM_DELETE:(NSString *)itemId {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,itemId,apptype,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_Order_DELETE];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_order_ecat.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ftppath=%@",mobile,itemId,apptype,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@",mobile,itemId,apptype];
        URL_API =[WEB_URL URL_Order_DELETE];
    }
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    
    NSLog(@"delete prama = %@",loginRequest);
    NSLog(@"delete url = %@", url);
    
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
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SINGLE_ITEM:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parse_SINGLE_ITEM:(NSData *) data {
    @try {
        // End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        //parsing the JSON response
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
            
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            if ([str_success isEqualToString:@"1"]) {
                [self scrollData_DetailsOrder];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                }];
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


-(void)URL_Filter_Item:(NSString *)filterItem {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    userid = SafeString(userid);
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&pending=%@",mobile,userid,apptype,ip,db,ipusername,pswd,ftppath,filterItem];
        URL_API =[WEB_URL URL_Show_Cart];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_cart.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&ftppath=%@&pending=%@",mobile,userid,apptype,ftppath,filterItem];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&pending=%@",mobile,userid,apptype,filterItem];
        URL_API =[WEB_URL URL_Show_Cart];
    }
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    
    NSLog(@"filter prama = %@",loginRequest);
    NSLog(@"filter url = %@", url);
    
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
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_Filter_ITEM:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parse_Filter_ITEM:(NSData *) data {
    @try {
        // End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        //parsing the JSON response
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
            
            nsarray_DetailsOrderListdata = [pDict objectForKey:@"tg_master"];
            NSLog(@"nsarray_details data :: %@",nsarray_DetailsOrderListdata);
            [self setUpDetailsBottom];
            /*
             NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
             NSString *str_success = [arrayResponse_success description];
             NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
             NSString *str_msg = [nsarray_msg description];
             if ([str_success isEqualToString:@"1"]) {
             //[self scrollData_DetailsOrder];
             }else{
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
             message:str_msg
             preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
             style:UIAlertActionStyleDefault
             handler:^(UIAlertAction * action)
             {
             }];
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
             }
             */
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
