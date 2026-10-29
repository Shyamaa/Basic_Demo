//
//  ItemListActivity.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "ItemListActivity.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"
#import "SWRevealViewController.h"
#import "AddItemActivity.h"
#import "ScanViewController.h"

@interface ItemListActivity ()
{
    UIButton *btnAdd_Cart;
    BOOL isSearching_search;
    int startPoint;
}
@end

@implementation ItemListActivity
@synthesize searchBar;

#pragma mark:- Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Item List";
    [self setUpNavigationBtn];
    startPoint = 0;
    searchBar.enablesReturnKeyAutomatically = NO;
    str_search = @"";
    [seg_control addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.btnNext.hidden = false;
    searchBar.placeholder = @"Search";
    
    [self.btnNext setBackgroundColor: [UIColor whiteColor]];
    self.btnNext.layer.cornerRadius = self.btnNext.frame.size.width/2;
    self.btnNext.layer.borderWidth = 1;
    self.btnNext.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    
    [self.btnPrevious setBackgroundColor: [UIColor whiteColor]];
    self.btnPrevious.layer.cornerRadius = self.btnNext.frame.size.width/2;
    self.btnPrevious.layer.borderWidth = 1;
    self.btnPrevious.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    
    array_item = [[NSMutableArray alloc]init];
    array_tgno = [[NSMutableArray alloc]init];
    array_idesc = [[NSMutableArray alloc]init];
    array_image = [[NSMutableArray alloc]init];
    array_imgurl = [[NSMutableArray alloc]init];
    
    arrayAllListData = [[NSMutableArray alloc]init];
    arrayTblListData = [[NSMutableArray alloc]init];
    arrayListImageData = [[NSMutableArray alloc]init];
    arrayListNoImageData = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self scrollData_item:startPoint tag:@""];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    UIButton *  btnAdd =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAdd.frame = CGRectMake(0,8,30,30);
    [btnAdd addTarget:self action:@selector(addBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [[btnAdd imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btnAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    barBtnAdd.tintColor = [UIColor whiteColor];
    
    UIButton * btn_scan =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_scan.frame = CGRectMake(0,8,30,30);
    [btn_scan setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [btn_scan addTarget:self action:@selector(scanNavigationBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [[btn_scan imageView] setContentMode: UIViewContentModeScaleAspectFit];
    UIBarButtonItem *barButton_Scan = [[UIBarButtonItem alloc] initWithCustomView: btn_scan];
    
    
    UIButton *btn_tag =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_tag.frame = CGRectMake(0,8,30,30);
    [btn_tag setBackgroundImage:[UIImage imageNamed:@"tagcalculator_menu.png"] forState:UIControlStateNormal];
    [btn_tag addTarget:self action:@selector(openTagView) forControlEvents:UIControlEventTouchUpInside];
    [[btn_tag imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_tag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_tag.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_tag.tintColor = [UIColor whiteColor];
    UIBarButtonItem *barButton_Tag = [[UIBarButtonItem alloc] initWithCustomView: btn_tag];
    
    if ([ECAT_TYPE isEqualToString:@"3"]){
        //not showing Menu button
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects: barBtnAdd, barButton_Tag, barButton_Scan, nil];
        
    }else{
        SWRevealViewController *revealController = [self revealViewController];
        //[revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        UIImage* image = [UIImage imageNamed:@"menu.png"];
        CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
        [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
        [someButton1 addTarget:revealController action:@selector(revealToggle:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
        if(_openWithSidMenu){
            self.navigationItem.leftBarButtonItem = revealButtonItem;
        }
        
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects: barButton_Tag, barButton_Scan, nil];
    }
}

-(void)addBarBtnAction:(UIButton*)sender{
    AddItemActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItemActivity"];
    obj.str_activity = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)scanNavigationBarButtonAction{
    ScanViewController *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
    obj.str_act =@"Cart Item";
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)openTagView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Tagno" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Please enter Tagno";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField *txt_tagno = alertController.textFields.firstObject;
        if (![txt_tagno.text isEqualToString:@"Please enter Tagno"]) {
            NSString *strTagNo = txt_tagno.text;
            //[self scrollData_InsertItemTag:strTagNo];
            //[self URL_ITEM_Active:strTagNo activity:@"active"];
            [self scrollData_item:self->startPoint tag:strTagNo];
        }else{
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)segmentChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0 ) {
        NSLog(@"Clcik on Segment = 0");
        str_filter = @"";
        isSearching = NO;
        //[self scrollData_item:startPoint];
        [self.tableView_Order reloadData];
    } else if (sender.selectedSegmentIndex == 1) {
        NSLog(@"Clcik on Segment = 1");
        isSearching = YES;
        str_filter = @"image1";
        [self searchTableList];
    }
    else if (sender.selectedSegmentIndex == 2) {
        isSearching = YES;
        str_filter = @"noimage";
        [self searchTableList];
        NSLog(@"Clcik on Segment = 2");
    }
}

- (IBAction)btnNextItem:(UIButton *)sender{
    startPoint += 50;
    if (startPoint > 0){
        self.btnPrevious.hidden = false;
    }
    [self scrollData_item:startPoint tag:@""];
}

- (IBAction)btnPreviousItem:(UIButton *)sender{
    if (startPoint > 0){
        startPoint -= 50;
    }
    if (startPoint < 50){
        self.btnPrevious.hidden = true;
    }
    [self scrollData_item:startPoint tag:@""];
}

#pragma mark:- TableView Delegate and Datasouce

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([str_search isEqualToString:@"search"]){
        return [search_data count];
    }else{
        if (isSearching) {
            return [filter_data count];
        }else{
            return [array_item count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [self.tableView_Order dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *itemImgView = [[UIImageView alloc] init];
    itemImgView.frame = CGRectMake(10, 10, 80, 80);
    //itemImgView.layer.cornerRadius = 10;
    itemImgView.layer.borderColor = UIColor.blackColor.CGColor;
    itemImgView.layer.borderWidth = 1;
    [cell.contentView addSubview:itemImgView];
    
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(110,10, self.view.frame.size.width-170, 22);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lbl_itemname];
    
    UILabel *lbl_itemTag = [[UILabel alloc] init];
    lbl_itemTag.frame = CGRectMake(110,40, self.view.frame.size.width-170, 20);
    [lbl_itemTag setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    lbl_itemTag.textAlignment = NSTextAlignmentLeft;
    lbl_itemTag.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:lbl_itemTag];
    
    UILabel *lbl_Gwt = [[UILabel alloc] init];
    lbl_Gwt.frame = CGRectMake(110, 68, self.view.frame.size.width-170, 20);
    [lbl_Gwt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    lbl_Gwt.textAlignment = NSTextAlignmentLeft;
    lbl_Gwt.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:lbl_Gwt];
    
    UISwitch *btnSwitch = [[UISwitch alloc] init];
    btnSwitch.frame = CGRectMake(self.view.frame.size.width-60.0f, 10.0f, 35.0f, 30.0f);
    
    btnSwitch.onTintColor = [UIColor colorNamed:@"appRed_Color"];
    btnSwitch.tag = indexPath.row;
    [btnSwitch addTarget:self action:@selector(updateSwitchValue:) forControlEvents:UIControlEventValueChanged];
    
    UIButton * btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(self.view.frame.size.width-50.0f, 50.0f, 30.0f, 30.0f);
    btn_delete.titleLabel.font = [UIFont systemFontOfSize:15.0];
    UIImage* image_minus = [UIImage imageNamed:@"delete.png"];
    [btn_delete setBackgroundImage:image_minus forState:UIControlStateNormal];
    btn_delete.tag = indexPath.row;
    [btn_delete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]){
        [cell.contentView addSubview:btnSwitch];
        [cell.contentView addSubview:btn_delete];
    }
   
    
    if([str_search isEqualToString:@"search"]){
        [itemImgView sd_setImageWithURL:[NSURL URLWithString:[[search_data valueForKey:@"imgurl"] objectAtIndex:indexPath.row]]
                       placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
        
        lbl_itemTag.text = [NSString stringWithFormat:@"%@",[[search_data valueForKey:@"tgno"] objectAtIndex:indexPath.row]];
        lbl_itemname.text = [NSString stringWithFormat:@"%@",[[search_data valueForKey:@"idesc"] objectAtIndex:indexPath.row]];
        lbl_Gwt.text = [NSString stringWithFormat:@"%@",[[search_data valueForKey:@"gwt"] objectAtIndex:indexPath.row]];
        NSString *status = [NSString stringWithFormat:@"%@",[[search_data valueForKey:@"status"] objectAtIndex:indexPath.row]];
        btnSwitch.on = [status isEqualToString:@"0"] ? true : false;
    }else{
        if (isSearching) {
            [itemImgView sd_setImageWithURL:[NSURL URLWithString:[[filter_data valueForKey:@"imgurl"] objectAtIndex:indexPath.row]]
                           placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
            lbl_itemTag.text = [NSString stringWithFormat:@"%@",[[filter_data valueForKey:@"tgno"] objectAtIndex:indexPath.row]];
            lbl_itemname.text = [NSString stringWithFormat:@"%@",[[filter_data valueForKey:@"idesc"] objectAtIndex:indexPath.row]];
            lbl_Gwt.text = [NSString stringWithFormat:@"%@",[[filter_data valueForKey:@"gwt"] objectAtIndex:indexPath.row]];
            NSString *status = [NSString stringWithFormat:@"%@",[[filter_data valueForKey:@"status"] objectAtIndex:indexPath.row]];
            btnSwitch.on = [status isEqualToString:@"0"] ? true : false;
        }else{
            [itemImgView sd_setImageWithURL:[NSURL URLWithString:[[array_item valueForKey:@"imgurl"] objectAtIndex:indexPath.row]]
                           placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
            
            lbl_itemTag.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"tgno"] objectAtIndex:indexPath.row]];
            lbl_itemname.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"idesc"] objectAtIndex:indexPath.row]];
            lbl_Gwt.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"gwt"] objectAtIndex:indexPath.row]];
            NSString *status = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"status"] objectAtIndex:indexPath.row]];
            btnSwitch.on = [status isEqualToString:@"0"] ? true : false;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([str_search isEqualToString:@"search"]){
        NSDictionary *itemData = [search_data objectAtIndex: indexPath.row];
        [self openDetails:itemData];
    }else{
        if (isSearching) {
            NSDictionary *itemData = [filter_data objectAtIndex: indexPath.row];
            [self openDetails:itemData];
        }else{
            NSDictionary *itemData = [array_item objectAtIndex: indexPath.row];
            [self openDetails:itemData];
        }
    }
}

-(void)openDetails:(NSDictionary *)itemData{
    NSString * str_imgurl = [itemData valueForKey:@"imgurl"];
    NSString * str_tag = [itemData valueForKey:@"tgno"];
    NSString * str_category = [itemData valueForKey:@"category"];
    NSString * str_gst = [itemData valueForKey:@"gst"];
    NSString * str_gwt = [itemData valueForKey:@"gwt"];
    NSString * str_imgurl2 = [itemData valueForKey:@"imgurl2"];
    NSString * str_imgurl3 = [itemData valueForKey:@"imgurl3"];
    NSString * str_imgurl4 = [itemData valueForKey:@"imgurl4"];
    NSString * str_imgurl5 = [itemData valueForKey:@"imgurl5"];
    NSString * str_mrp = [itemData valueForKey:@"mrp"];
    NSString * str_remarks = [itemData valueForKey:@"remarks"];
    NSString * str_salemrp = [itemData valueForKey:@"salemrp"];
    NSString * str_sdiawt = [itemData valueForKey:@"sdiawt"];
    NSString * str_sstnwt = [itemData valueForKey:@"sstnwt"];
    NSString * str_stamp = [itemData valueForKey:@"stamp"];
    NSString * str_status = [itemData valueForKey:@"status"];
    NSString * str_tgimage = [itemData valueForKey:@"tgimage"];
    NSString * str_tpre = [itemData valueForKey:@"tpre"];
    NSString * str_wt = [itemData valueForKey:@"wt"];
    NSString * str_idesc = [itemData valueForKey:@"idesc"];
    
    AddItemActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItemActivity"];
    obj.str_activity = @"list";
    obj.str_wt = str_wt;
    obj.str_gst = str_gst;
    obj.str_gwt = str_gwt;
    obj.str_mrp = str_mrp;
    obj.str_tag = str_tag;
    obj.str_tgno = str_tag;
    obj.str_tpre = str_tpre;
    obj.str_idesc = str_idesc;
    obj.str_stamp = str_stamp;
    obj.str_imgurl = str_imgurl;
    obj.str_sdiawt = str_sdiawt;
    obj.str_sstnwt = str_sstnwt;
    obj.str_imgurl2 = str_imgurl2;
    obj.str_imgurl3 = str_imgurl3;
    obj.str_imgurl4 = str_imgurl4;
    obj.str_imgurl5 = str_imgurl5;
    obj.str_remarks = str_remarks;
    obj.str_salemrp = str_salemrp;
    obj.str_tgimage = str_tgimage;
    obj.str_min_stock = @"0";
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: Table Cell Button Action Method

-(void)updateSwitchValue:(UISwitch*)sender{
    NSString *statusValue = sender.on ? @"active" : @"inactive";
    NSMutableArray *selectedArray = [str_search isEqualToString:@"search"] ? [search_data mutableCopy]: isSearching ? [filter_data mutableCopy] : [array_item mutableCopy];
    
    NSString *itemTagNo = [[selectedArray valueForKey:@"tgno"] objectAtIndex: sender.tag];
    NSString *msg = [NSString stringWithFormat: @"Do you want %@ %@?",statusValue, itemTagNo];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        if ([statusValue isEqualToString:@"inactive"]){
            [self URL_ITEM_DELETE:itemTagNo activity:@""];
        }else{
            [self URL_ITEM_Active:itemTagNo activity:statusValue];
        }
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        sender.on = !sender.on;
    }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
        NSString * str_tgno = @"";
        if([self->str_search isEqualToString:@"search"]){
            str_tgno = [self->search_tgno objectAtIndex:index_c];
        }else{
            if (self->isSearching) {
                str_tgno = [self->filter_tgno objectAtIndex:index_c];
            }else{
                str_tgno = [[self->array_item valueForKey:@"tgno"] objectAtIndex:index_c];
            }
        }
        [self URL_ITEM_DELETE:str_tgno activity:@"delete"];
    }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)searchTableList {
    filter_tgno = [[NSMutableArray alloc] init];
    filter_idesc = [[NSMutableArray alloc]init];
    filter_image = [[NSMutableArray alloc]init];
    filter_imgurl = [[NSMutableArray alloc]init];
    filter_data = [[NSMutableArray alloc]init];
    
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableArray *rows_newarray = [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",str_filter];
    rows = [NSMutableArray arrayWithArray:[array_image filteredArrayUsingPredicate:predicate]];
    
    NSLog(@"rows = %@",rows);
    
    if([rows count] == 0){
        [self.tableView_Order reloadData];
    }else{
        for (NSString *tempStr in rows) {
            NSIndexSet *indexes = [array_image indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
                NSString *s = (NSString*)obj;
                NSRange range = [s rangeOfString: tempStr];
                return range.location != NSNotFound;
            }];
            [rows_newarray addObjectsFromArray:[array_tgno objectsAtIndexes:indexes]];
        }
        for(int j = 0; j < [rows_newarray count]; j++){
            for(int k = j+1;k < [rows_newarray count];k++){
                NSString *str1 = [rows_newarray objectAtIndex:j];
                NSString *str2 = [rows_newarray objectAtIndex:k];
                if([str1 isEqualToString:str2])
                    [rows_newarray removeObjectAtIndex:k];
            }
        }
        NSLog(@"rows_newarray = %@",rows_newarray);
        for (NSString *tempStr_a in rows_newarray) {
            NSUInteger index_new = [array_tgno indexOfObject:tempStr_a];
            NSLog(@"index = = %lu",(unsigned long)index);
            [filter_data addObject:[array_item objectAtIndex:index_new]];
            [filter_tgno addObject:[array_tgno objectAtIndex:index_new]];
            [filter_image addObject:[array_image objectAtIndex:index_new]];
            [filter_idesc addObject:[array_idesc objectAtIndex:index_new]];
            [filter_imgurl addObject:[array_imgurl objectAtIndex:index_new]];
            [self.tableView_Order reloadData];
        }
    }
    
    NSLog(@"filter_data :::: %@",filter_data);
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching_search = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching_search = YES;
        [self searchTableList_search];
    }
    else {
        isSearching_search = NO;
    }
    [self.tableView_Order reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    NSLog(@"Search Clicked");
    [self.searchBar resignFirstResponder];
    [self searchTableList_search];
}

