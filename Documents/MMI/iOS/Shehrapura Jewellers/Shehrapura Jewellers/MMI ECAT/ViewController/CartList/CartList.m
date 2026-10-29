//
//  CartList.m
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "CartList.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ScanViewController.h"
#import "MainActivity.h"
#import "PaymentActivity.h"
#import "CartItemTblCell.h"
#import "Gautom_HomeVC.h"
#import "ItemDetail.h"

#define MENUEWIDTH   250
#define IS_iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define IS_iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define IS_iPhone6 ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_iPhone6Plus ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE
#define IS_iPhoneiPad ([[UIScreen mainScreen] bounds].size.height == 1024)?TRUE:FALSE
#define IS_iPhoneX ([[UIScreen mainScreen] bounds].size.height == 812)?TRUE:FALSE
#define IS_iPhoneipad12 ([[UIScreen mainScreen] bounds].size.height == 1366)?TRUE:FALSE
#define IS_iPhoneipad10 ([[UIScreen mainScreen] bounds].size.height == 1112)?TRUE:FALSE
#define IS_iPhoneXsmax ([[UIScreen mainScreen] bounds].size.height == 896)?TRUE:FALSE



@interface CartList ()
{
    UITextField *myTextField;
    NSString *tagno;
}
@end
@implementation CartList
static int myCounter;
@synthesize str_rlid,str_idesc,str_activity,str_tag;

#pragma mark - Class Cycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Cart";
    [self setUpNavigationBar];
    [self scrollData_Category];
    self.tableView.estimatedRowHeight = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 228 : 150.0f;  // You can set this to any reasonable estimated height
    self.tableView.rowHeight = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 228 : UITableViewAutomaticDimension;
    
