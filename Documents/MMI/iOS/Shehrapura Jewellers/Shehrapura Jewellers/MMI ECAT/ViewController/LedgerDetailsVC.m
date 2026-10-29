//
//  LedgerDetailsVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "LedgerDetailsVC.h"

#pragma mark - Custom UserList UITableViewCell

@interface LedgerDetailsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblRefNo;
@property (nonatomic, strong) IBOutlet UILabel *lblDedit;
@property (nonatomic, strong) IBOutlet UILabel *lblCredit;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblNarr;

@end

@implementation LedgerDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

#pragma mark - LedgerDetailsVC

@interface LedgerDetailsVC ()

@end

@implementation LedgerDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ledger Details";
    tblList = [NSMutableArray array];
    [self scrollData_Category];
    [self setUpNavigation];
}

-(void) setUpNavigation{
    // Create the button
    UIButton *btn_Call = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Call.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *phoneImage = [UIImage systemImageNamed:@"phone.fill"];
    [btn_Call setBackgroundImage:phoneImage forState:UIControlStateNormal];
    // Configure button appearance
    [[btn_Call imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_Call.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_Call.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_Call.tintColor = [UIColor whiteColor];
    // Add the button action
    [btn_Call addTarget:self action:@selector(btn_Call:) forControlEvents:UIControlEventTouchUpInside];
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *callBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Call];
    
    UIButton *btn_Pdf = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Pdf.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *pdfImage = [UIImage systemImageNamed:@"doc.fill"];
    [btn_Pdf setBackgroundImage:pdfImage forState:UIControlStateNormal];
    // Configure button appearance
    [[btn_Pdf imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_Pdf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_Pdf.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_Pdf.tintColor = [UIColor whiteColor];
    // Add the button action
    [btn_Pdf addTarget:self action:@selector(btn_Pdf:) forControlEvents:UIControlEventTouchUpInside];
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *pdfBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Pdf];
    
    // Assign the UIBarButtonItem to the navigation item
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:pdfBarButton, callBarButton, nil];
}

-(void)btn_Pdf:(UIButton*)sender{
    [self shareExcelStylePDF];
}

-(void)btn_Call:(UIButton*)sender{
    //NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *str_mobile = [NSString stringWithFormat:@"%@",[self.selectDicData valueForKey:@"mobile"]];
    [self phoneCallMethod:str_mobile];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tblList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LedgerDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LedgerDetailsCell" forIndexPath:indexPath];
    
    cell.subView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.subView.layer.borderWidth = 1;
    
    cell.lblRefNo.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"refno"] objectAtIndex:indexPath.row]];
    cell.lblDedit.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"debit"] objectAtIndex:indexPath.row]];
    cell.lblCredit.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"credit"] objectAtIndex:indexPath.row]];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"date"] objectAtIndex:indexPath.row]];
    cell.lblNarr.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"narr"] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Api Method

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    
    NSString *str_cname = self.str_LedgerName.length > 0 ? self.str_LedgerName : [self.selectDicData valueForKey:@"cname"];
    NSString *str_acno = self.str_LedgerName.length > 0 ? @"" : [self.selectDicData valueForKey:@"acno"];
    str_cname = [NSString stringWithFormat:@"%@",str_cname];
    str_acno = [NSString stringWithFormat:@"%@",str_acno];
    
    if ([apptype isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cname=%@&acno=%@",apptype,ip,db,ipusername,pswd,ftppath,str_cname,str_acno];
        URL_API =[WEB_URL URL_SHOW_LEDGER_DETAILS];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/ledger_details.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&cname=%@&acno=%@",apptype,ftppath,str_cname,str_acno];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&cname=%@&acno=%@",apptype,str_cname,str_acno];
        URL_API =[WEB_URL URL_SHOW_LEDGER_DETAILS];
    }
    NSLog(@"ledger_accounts loginRequest = %@",loginRequest);
    NSLog(@"ledger URL_API = %@",URL_API);
    
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
            tblList = [pDict objectForKey:@"ledger"];
            [self.tableView reloadData];
            NSString *str_OpenBal = tblList.count > 0 ? [[tblList valueForKey:@"open_bal"] objectAtIndex:0] : @"0";
            self.lblOpenBal.text = [NSString stringWithFormat:@"Rs. %@", str_OpenBal];
            [self calculateTotals];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark: - Helper