- (void)removeAllData{
    [array_item removeAllObjects];
    [array_tgno removeAllObjects];
    [array_idesc removeAllObjects];
    [array_image removeAllObjects];
    [array_imgurl removeAllObjects];
    
    [search_data removeAllObjects];
    [filter_data removeAllObjects];
    
    [self.tableView_Order reloadData];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchTableList_search {
    search_tgno = [[NSMutableArray alloc] init];
    search_idesc = [[NSMutableArray alloc]init];
    search_image = [[NSMutableArray alloc]init];
    search_imgurl = [[NSMutableArray alloc]init];
    search_data = [[NSMutableArray alloc]init];
    
    NSString *searchString = searchBar.text;
    str_search =@"search";
    
    if(str_filter.length == 0){
        NSMutableArray *rows = [NSMutableArray array];
        NSMutableArray *rows_newarray = [NSMutableArray array];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",searchString];
        rows = [NSMutableArray arrayWithArray:[array_tgno filteredArrayUsingPredicate:predicate]];
        
        NSLog(@"rows = %@",rows);
        
        if([rows count] == 0){
            [self.tableView_Order reloadData];
        }else{
            for (NSString *tempStr in rows) {
                NSIndexSet *indexes = [array_tgno indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
                    NSString *s = (NSString*)obj;
                    NSRange range = [s rangeOfString: tempStr];
                    return range.location != NSNotFound;
                }];
                [rows_newarray addObjectsFromArray:[array_tgno objectsAtIndexes:indexes]];
            }
            for(int j = 0; j < [rows_newarray count]; j++){
                for(int k = j+1;k < [rows_newarray count];k++){
                    NSString *str1 = [rows_newarray objectAtIndex:j];
                    NSString *str2 = [rows_newarray objectAtIndex:k];
                    if([str1 isEqualToString:str2])
                        [rows_newarray removeObjectAtIndex:k];
                }
            }
            NSLog(@"rows_newarray = %@",rows_newarray);
            for (NSString *tempStr_a in rows_newarray) {
                NSUInteger index_new = [array_tgno indexOfObject:tempStr_a];
                NSLog(@"index = = %lu",(unsigned long)index);
                [search_tgno addObject:[array_tgno objectAtIndex:index_new]];
                [search_image addObject:[array_image objectAtIndex:index_new]];
                [search_idesc addObject:[array_idesc objectAtIndex:index_new]];
                [search_imgurl addObject:[array_imgurl objectAtIndex:index_new]];
                [search_data addObject:[array_item objectAtIndex:index_new]];
                [self.tableView_Order reloadData];
            }
        }
    }else{
        NSMutableArray *rows = [NSMutableArray array];
        NSMutableArray *rows_newarray = [NSMutableArray array];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",searchString];
        rows = [NSMutableArray arrayWithArray:[filter_tgno filteredArrayUsingPredicate:predicate]];
        
        NSLog(@"rows = %@",rows);
        
        if([rows count] == 0){
            [self.tableView_Order reloadData];
        }else{
            for (NSString *tempStr in rows) {
                NSIndexSet *indexes = [filter_tgno indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
                    NSString *s = (NSString*)obj;
                    NSRange range = [s rangeOfString: tempStr];
                    return range.location != NSNotFound;
                }];
                [rows_newarray addObjectsFromArray:[filter_tgno objectsAtIndexes:indexes]];
            }
            for(int j = 0; j < [rows_newarray count]; j++){
                for(int k = j+1;k < [rows_newarray count];k++){
                    NSString *str1 = [rows_newarray objectAtIndex:j];
                    NSString *str2 = [rows_newarray objectAtIndex:k];
                    if([str1 isEqualToString:str2])
                        [rows_newarray removeObjectAtIndex:k];
                }
            }
            NSLog(@"rows_newarray = %@",rows_newarray);
            for (NSString *tempStr_a in rows_newarray) {
                NSUInteger index_new = [filter_tgno indexOfObject:tempStr_a];
                NSLog(@"index = = %lu",(unsigned long)index);
                [search_tgno addObject:[filter_tgno objectAtIndex:index_new]];
                [search_image addObject:[filter_image objectAtIndex:index_new]];
                [search_idesc addObject:[filter_idesc objectAtIndex:index_new]];
                [search_imgurl addObject:[filter_imgurl objectAtIndex:index_new]];
                [search_data addObject:[array_item objectAtIndex:index_new]];
                [self.tableView_Order reloadData];
            }
        }
    }
    
    NSLog(@"search_data :::: %@",search_data);
    
}