//    self.tableView.estimatedRowHeight = 150.0f;  // You can set this to any reasonable estimated height
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if(str_tag.length !=0){
        self->tagno = str_tag;
        [self scrollData_InsertItemTag];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    btnAdd_Cart.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    btnAdd_Cart.hidden=YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)setUpNavigationBar{
    self.navigationController.navigationBarHidden=NO;
    if ([str_activity isEqualToString:@"MMI HOME"]) {
        UIButton *add_Button =  [UIButton buttonWithType:UIButtonTypeContactAdd];
        [add_Button addTarget:self action:@selector(addNavigationBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [add_Button setFrame:CGRectMake(0, 0, 30, 30)];
        UIBarButtonItem *barButton_Add = [[UIBarButtonItem alloc] initWithCustomView:add_Button];
        
        UIButton * btn_scan =  [UIButton buttonWithType:UIButtonTypeCustom];
        btn_scan.frame = CGRectMake(0,8,30,30);
        [btn_scan setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [btn_scan addTarget:self action:@selector(scanNavigationBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [[btn_scan imageView] setContentMode: UIViewContentModeScaleAspectFit];
        UIBarButtonItem *barButton_Scan = [[UIBarButtonItem alloc] initWithCustomView: btn_scan];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        space.width = 10;
        
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:barButton_Add, space, barButton_Scan, nil];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backNavigationButtonAction)];
        self.navigationItem.leftBarButtonItem = btn;
    }
}

#pragma mark - Navigation Button Action Method

-(void)backNavigationButtonAction{
    //    MMIHOMEPanel *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
    //    [self.navigationController pushViewController:obj animated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MMIHOMEPanel class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

- (void)scanNavigationBarButtonAction{
    ScanViewController *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
    obj.str_act =@"Cart Item";
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)addNavigationBarButtonAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Tagno" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Please enter Tagno";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txt_tagno = alertController.textFields.firstObject;
        if (![txt_tagno.text isEqualToString:@"Please enter Tagno"]) {
            self->tagno = txt_tagno.text;
            [self scrollData_InsertItemTag];
        }
        else{
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
        self->tagno=@"";
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextfield Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField== text_remarks) {
        [text_remarks resignFirstResponder];
    }  else{
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[nsarray_data valueForKey:@"item1"] count] > 0){
        [self.bottomView setHidden:NO];
        [self.bottomButtonView setHidden:NO];
        [self.lblEmptyOrder setHidden:YES];
    }else{
        [self.bottomView setHidden:YES];
        [self.bottomButtonView setHidden:YES];
        [self.lblEmptyOrder setHidden:NO];
    }
    return [[nsarray_data valueForKey:@"item1"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CartItemTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemTblCell" forIndexPath:indexPath];
    // Configure the cell
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
    URL = [NSURL URLWithString:[[nsarray_data valueForKey:@"itemimage"] objectAtIndex:indexPath.row]];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    [cell.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                        placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    cell.imgViewItem.contentMode = UIViewContentModeScaleAspectFill;
    cell.lblItemName.text = [NSString stringWithFormat:@"%@",[[nsarray_data valueForKey:@"idesc"]  objectAtIndex:indexPath.row]];
    cell.lblItemTagNo.text = [NSString stringWithFormat:@"Tag No - %@",[[nsarray_data valueForKey:@"tgno"]  objectAtIndex:indexPath.row]];
    cell.lblItemGrossWt.text = [NSString stringWithFormat:@"Gross Wt. - %@",[[nsarray_data valueForKey:@"item_gwt"]  objectAtIndex:indexPath.row]];
    cell.lblItemStamp.text = [NSString stringWithFormat:@"Stamp - %@",[[nsarray_data valueForKey:@"stamp"]  objectAtIndex:indexPath.row]];
    cell.lblItemQuantity.text = [NSString stringWithFormat:@"Quantity. - %@",[[nsarray_data valueForKey:@"item_qty"]  objectAtIndex:indexPath.row]];
    cell.lblItemItemWt.text = [NSString stringWithFormat:@"Item Wt. - %@",[[nsarray_data valueForKey:@"itemwt"]  objectAtIndex:indexPath.row]];
    cell.lblItemMrp.text = [NSString stringWithFormat:@"MRP - %@",[[nsarray_data valueForKey:@"salemrp"]  objectAtIndex:indexPath.row]];
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btn_edit:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEdit setHidden : NO];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cell.lblItemName.font = [UIFont systemFontOfSize:28.0];
        cell.lblItemTagNo.font = [UIFont systemFontOfSize:24.0];
        cell.lblItemGrossWt.font = [UIFont systemFontOfSize:24.0];
        
        cell.lblItemStamp.font = [UIFont systemFontOfSize:24.0];
        cell.lblItemQuantity.font = [UIFont systemFontOfSize:24.0];
        cell.lblItemItemWt.font = [UIFont systemFontOfSize:24.0];
        cell.lblItemMrp.font = [UIFont systemFontOfSize:24.0];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemDetail *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetail"];
    obj.str_idesc=[[nsarray_data valueForKey:@"idesc"]objectAtIndex:indexPath.row];
    obj.str_image=[[nsarray_data valueForKey:@"itemimage"]objectAtIndex:indexPath.row];
    obj.str_image2=[[nsarray_data valueForKey:@"itemimage2"]objectAtIndex:indexPath.row];
    obj.str_image3=[[nsarray_data valueForKey:@"itemimage3"]objectAtIndex:indexPath.row];
    obj.str_image4=[[nsarray_data valueForKey:@"itemimage4"]objectAtIndex:indexPath.row];
    obj.str_image5=[[nsarray_data valueForKey:@"itemimage5"]objectAtIndex:indexPath.row];
    obj.str_tagno=[[nsarray_data valueForKey:@"tgno"]objectAtIndex:indexPath.row];
    obj.str_gwt=[[nsarray_data valueForKey:@"gwt"]objectAtIndex:indexPath.row];
    obj.str_qty=[[nsarray_data valueForKey:@"qty"]objectAtIndex:indexPath.row];
    obj.str_tpre=[[nsarray_data valueForKey:@"tpre"]objectAtIndex:indexPath.row];
    obj.str_design=[[nsarray_data valueForKey:@"design"]objectAtIndex:indexPath.row];
    obj.str_tsno=[[nsarray_data valueForKey:@"tsno"]objectAtIndex:indexPath.row];
    obj.str_item1=[[nsarray_data valueForKey:@"item1"]objectAtIndex:indexPath.row];
    obj.str_item2=[[nsarray_data valueForKey:@"item2"]objectAtIndex:indexPath.row];
    obj.str_item3=[[nsarray_data valueForKey:@"item3"]objectAtIndex:indexPath.row];
    obj.str_item4=[[nsarray_data valueForKey:@"item4"]objectAtIndex:indexPath.row];
    obj.str_rlid=@"0";
    obj.str_remarks=[[nsarray_data valueForKey:@"remarks"]objectAtIndex:indexPath.row];
    obj.str_shpc=@"0";
    obj.str_stamp=[[nsarray_data valueForKey:@"stamp"]objectAtIndex:indexPath.row];
    obj.str_tgimage=[[nsarray_data valueForKey:@"tgimage"]objectAtIndex:indexPath.row];
    obj.str_wt1=[[nsarray_data valueForKey:@"wt1"]objectAtIndex:indexPath.row];
    
    obj.str_status=[[nsarray_data valueForKey:@"status"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    cart_id = [[nsarray_data valueForKey:@"cart_id"]objectAtIndex:index_c];
    [self URL_SINGLE_ITEM_DELETE];
}

-(void)btn_edit:(UIButton*)sender{
    if(IS_iPhone6Plus){
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }else if (IS_iPhone6){
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }else if(IS_iPhone5){
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }else if (IS_iPhone4){
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }else{
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.5f;
    transparentView.clipsToBounds = NO;
    transparentView.layer.shadowColor = [UIColor blackColor].CGColor;
    transparentView.layer.shadowOpacity = 0.0;
    transparentView.layer.shadowRadius = 0.0;
    [self.view addSubview:transparentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    imageView.image = [UIImage imageNamed:@"transprant.png"];
    [transparentView addSubview:imageView];
    index_cart = [sender tag];
    
    [self PopupEditCartView];
    
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{}completion:NULL];
}

-(void)PopupEditCartView{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 300.0f, 280.0f)];
    view1.backgroundColor = [UIColor colorNamed:@"border_Color"];
    view1.center = self.view.center;
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = true;
    [[self view] addSubview:view1];
    
    UIButton * btn_minus = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_minus.frame = CGRectMake(90.0f, 70.0f, 30.0f, 30.0f);
    //UIImage* image_minus = [UIImage imageNamed:@"minus.png"];
    //[btn_minus setBackgroundImage:image_minus forState:UIControlStateNormal];
    [btn_minus setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_minus setTitle:@"-" forState: UIControlStateNormal];
    [btn_minus setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn_minus setClipsToBounds:YES];
    btn_minus.layer.cornerRadius = 15;
    [btn_minus addTarget:self action:@selector(btn_minus:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_minus];
    
    UIButton * btn_plus = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_plus.frame = CGRectMake(180.0f, 70.0f, 30.0f, 30.0f);
    //UIImage* image_plus = [UIImage imageNamed:@"plus.png"];
    //[btn_plus setBackgroundImage:image_plus forState:UIControlStateNormal];
    [btn_plus setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_plus setTitle:@"+" forState: UIControlStateNormal];
    [btn_plus setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn_plus setClipsToBounds:YES];
    btn_plus.layer.cornerRadius = 15;
    [btn_plus addTarget:self action:@selector(btn_plus:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_plus];
    
    NSString *str_qty = [[nsarray_data valueForKey:@"item_qty"]objectAtIndex:index_cart];;
    CGRect someRect = CGRectMake(125.0, 70.0, 50.0, 30.0);
    text_count = [[UITextField alloc] initWithFrame:someRect];
    text_count.text = str_qty;
    text_count.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:text_count];
    
    CGRect someRect_remarks = CGRectMake(50.0, 125.0, 200, 30.0);
    text_remarks = [[UITextField alloc] initWithFrame:someRect_remarks];
    text_remarks.placeholder=@"Remarks";
    text_remarks.textAlignment=NSTextAlignmentCenter;
    text_remarks.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:text_remarks];
    
    UIButton * btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(155.0f, 180.0f, 90.0f, 30.0f);
    //UIImage* image_save = [UIImage imageNamed:@"ok.png"];
    //[btn_save setBackgroundImage:image_save forState:UIControlStateNormal];
    [btn_save setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_save setTitle:@"OK" forState: UIControlStateNormal];
    [btn_save setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn_save.layer.cornerRadius = 5;
    [btn_save addTarget:self action:@selector(btn_ok:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_save];
    
    UIButton * btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cancel.frame = CGRectMake(55.0f, 180.0f, 90.0f, 30.0f);
    //UIImage* image_cancel = [UIImage imageNamed:@"cancel.png"];
    //[btn_cancel setBackgroundImage:image_cancel forState:UIControlStateNormal];
    [btn_cancel setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_cancel setTitle:@"Cancel" forState: UIControlStateNormal];
    [btn_cancel setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn_cancel.layer.cornerRadius = 5;
    [btn_cancel addTarget:self action:@selector(btn_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_cancel];
}

#pragma mark - PopupEditCartView Button Action Methods

-(void)btn_plus:(UIButton*)sender{
    NSString *str_total = text_count.text;
    int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
    NSLog(@"%d", aValue);
    aValue = aValue + 1;
    NSString* myNewString = [NSString stringWithFormat:@"%i", aValue];
    text_count.text = myNewString;
    myCounter++;
    NSLog(@"myCounter =%d",myCounter);
}

-(void)btn_minus:(UIButton*)sender{
    NSString *str_total = text_count.text;
    if ([str_total isEqualToString:@"0"]){
        
    }else{
        int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        NSLog(@"%d", aValue);
        aValue = aValue-1;
        NSString *myNewString = [NSString stringWithFormat:@"%i", aValue];
        text_count.text = myNewString;
        myCounter--;
        NSLog(@"myCounter =%d",myCounter);
    }
}

-(void)btn_cancel:(UIButton*)sender{
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{}completion:NULL];
    transparentView.hidden = YES;
    view1.hidden = YES;
}

-(void)btn_ok:(UIButton*)sender{
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{}completion:NULL];
    
    transparentView.hidden = YES;
    view1.hidden = YES;
    [self scrollData_InsertItem];
    [self.tableView reloadData];
}

#pragma mark - IBAction Button Action Methods

- (IBAction)btn_order_cart:(id)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want Order" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self URL_SAVE_ORDER];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btn_clear_cart:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                  message:@"Do you want clear"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
        [self URL_CLEAR_CART];
    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btn_Share_cart:(id)sender {
    // Generate the PDF from the cart items
    NSURL *pdfURL = [self createPDFWithCartItems:nsarray_data];
    // Share the PDF
    //[self sharePDF:url];
    [self sharePDF:pdfURL];
}

- (NSURL *)createPDFWithCartItems:(NSArray *)cartItems {
    // Get the PDF file URL (temporary directory)
    NSString *pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cartItems.pdf"];
    NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath];
    
    // Start the PDF context
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
    // Set font and other properties
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:16.0];
    CGFloat yPosition = 20; // Start at the top of the page
    CGFloat pageHeight = 800; // Standard page height (for A4 paper)
    //CGFloat pageWidth = 600; // Standard page width
    CGFloat maxYPosition = pageHeight - 20; // Allow some space at the bottom
    
    int itemsPerPage = 6; // Number of items per page
    int currentItemCount = 0; // Track how many items have been added to the current page
    
    // Start a new page in the PDF
    UIGraphicsBeginPDFPage();
    
    // Loop through cart items and draw them into the PDF
    for (NSDictionary *item in cartItems) {
        CGFloat imageHeight = 100;
        UIImageView *imgView;
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, yPosition, imageHeight, imageHeight)];
        NSURL *URL;
        URL = [NSURL URLWithString: item[@"itemimage"]];
        NSString *myString = [URL absoluteString];
        [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        [imgView sd_setImageWithURL:[NSURL URLWithString:myString]
                   placeholderImage:[UIImage imageNamed:@"1024.png"] options: 0];
        
        UIImage *image = imgView.image;
        if (image) {
            [image drawInRect:CGRectMake(20, yPosition, imageHeight, imageHeight)];
        }
        NSString *itemName = [NSString stringWithFormat:@"%@", item[@"idesc"]];
        NSString *tagNo= [NSString stringWithFormat:@"Tag No - %@, Gross Wt. - %@, Stamp - %@", item[@"tgno"],item[@"item_gwt"],item[@"stamp"]];
        //NSString *itemGwt = [NSString stringWithFormat:@"Gross Wt. - %@", item[@"item_gwt"]];
        //NSString *itemStamp = [NSString stringWithFormat:@"Stamp - %@",item[@"stamp"]];
        NSString *itemQty = [NSString stringWithFormat:@"Quantity. - %@, Item Wt. - %@, MRP - %@",item[@"item_qty"],item[@"itemwt"],item[@"salemrp"]];
        //NSString *itemWt = [NSString stringWithFormat:@"Item Wt. - %@",item[@"itemwt"]];
        //NSString *itemSaleMrp = [NSString stringWithFormat:@"MRP - %@",item[@"salemrp"]];
        [itemName drawAtPoint:CGPointMake(imageHeight + 40, yPosition + 15) withAttributes:@{NSFontAttributeName: boldFont}];
        [tagNo drawAtPoint:CGPointMake(imageHeight + 40, yPosition + 35) withAttributes:@{NSFontAttributeName: font}];
        //[itemGwt drawAtPoint:CGPointMake(imageHeight, yPosition+40) withAttributes:@{NSFontAttributeName: font}];
        //[itemStamp drawAtPoint:CGPointMake(120, yPosition+60) withAttributes:@{NSFontAttributeName: font}];
        [itemQty drawAtPoint:CGPointMake(imageHeight + 40, yPosition + 55) withAttributes:@{NSFontAttributeName: font}];
        //[itemWt drawAtPoint:CGPointMake(120, yPosition+100) withAttributes:@{NSFontAttributeName: font}];
        //[itemSaleMrp drawAtPoint:CGPointMake(120, yPosition+120) withAttributes:@{NSFontAttributeName: font}];
        yPosition += imageHeight + 10;  // Move down for the next item
        
        // Increment the item count on the page
        currentItemCount++;
        // Check if the current page is full
//        if (currentItemCount == itemsPerPage) {
//            // Start a new page and reset the item count
//            UIGraphicsBeginPDFPage();
//            yPosition = 20; // Reset yPosition for the new page
//            currentItemCount = 0; // Reset item count for the new page
//        }
        // Check if the content is overflowing, if yes, start a new page
        if ((yPosition > maxYPosition) && (currentItemCount != itemsPerPage)) {
            // Start a new page if content overflows
            UIGraphicsBeginPDFPage();
            yPosition = 20; // Reset yPosition for the new page
            currentItemCount = 0;  // Reset item count for the new page
        }
    }
    NSString *totalItem = [NSString stringWithFormat:@"Total Wt. - %@, Total Pc - %@, Total MRP - %@",lbl_wt.text,lbl_pc.text,lbl_mrp.text];
    [totalItem drawAtPoint:CGPointMake(50, yPosition + 20) withAttributes:@{NSFontAttributeName: boldFont}];
    // End the PDF context
    UIGraphicsEndPDFContext();
    return pdfURL;
}

- (void)sharePDF:(NSURL *)pdfURL {
    // Create a UIActivityViewController to share the PDF
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[pdfURL] applicationActivities:nil];
    // Exclude irrelevant activity types (optional)
    activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypePostToFacebook];
    // Present the activity view controller
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark:- Present Customer Form

- (void)presentCustomerViewController {
    CustomerVisitFormVC *popupVC = [[CustomerVisitFormVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.delegate = self;
    [self presentViewController:popupVC animated:YES completion:nil];
}

// Implement the delegate method to get the data after the popup is dismissed
- (void)didFinishCustomerWithData:(NSData *)apiData customerData:(NSDictionary *)cdata{
    // Update the label with the data received from the popup
    NSLog(@"Cutomer API Data = %@", apiData);
    NSLog(@"Cutomer Data = %@", cdata);
    NSString *str_cname = [cdata valueForKey: @"cname"];
    NSString *str_cphone = [cdata valueForKey: @"contactNo1"];
    //[self parse_Insertmember:apiData con_mob: str_cphone cname:str_cname];
}

#pragma mark - PopUp View Methods

-(void)Popup_Customer {
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y + 64, self.view.frame.size.width, self.view.frame.size.height - 100)];
    
    paintView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.origin.y + 30,self.view.frame.size.width, self.view.frame.size.height - 100)];
    [paintView setBackgroundColor:[UIColor lightGrayColor]];
    
    CGRect someRect_contact = CGRectMake(10.0, 10.0, self.view.frame.size.width - 130, 30.0);
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"])
    {
        someRect_contact = CGRectMake(10.0, 10.0, self.view.frame.size.width-20, 30.0);
    }
    mytext_contact = [[UITextField alloc] initWithFrame:someRect_contact];
    mytext_contact.borderStyle = UITextBorderStyleRoundedRect;
    mytext_contact.font = [UIFont systemFontOfSize:15];
    mytext_contact.placeholder = @"Contact No.1";
    mytext_contact.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_contact.keyboardType = UIKeyboardTypeDefault;
    mytext_contact.returnKeyType = UIReturnKeyNext;
    mytext_contact.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_contact.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_contact.delegate = self;
    [paintView addSubview:mytext_contact];
    
    if (![ECAT_TYPE isEqualToString:@"3"])
    {
        NSInteger int_text =self.view.frame.size.width-110;
        UIButton* btn_search = [[UIButton alloc] initWithFrame:CGRectMake(int_text, 10.0, 100, 30.0)];
        [btn_search addTarget:self
                       action:@selector(btn_search:)
             forControlEvents:UIControlEventTouchUpInside];
        [btn_search setTitle:@"Search" forState:UIControlStateNormal];
        btn_search.clipsToBounds = YES;
        [btn_search setBackgroundColor:[UIColor redColor]];
        btn_search.layer.cornerRadius=10;
        btn_search.layer.borderColor=[UIColor blackColor].CGColor;
        btn_search.layer.borderWidth=1.0f;
        [paintView addSubview:btn_search];
    }
    
    CGRect someRect_partyname = CGRectMake(10.0, 50.0, self.view.frame.size.width-20, 30.0);
    mytext_partyname = [[UITextField alloc] initWithFrame:someRect_partyname];
    mytext_partyname.borderStyle = UITextBorderStyleRoundedRect;
    mytext_partyname.font = [UIFont systemFontOfSize:15];
    mytext_partyname.placeholder = @"Name";
    mytext_partyname.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_partyname.keyboardType = UIKeyboardTypeDefault;
    mytext_partyname.returnKeyType = UIReturnKeyNext;
    mytext_partyname.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_partyname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_partyname.delegate = self;
    [paintView addSubview:mytext_partyname];
    
    CGRect someRect_address = CGRectMake(10.0, 90.0, self.view.frame.size.width-20, 30.0);
    mytext_address = [[UITextField alloc] initWithFrame:someRect_address];
    mytext_address.borderStyle = UITextBorderStyleRoundedRect;
    mytext_address.font = [UIFont systemFontOfSize:15];
    mytext_address.placeholder = @"Enter Address";
    mytext_address.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_address.keyboardType = UIKeyboardTypeDefault;
    mytext_address.returnKeyType = UIReturnKeyNext;
    mytext_address.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_address.delegate = self;
    [paintView addSubview:mytext_address];
    
    CGRect someRect_address2 = CGRectMake(10.0, 130.0, self.view.frame.size.width-20, 30.0);
    mytext_address2 = [[UITextField alloc] initWithFrame:someRect_address2];
    mytext_address2.borderStyle = UITextBorderStyleRoundedRect;
    mytext_address2.font = [UIFont systemFontOfSize:15];
    mytext_address2.placeholder = @"Enter Address";
    mytext_address2.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_address2.keyboardType = UIKeyboardTypeDefault;
    mytext_address2.returnKeyType = UIReturnKeyNext;
    mytext_address2.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_address2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_address2.delegate = self;
    [paintView addSubview:mytext_address2];
    
    CGRect someRect_address3 = CGRectMake(10.0, 170, self.view.frame.size.width-20, 30.0);
    mytext_address3 = [[UITextField alloc] initWithFrame:someRect_address3];
    mytext_address3.borderStyle = UITextBorderStyleRoundedRect;
    mytext_address3.font = [UIFont systemFontOfSize:15];
    mytext_address3.placeholder = @"Enter Address";
    mytext_address3.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_address3.keyboardType = UIKeyboardTypeDefault;
    mytext_address3.returnKeyType = UIReturnKeyNext;
    mytext_address3.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_address3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_address3.delegate = self;
    [paintView addSubview:mytext_address3];
    
    CGRect someRect_location = CGRectMake(10.0, 210, self.view.frame.size.width-20, 30.0);
    mytext_location = [[UITextField alloc] initWithFrame:someRect_location];
    mytext_location.borderStyle = UITextBorderStyleRoundedRect;
    mytext_location.font = [UIFont systemFontOfSize:15];
    mytext_location.placeholder = @"Enter Location";
    mytext_location.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_location.keyboardType = UIKeyboardTypeDefault;
    mytext_location.returnKeyType = UIReturnKeyNext;
    mytext_location.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_location.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_location.delegate = self;
    [paintView addSubview:mytext_location];
    
    CGRect someRect_city = CGRectMake(10.0, 250, self.view.frame.size.width-20, 30.0);
    mytext_city = [[UITextField alloc] initWithFrame:someRect_city];
    mytext_city.borderStyle = UITextBorderStyleRoundedRect;
    mytext_city.font = [UIFont systemFontOfSize:15];
    mytext_city.placeholder = @"Enter City";
    mytext_city.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_city.keyboardType = UIKeyboardTypeDefault;
    mytext_city.returnKeyType = UIReturnKeyNext;
    mytext_city.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_city.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_city.delegate = self;
    [paintView addSubview:mytext_city];
    
    CGRect someRect_email = CGRectMake(10.0, 290, self.view.frame.size.width-20, 30.0);
    mytext_email = [[UITextField alloc] initWithFrame:someRect_email];
    mytext_email.borderStyle = UITextBorderStyleRoundedRect;
    mytext_email.font = [UIFont systemFontOfSize:15];
    mytext_email.placeholder = @"Enter Email ID";
    mytext_email.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_email.keyboardType = UIKeyboardTypeDefault;
    mytext_email.returnKeyType = UIReturnKeyNext;
    mytext_email.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_email.delegate = self;
    [paintView addSubview:mytext_email];
    
    CGRect someRect_contact2 = CGRectMake(10.0, 330, self.view.frame.size.width-20, 30.0);
    mytext_contact2 = [[UITextField alloc] initWithFrame:someRect_contact2];
    mytext_contact2.borderStyle = UITextBorderStyleRoundedRect;
    mytext_contact2.font = [UIFont systemFontOfSize:15];
    mytext_contact2.placeholder = @"Enter Contact No. 2";
    mytext_contact2.autocorrectionType = UITextAutocorrectionTypeNo;
    mytext_contact2.keyboardType = UIKeyboardTypeDefault;
    mytext_contact2.returnKeyType = UIReturnKeyNext;
    mytext_contact2.clearButtonMode = UITextFieldViewModeWhileEditing;
    mytext_contact2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mytext_contact2.delegate = self;
    [paintView addSubview:mytext_contact2];
    
    if ([ECAT_TYPE isEqualToString:@"3"])
    {
        NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
        NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
        NSString *address = [[NSUserDefaults standardUserDefaults]stringForKey:@"address"];
        NSString *emailid = [[NSUserDefaults standardUserDefaults]stringForKey:@"emailid"];
        
        mytext_partyname.text = [NSString stringWithString:username];
        mytext_contact.text = [NSString stringWithString:mobile];
        mytext_email.text = [NSString stringWithString:emailid];
        mytext_address.text = [NSString stringWithString:address];
        [mytext_contact setUserInteractionEnabled:false];
        
        mytext_address2.placeholder = @"Enter City";
        mytext_address3.placeholder = @"Enter State";
        mytext_city.placeholder = @"Enter Pincode";
    }
    
    UIButton *btn_cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 370, 100, 30.0)];
    [btn_cancel addTarget:self
                   action:@selector(btn_Cancel:)
         forControlEvents:UIControlEventTouchUpInside];
    [btn_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btn_cancel.clipsToBounds = YES;
    [btn_cancel setBackgroundColor:[UIColor whiteColor]];
    [btn_cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn_cancel.layer.cornerRadius = 10;
    btn_cancel.layer.borderColor = [UIColor blackColor].CGColor;
    btn_cancel.layer.borderWidth = 1.0f;
    [paintView addSubview:btn_cancel];
    
    UIButton *btn_save = [[UIButton alloc] initWithFrame:CGRectMake(120, 370, 100, 30.0)];
    [btn_save addTarget:self
                 action:@selector(btn_Save:)
       forControlEvents:UIControlEventTouchUpInside];
    [btn_save setTitle:@"Save" forState:UIControlStateNormal];
    btn_save.clipsToBounds = YES;
    [btn_save setBackgroundColor:[UIColor whiteColor]];
    [btn_save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_save.layer.cornerRadius = 10;
    btn_save.layer.borderColor = [UIColor blackColor].CGColor;
    btn_save.layer.borderWidth = 1.0f;
    [paintView addSubview:btn_save];
    
    scroll.showsVerticalScrollIndicator=YES;
    scroll.scrollEnabled=YES;
    scroll.userInteractionEnabled=YES;
    scroll.contentSize = CGSizeMake(self.view.frame.size.width,600);
    scroll.delegate = self;
    [scroll addSubview:paintView];
    [self.view addSubview:scroll];
}

#pragma mark - PopUp Button Action Methods

-(void) btn_search:(NSString *)myString{
    [self GET_MEMBERS];
    NSLog(@"you clicked on button %@", myString);
}
-(void)btn_Save:(NSString *)myString{
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]) {
        [self URL_SAVE_ORDER];
    }else{
        [self URL_INSERT_MEMBERS];
    }
    NSLog(@"you clicked on button %@", myString);
}