- (void)calculateTotals {
    double totalDebit = 0;
    double totalCredit = 0;
    for (NSDictionary *entry in tblList) {
        double debit = [entry[@"debit"] doubleValue];
        double credit = [entry[@"credit"] doubleValue];
        totalDebit += debit;
        totalCredit += credit;
    }
    double difference = totalDebit - totalCredit;
    NSLog(@"🔢 Total Debit: %.2f", totalDebit);
    NSLog(@"🔢 Total Credit: %.2f", totalCredit);
    NSLog(@"🔢 Difference (Debit - Credit): %.2f", difference);
    // Optionally update labels in your UI
    //    self.lblDebitTotal.text = [NSString stringWithFormat:@"₹ %.2f", totalDebit];
    //    self.lblCreditTotal.text = [NSString stringWithFormat:@"₹ %.2f", totalCredit];
    self.lblCloseBal.text = [NSString stringWithFormat:@"Rs. %.2f", difference];
}

#pragma mark:- Create and Share Pdf File Method

- (void)shareExcelStylePDF {
    NSURL *pdfURL = [self createExcelStylePDFWithData:tblList];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[pdfURL] applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(100, 100, 200, 200);
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (NSURL *)createExcelStylePDFWithData:(NSArray<NSDictionary *> *)dataArray {
    CGFloat pageWidth = 700;  // A4 width
    CGFloat pageHeight = 800; // A4 height
    CGFloat margin = 20;
    
    UIFont *font = [UIFont systemFontOfSize:16.0];
    NSString *str_cname = [NSString stringWithFormat:@"%@",[self.selectDicData valueForKey:@"cname"]];
    NSString *str_OpenBal = tblList.count > 0 ? [[tblList valueForKey:@"open_bal"] objectAtIndex:0] : @"0";
    
    NSString *itemName = [NSString stringWithFormat:@"Name: %@", str_cname];
    NSString *itemOpenBal = [NSString stringWithFormat:@"Opening Balance : Rs. %@", str_OpenBal];
    
    CGFloat startX = margin;
    CGFloat startY = margin + 70;
    CGFloat rowHeight = 30;
    
    NSArray *columns = @[@"Ref No", @"Debit", @"Credit", @"Date", @"Narr"];
    NSArray *columnWidths = @[@100.0, @100.0, @100.0, @100.0, @200]; // Column widths
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.pdf", str_cname, [[NSUUID UUID] UUIDString]];
    NSString *pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageWidth, pageHeight), nil);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [itemName drawAtPoint:CGPointMake(startX, margin + 20) withAttributes:@{NSFontAttributeName: font}];
    //[itemOpenBal drawAtPoint:CGPointMake(startX, margin + 30) withAttributes:@{NSFontAttributeName: font}];
    CGFloat currentY = startY;
    // Draw header row
    CGFloat currentX = startX;
    for (int i = 0; i < columns.count; i++) {
        CGRect cellRect = CGRectMake(currentX, currentY, [columnWidths[i] floatValue], rowHeight);
        CGContextStrokeRect(context, cellRect); // Draw border
        [columns[i] drawInRect:CGRectInset(cellRect, 5, 5) withAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
        currentX += [columnWidths[i] floatValue];
    }
    currentY += rowHeight;
    // Draw data rows
    for (NSDictionary *row in dataArray) {
        // Check if we need a new page
        if (currentY + rowHeight > pageHeight - margin) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageWidth, pageHeight), nil);
            currentY = startY;
        }
        currentX = startX;
        NSString *refNo = row[@"refno"];
        NSString *debit = row[@"debit"];
        NSString *credit = row[@"credit"];
        NSString *date = row[@"date"];
        NSString *narr = row[@"narr"];
        NSArray *rowValues = @[refNo, debit, credit, date, narr];
        for (int i = 0; i < rowValues.count; i++) {
            CGRect cellRect = CGRectMake(currentX, currentY, [columnWidths[i] floatValue], rowHeight);
            CGContextStrokeRect(context, cellRect); // Draw border
            [rowValues[i] drawInRect:CGRectInset(cellRect, 5, 5) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
            currentX += [columnWidths[i] floatValue];
        }
        currentY += rowHeight;
    }
    currentY += 20;
    NSString *closeBal = [NSString stringWithFormat:@"Close Balance : %@", self.lblCloseBal.text];
    //    NSString *totalCrBal = [NSString stringWithFormat:@"Total Dr : %@",str_debitm];
    //    NSString *totalDrBal = [NSString stringWithFormat:@"Total Cr : %@",str_creditm];
    NSString *str_BalValue = [NSString stringWithFormat:@"%@",itemOpenBal];
    [str_BalValue drawAtPoint:CGPointMake(startX, currentY) withAttributes:@{NSFontAttributeName: font}];
    currentY += 30;
    //    NSString *str_TotalBalValue = [NSString stringWithFormat:@"%@,    %@",totalCrBal, totalDrBal];
    [closeBal drawAtPoint:CGPointMake(startX, currentY) withAttributes:@{NSFontAttributeName: font}];
    UIGraphicsEndPDFContext();
    return [NSURL fileURLWithPath:pdfPath];
}

@end