#pragma mark:- Api Method

-(void)scrollData_item:(int)startPoint tag:(NSString *)str_TagNo {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *idesc = self.strIdesc.length > 0 ? self.strIdesc : @"";
    NSString *flag = [str_TagNo isEqualToString: @""] ? @"" : @"scan";
    NSString *str_SPoint = [NSString stringWithFormat:@"%d",startPoint];
    NSString *endPoint = @"100";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&idesc=%@&flag=%@&ECAT_TYPE_NEW=%@&spoint=%@&epoint=%@&tgno=%@",ip,ipusername,pswd,db,ftppath,apptype,idesc,flag,ECAT_TYPE,str_SPoint,endPoint,str_TagNo];
        
        URL_API =[WEB_URL URL_GET_DESIGN];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_tgno.php",ip];
        loginRequest = [NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&idesc=%@&flag=%@&ECAT_TYPE_NEW=%@&spoint=%@&epoint=%@&tgno=%@",ip,ftppath,apptype,idesc,flag,ECAT_TYPE,str_SPoint,endPoint,str_TagNo];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&idesc=%@&spoint=%@&epoint=%@&tgno=%@",apptype, idesc, str_SPoint, endPoint,str_TagNo];
        URL_API = [WEB_URL URL_GET_DESIGN];
    }
    NSLog(@"notification :::::::::::::::  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
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
                [self parseResponse_itemcat:data tag:str_TagNo];
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

- (void) parseResponse_itemcat:(NSData *) data tag:(NSString *)str_TagNo {
    @try {
        [self removeAllData];
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
            
            // arrayListNoImageData = [[pDict objectForKey:@"tgnolist"] mutableCopy];
            // arrayTblListData = [arrayListNoImageData mutableCopy];
            NSArray *arrayItemData = [pDict objectForKey:@"tgnolist"];
            if (![str_TagNo isEqualToString: @""] && str_TagNo.length > 0 && arrayItemData.count > 0) {
                NSDictionary *itemData = arrayItemData.firstObject;
                [self openDetails:itemData];
            }else{
                array_item = [arrayItemData mutableCopy];
                NSLog(@"array_item_aaa ::::::: %@",array_item);
            self.btnNext.hidden = array_item.count == 0 || (array_item.count < 50 && startPoint == 0) ;
            for (int i = 0; i < [array_item count]; i++){
                NSDictionary * dictObject = [array_item objectAtIndex:i];
                NSString *idesc = [dictObject objectForKey:@"idesc"];
                NSString *image = [dictObject objectForKey:@"image"];
                NSString *tgno = [dictObject objectForKey:@"tgno"];
                NSString *imgurl = [dictObject objectForKey:@"imgurl"];
                
                [array_tgno addObject:tgno];
                [array_idesc addObject:idesc];
                [array_image addObject:image];
                [array_imgurl addObject:imgurl];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self segmentChange:self->seg_control];
                [self.tableView_Order reloadData];
            });
        }
    }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_ITEM_Active:(NSString *)str_tgno activity:(NSString *)activity{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *str_Activity = [activity isEqualToString:@"inactive"] ? @"INACTIVE" :  @"IN STOCK";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&activity=%@",mobile,str_tgno,apptype,ip,db,ipusername,pswd,ftppath,str_Activity];
        
        URL_API =[WEB_URL URL_Active_TGNO];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/active_tagno.php",ip];
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ftppath=%@&activity=%@",mobile,str_tgno,apptype,ftppath,str_Activity];
        
    }else{
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&activity=%@",mobile,str_tgno,apptype,str_Activity];
        URL_API =[WEB_URL URL_Active_TGNO];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_Active_ITEM:data];
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