-(void) btn_Cancel:(NSString *)myString{
    paintView.hidden = YES;
    NSLog(@"you clicked on button %@", myString);
}

#pragma mark - Api Methods

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"] ?: @"";
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *activity=@"product";
    NSString *rlid=@"0";
    NSString *visid=@"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,visid,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_GET_CART];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_cart_record.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,visid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&visid=%@",apptype,category,mobile,userid,activity,rlid,visid];
        
//        loginRequest=[NSString stringWithFormat:@"apptype=%@&ECAT_TYPE_NEW=%@&userid=%@&activity=%@&rlid=%@&visid=%@&mobile=%@",apptype,ECAT_TYPE_NEW,@"",activity,rlid,visid,mobile];
//        
//        params.put("ECAT_TYPE_NEW", ECAT_TYPE_NEW);
//                        params.put("apptype", ECAT_TYPE);
//                        params.put("userid", userid);
//        params.put("mobile", mobilenew);
//                        params.put("activity", stractivity);
//                        params.put("rlid", rlid);
//                        params.put("visid", "");
        
//        params = {HashMap@36757}  size = 7
//         "rlid" -> "0"
//          key = "rlid"
//          value = "0"
//         "ECAT_TYPE_NEW" -> "3"
//          key = "ECAT_TYPE_NEW"
//          value = "3"
//         "activity" -> ""
//          key = "activity"
//          value = ""
//         "apptype" -> "3"
//          key = "apptype"
//          value = "3"
//         "mobile" -> "9627746628"
//         "visid" -> ""
//          key = "visid"
//          value = ""
//         "userid" -> ""
//          key = "userid"
//          value = ""
        
        URL_API =[WEB_URL URL_GET_CART];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSLog(@"urlString = %@",urlString);
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api = %@",api);
    
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
                [self parseResponse_category:data];
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