- (void)parse_Active_ITEM:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"Active JSON data = %@", myData);
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
                [self scrollData_item:startPoint tag:@""];
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

-(void)URL_ITEM_DELETE:(NSString *)str_tgno activity:(NSString *)activity{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    //NSString *activity = @"delete";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&activity=%@",mobile,str_tgno,apptype,ip,db,ipusername,pswd,ftppath,activity];
        
        URL_API =[WEB_URL URL_DELETE_TGNO];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_tagno.php",ip];
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ftppath=%@&activity=%@",mobile,str_tgno,apptype,ftppath,activity];
        
    }else{
        loginRequest = [NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&activity=%@",mobile,str_tgno,apptype,activity];
        URL_API =[WEB_URL URL_DELETE_TGNO];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SINGLE_ITEM:data];
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


- (void)parse_SINGLE_ITEM:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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
                [self scrollData_item:startPoint tag:@""];
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

#pragma mark: - Get Item with Tag Api method

-(void)scrollData_InsertItemTag:(NSString *)strTagNo {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *visid=@"0";
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,strTagNo,mobile,visid,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_INSERT_ITEMTAG];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_itemtag.php",ip];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,strTagNo,mobile,visid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@",ECAT_TYPE_NEW,apptype,strTagNo,mobile,visid];
        URL_API =[WEB_URL URL_INSERT_ITEMTAG];
    }
    
    NSLog(@"URL_API :::::::::::::::::::::::::::::: %@",URL_API);
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
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_ItemTagSave:data];
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

- (void)parseResponse_ItemTagSave:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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
                [self scrollData_item:startPoint tag:@""];
            }else{
                [self alertMsg:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