- (void) parseResponse_category:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"get_cart_recordd = %@", myData);
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
            
            nsarray_qty =[[NSMutableArray alloc]init];
            nsarray_data =[[NSMutableArray alloc]init];
            nsarray_data = [pDict objectForKey:@"items"];
            NSLog(@"nsarray_data :: %@",nsarray_data);
            
            [self.tableView reloadData];
            lbl_wt.text = @"0.0";
            lbl_pc.text = @"0";
            lbl_mrp.text = @"0";
            NSInteger int_qty = 0;
            double int_wt = 0;
            NSInteger intmrptotal = 0;
            
            for (int i = 0; i < [nsarray_data count]; i++) {
                
                NSDictionary * dictObject = [nsarray_data objectAtIndex:i];
                NSString *item_qty = [dictObject objectForKey:@"item_qty"];
                NSString *itemwt = [dictObject objectForKey:@"itemwt"];
                NSString *salemrp = [dictObject objectForKey:@"salemrp"];
                
                int_qty = int_qty +[item_qty integerValue];
                NSString *strValue = @(int_qty).stringValue;
                lbl_pc.text = strValue;
                
                int_wt = int_wt +[itemwt doubleValue];
                NSString *strValue_wt = @(int_wt).stringValue;
                lbl_wt.text = strValue_wt;
                
                if (salemrp == nil) {
                    intmrptotal=0;
                }else{
                    intmrptotal = intmrptotal +[salemrp integerValue];
                }
                
                if (intmrptotal==0.00 || intmrptotal==0){
                    lbl_mrp.text = @"";
                }else{
                    NSString *strValue_salemrp = @(intmrptotal).stringValue;
                    lbl_mrp.text =strValue_salemrp;
                }
                
                [nsarray_qty addObject:item_qty];
            }
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)URL_INSERT_MEMBERS {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    
    NSString *str_contact = mytext_contact.text;
    NSString *str_pname = mytext_partyname.text;
    NSString *str_address = mytext_address.text;
    NSString *str_address2 = mytext_address2.text;
    NSString *str_address3 = mytext_address3.text;
    NSString *str_location = mytext_location.text;
    NSString *str_city = mytext_city.text;
    NSString *str_email = mytext_email.text;
    NSString *sm_mobile = mytext_contact2.text;
    
    
    if ([apptype isEqualToString:@"1"])
    {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,ip,db,ipusername,pswd,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        
        URL_API = [WEB_URL URL_INSERT_MEMBERS];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_members.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        URL_API = [WEB_URL URL_INSERT_MEMBERS];
    }
    
    NSLog(@"loginRequest :: %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api :: %@",api);
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_Insertmember:data];
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


- (void)parse_Insertmember:(NSData *) data {
    @try {
        
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
            NSMutableDictionary *pDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSLog(@"str_success ************************ %@",str_success);
            NSMutableArray*nsarray_cpid = [pDict objectForKey:@"cpid"];
            str_cpid = [nsarray_cpid description];
            NSLog(@"str_cpid ************************ %@",str_cpid);
            [self URL_SAVE_ORDER];
            paintView.hidden = YES;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)GET_MEMBERS {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = mytext_contact.text;
    
    NSString *activity = @"product";
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
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&mobile=%@",apptype,ip,db,ipusername,pswd,ftppath,mobile];
        URL_API = [WEB_URL URL_GET_MEMBERS];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_members.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&mobile=%@",ECAT_TYPE,ftppath,mobile];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",ECAT_TYPE,mobile];
        URL_API = [WEB_URL URL_GET_MEMBERS];
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
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_GETmembers:data];
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


- (void)parse_GETmembers:(NSData *) data {
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
                NSMutableArray*nsarray_cpemail = [pDict objectForKey:@"cpemail"];
                NSString *str_cpemail = [nsarray_cpemail description];
                
                NSMutableArray*nsarray_cpid = [pDict objectForKey:@"cpid"];
                str_cpid = [nsarray_cpid description];
                
                NSMutableArray*nsarray_cpname = [pDict objectForKey:@"cpname"];
                NSString *str_cpname = [nsarray_cpname description];
                
                NSMutableArray*nsarray_cpasary = [pDict objectForKey:@"cpasary"];
                NSString *str_cpasary = [nsarray_cpasary description];
                
                NSMutableArray*nsarray_cpcity = [pDict objectForKey:@"cpcity"];
                NSString *str_cpcity = [nsarray_cpcity description];
                
                NSMutableArray*nsarray_cpdob = [pDict objectForKey:@"cpdob"];
                NSString *str_cpdob = [nsarray_cpdob description];
                
                NSMutableArray*nsarray_cpadd1 = [pDict objectForKey:@"cpadd1"];
                NSString *str_cpadd1 = [nsarray_cpadd1 description];
                
                NSMutableArray*nsarray_cpadd2 = [pDict objectForKey:@"cpadd2"];
                NSString *str_cpadd2 = [nsarray_cpadd2 description];
                
                NSMutableArray*nsarray_cpadd3 = [pDict objectForKey:@"cpadd3"];
                NSString *str_cpadd3 = [nsarray_cpadd3 description];
                
                NSMutableArray*nsarray_cplocation = [pDict objectForKey:@"cplocation"];
                NSString *str_cplocation = [nsarray_cplocation description];
                
                NSMutableArray*nsarray_cpphone = [pDict objectForKey:@"cpphone"];
                NSString *str_cpphone = [nsarray_cpphone description];
                
                mytext_partyname.text = str_cpname;
                mytext_address.text = str_cpadd1;
                mytext_address2.text = str_cpadd2;
                mytext_address3.text = str_cpadd3;
                mytext_location.text = str_cplocation;
                mytext_city.text = str_cpcity;
                mytext_email.text = str_cpemail;
                mytext_contact2.text = str_cpphone;
                
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


-(void)URL_CLEAR_CART {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *activity=@"product";
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    //    NSString *visid=@"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,userid,apptype,rlid,activity,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_CLEARCART];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/clear_cart.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@&ftppath=%@",mobile,userid,apptype,rlid,activity,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&rlid=%@&activity=%@",mobile,userid,apptype,rlid,activity];
        URL_API =[WEB_URL URL_CLEARCART];
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
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_ClearCart:data];
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


- (void)parse_ClearCart:(NSData *) data {
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
                
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
                    Gautom_HomeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
                    [self.navigationController pushViewController:obj animated:YES];
//                    if ([ECAT_TYPE isEqualToString:@"3"]) {
//                        MainActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MainActivity"];
//                        [self.navigationController pushViewController:obj animated:YES];
//                    }else{
//                        MMIHOMEPanel *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
//                        [self.navigationController pushViewController:obj animated:YES];
//                    }
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                
                
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



-(void)URL_SAVE_ORDER {
    NSLog(@"URL_SAVE_ORDER ************************************ %@",str_cpid);
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *activity=@"product";
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *cpmobile = mytext_contact.text;
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&activity=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cpid=%@&cpmobile=%@",mobile,userid,ECAT_TYPE,activity,ip,db,ipusername,pswd,ftppath,str_cpid,cpmobile];
        
        URL_API =[WEB_URL URL_SAVE_CART];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *cpmobile = mytext_contact.text;
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_order_ios.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&activity=%@&ftppath=%@&cpid=%@&cpmobile=%@",mobile,userid,ECAT_TYPE,activity,ftppath,str_cpid,cpmobile];
    }else{
        NSString * mobile2 = mytext_contact2.text;
        NSString * address = mytext_address.text;
        NSString * landmark = mytext_location.text;
        NSString * state = mytext_address3.text;
        NSString * city = mytext_address2.text;
        NSString * pincode = mytext_city.text;
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&userid=%@&apptype=%@&activity=%@&mobile2=%@&address=%@&landmark=%@&state=%@&city=%@&pincode=%@",mobile,userid,ECAT_TYPE,activity,mobile2,address,landmark,state,city,pincode];
        URL_API =[WEB_URL URL_SAVE_CART];
    }
    
    NSLog(@"URL_SAVE_CART :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"URL_SAVE_CART :: %@",api);
    
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
        // handle response
        
        if ([data length] >0 && error == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SaveOrder:data];
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


- (void)parse_SaveOrder:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSONdata_order = %@", myData);
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
                
                NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
                
                if ([ECAT_TYPE isEqualToString:@"3"]) {
                    NSMutableArray *nsarray_orderno = [pDict objectForKey:@"orderno"];
                    NSString *str_orderno = [nsarray_orderno description];
                    NSString *m_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"m_id"];
                    
                    if (m_id.length ==0) {
                        //MainActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MainActivity"];
                        Gautom_HomeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
                        [self.navigationController pushViewController:obj animated:YES];
                    }else{
                        PaymentActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentActivity"];
                        obj.str_orderno = str_orderno;
                        obj.str_amount = lbl_mrp.text;
                        obj.str_emailid = mytext_email.text;
                        [self.navigationController pushViewController:obj animated:YES];
                    }
                }else{
                    //MMIHOMEPanel *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                    Gautom_HomeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
                    [self.navigationController pushViewController:obj animated:YES];
                }
                
                
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


-(void)URL_SINGLE_ITEM_DELETE {
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
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,cart_id,apptype,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_DELETE];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_single_item.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ftppath=%@",mobile,cart_id,apptype,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@",mobile,cart_id,apptype];
        URL_API =[WEB_URL URL_DELETE];
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
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
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
                
                [self scrollData_Category];
                
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



-(void)scrollData_InsertItem {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *remarks=text_remarks.text;
    NSString *str_tgno=[[nsarray_data valueForKey:@"tgno"] objectAtIndex:index_cart];
    NSString *str_gwt=[[nsarray_data valueForKey:@"gwt"] objectAtIndex:index_cart];
    NSString *str_qty=text_count.text;
    NSString *wt=@"";
    NSString *salemrp=@"";
    
    [nsarray_qty replaceObjectAtIndex:index_cart withObject:str_qty];
    [self.tableView reloadData];
    
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
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&userid=%@&mobile=%@&remarks=%@&str_tgno=%@&str_gwt=%@&str_qty=%@&wt=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&salemrp=%@",apptype,userid,mobile,remarks,str_tgno,str_gwt,str_qty,wt,ip,db,ipusername,pswd,ftppath,salemrp];
        
        URL_API =[WEB_URL URL_INSERT_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_singleitem_android.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&userid=%@&mobile=%@&remarks=%@&str_tgno=%@&str_gwt=%@&str_qty=%@&wt=%@&ftppath=%@&salemrp=%@",apptype,userid,mobile,remarks,str_tgno,str_gwt,str_qty,wt,ftppath,salemrp];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&userid=%@&mobile=%@&remarks=%@&str_tgno=%@&str_gwt=%@&str_qty=%@&wt=%@&salemrp=%@",apptype,userid,mobile,remarks,str_tgno,str_gwt,str_qty,wt,salemrp];
        
        URL_API =[WEB_URL URL_INSERT_ITEM];
    }
    
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
                [self parseResponse_Save:data];
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


- (void)parseResponse_Save:(NSData *) data {
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
                [self scrollData_Category];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark: - Get Item with Tag Api method

-(void)scrollData_InsertItemTag {
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
        
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,tagno,mobile,visid,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_INSERT_ITEMTAG];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_itemtag.php",ip];
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@&ftppath=%@",ECAT_TYPE_NEW,apptype,tagno,mobile,visid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&tgno=%@&mobile=%@&visid=%@",ECAT_TYPE_NEW,apptype,tagno,mobile,visid];
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
                
                [self scrollData_Category];
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

@end
