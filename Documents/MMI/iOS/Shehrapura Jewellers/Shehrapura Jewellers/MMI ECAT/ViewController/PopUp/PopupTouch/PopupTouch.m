//
//  PopupTouch.m
//  Jewel Desk
//
//  Created by App Dev on 01/01/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "PopupTouch.h"

@interface PopupTouch ()

@end

@implementation PopupTouch
@synthesize str_lbr,str_mrp,str_bhav,str_dis1,str_dis2,str_rate,str_csamt,str_lbron,str_pdis1,str_pdis2,str_sdamt,str_slamt,str_ssamt,str_stamp,str_csmamt,str_dis1on,str_dis2on,str_itemwt,str_lbr24k,str_othamt,str_spolish,str_24karat,str_polishwt,str_remarks1,str_polishper,str_cartid;

#pragma mark: - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [scrollview setScrollEnabled:YES];
    //    CGSize contentSize = CGSizeMake(scrollview.frame.size.width, 900);
    //    scrollview.contentSize = contentSize;
    txt_othamt.text = [NSString stringWithString:str_othamt];
    txt_polishPer.text = [NSString stringWithString:str_polishper];
    txt_polishwt.text = [NSString stringWithString:str_polishwt];
    str_lbr = [NSString stringWithString: [_dicData valueForKey:@"lbr"]];
    if(![str_lbr isEqualToString:@"0.000"]){
        txt_percent0.text = str_lbr;
    }else{
        txt_percent0.text = str_slamt;
    }
    txt_percent1.text = [NSString stringWithString:str_pdis1];
    txt_value1.text = [NSString stringWithString:str_dis1];
    txt_percent2.text = [NSString stringWithString:str_pdis2];
    txt_value2.text = [NSString stringWithString:str_dis2];
    txt_rate.text = [NSString stringWithString:str_rate];
    txt_csmamt.text = [NSString stringWithString:str_csmamt];
    
    double d_dia = [str_sdamt doubleValue] + [str_ssamt doubleValue] + [str_mrp doubleValue];
    txt_dwt.text = [NSString stringWithFormat:@"%f.0",d_dia];
    
    txt_Stamp.text = [NSString stringWithString: [_dicData valueForKey:@"stamp"]];
    
    [txt_polishPer addTarget:self action:@selector(text_polishper:) forControlEvents:UIControlEventEditingChanged];
    [txt_percent0 addTarget:self action:@selector(text_percent0:) forControlEvents:UIControlEventEditingChanged];
    [txt_othamt addTarget:self action:@selector(text_othamt:) forControlEvents:UIControlEventEditingChanged];
    [txt_percent1 addTarget:self action:@selector(txt_percent1:) forControlEvents:UIControlEventEditingChanged];
    [txt_percent2 addTarget:self action:@selector(txt_percent2:) forControlEvents:UIControlEventEditingChanged];
    [txt_rate addTarget:self action:@selector(txt_rate:) forControlEvents:UIControlEventEditingChanged];
    
    txt_lbron.text = @"Rs";
    NSArray *pickerLbronData = @[@"Rs", @"%", @"Pc", @"Wt"];
    [txt_lbron addPickerWithData:pickerLbronData searchEnabled:NO];
    
    NSArray *pickerData = @[@"NV", @"MV", @"LBR", @"MV+LBR", @"DV", @"SV", @"DV+SV", @"Rs", @"%"];
    
    spinner_on1.text = @"NV";
    [spinner_on1 addPickerWithData:pickerData searchEnabled:NO];
    
    spinner_on2.text = @"NV";
    [spinner_on2 addPickerWithData:pickerData searchEnabled:NO];
    
    [self setUpView];
    //[self GET_VALUE:@"" fieldname:@"lbr"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

-(void)setUpView{
    NSLog(@"DicData = %@",_dicData);
    txt_polishPer.text = [NSString stringWithString: [_dicData valueForKey:@"polishper"]];
    txt_polishwt.text = [NSString stringWithString: [_dicData valueForKey:@"polishwt"]];
    
    txt_rate.text = [NSString stringWithString: [_dicData valueForKey:@"rate"]];
    txt_Stamp.text = [NSString stringWithString: [_dicData valueForKey:@"stamp"]];
    txt_csmamt.text = [NSString stringWithString: [_dicData valueForKey:@"csmamt"]];
    
    txt_percent0.text = [NSString stringWithString: [_dicData valueForKey:@"lbr"]];
    
    //    NSString *lbrValue = [NSString stringWithString: [_dicData valueForKey:@"lbr24k"]];
    //    NSString *slamtValue = [NSString stringWithString: [_dicData valueForKey:@"slamt"]];
    //
    //    if(![lbrValue isEqualToString:@"0.000"]){
    //        txt_percent0.text = lbrValue;
    //    }else{
    //        txt_percent0.text = slamtValue;
    //    }
    txt_lbron.text = [NSString stringWithString: [_dicData valueForKey:@"lbron"]];
    txt_value0.text = [NSString stringWithString: [_dicData valueForKey:@"slamt"]];
    
    txt_othamt.text =  [NSString stringWithString: [_dicData valueForKey:@"othamt"]];
    
    txt_dwt.text = [NSString stringWithString: [_dicData valueForKey:@"sdamt"]];
    txt_saletotal.text = [NSString stringWithString: [_dicData valueForKey:@"mrp"]];
    
    txt_percent1.text = [NSString stringWithString: [_dicData valueForKey:@"pdis1"]];
    spinner_on1.text = @"NV";
    txt_value1.text =[NSString stringWithString: [_dicData valueForKey:@"dis1on"]];
    
    txt_percent2.text = [NSString stringWithString: [_dicData valueForKey:@"pdis2"]];
    spinner_on2.text = @"NV";
    txt_value2.text = [NSString stringWithString: [_dicData valueForKey:@"dis2on"]];
    
    txt_total.text = [NSString stringWithString: [_dicData valueForKey:@"mrp"]];
    txt_gstamt.text = [NSString stringWithString: [_dicData valueForKey:@"gst"]];
    edt_remark.text = [NSString stringWithString: [_dicData valueForKey:@"remarks"]];
    /*
     txt_othamt.text = [NSString stringWithString:str_othamt];
     txt_polishPer.text = [NSString stringWithString:str_polishper];
     txt_polishwt.text = [NSString stringWithString:str_polishwt];
     if(![str_lbr isEqualToString:@"0.000"]){
     txt_percent0.text = str_lbr;
     }else{
     txt_percent0.text = str_slamt;
     }
     txt_percent1.text = [NSString stringWithString:str_pdis1];
     txt_value1.text = [NSString stringWithString:str_dis1];
     txt_percent2.text = [NSString stringWithString:str_pdis2];
     txt_value2.text = [NSString stringWithString:str_dis2];
     txt_rate.text = [NSString stringWithString:str_rate];
     txt_csmamt.text = [NSString stringWithString:str_csmamt];
     */
    
    id value = _dicData[@"salemrp"];
    if ([value isKindOfClass:[NSString class]]) {
        // Safe to call string methods
        NSRange range = [value rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if (range.location != NSNotFound) {
            // do something
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        // Convert NSNumber to NSString if needed
        NSString *stringValue = [value stringValue];
        // Now safe to call string methods on stringValue
    }
    
    NSString *stringValue = nil;
    if ([value isKindOfClass:[NSNumber class]]) {
        stringValue = [value stringValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        stringValue = value;
    }
    // now use stringValue safely
    txt_gst.text = stringValue;//[NSString stringWithString: [[_dicData valueForKey:@"salemrp"] stringValue]];
    
    
}

#pragma mark:- UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_polishPer) {
        [txt_polishwt becomeFirstResponder];
    } else if (textField == txt_polishwt) {
        [txt_rate becomeFirstResponder];
    } else if (textField == txt_rate) {
        [txt_percent0 becomeFirstResponder];
    }else if (textField == txt_percent0) {
        [txt_percent1 becomeFirstResponder];
    }else if (textField == txt_percent1) {
        [txt_value1 becomeFirstResponder];
    }else if (textField == txt_value1) {
        [txt_percent2 becomeFirstResponder];
    }else if (textField == txt_percent2) {
        [txt_value2 becomeFirstResponder];
    }else if (textField == txt_value2) {
        [edt_remark becomeFirstResponder];
    }else if (textField == edt_remark) {
        [edt_remark resignFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)txt_rate:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"rate"];
}

-(void)text_percent0:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"lbr"];
}

-(void)txt_percent2:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"dis2"];
}

-(void)text_polishper:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"per"];
}

-(void)txt_percent1:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"dis1"];
}

-(void)text_othamt:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
    [self GET_VALUE:textField.text fieldname:@"lbr"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (txt_lbron == textField) {
        [self GET_VALUE:textField.text fieldname:textField.text];
    }
}

- (void)GET_VALUE:(NSString *)value fieldname:(NSString *)fieldname{
    double fl_salemrp = 0, fl_csmamt = 0, fl_itemwt = 0, fl_rate = 0, fl_bhav = 0, fl_pc = 0;
    double fl_sdamt = 0, fl_ssamt = 0, fl_othamt = 0, fl_total = 0, fl_percent0 = 0, fl_percent1 = 0, fl_percent2 = 0;
    
    if (str_sdamt.length > 0) fl_sdamt = str_sdamt.doubleValue;
    if (str_ssamt.length > 0) fl_ssamt = str_ssamt.doubleValue;
    if (str_othamt.length > 0) fl_othamt = str_othamt.doubleValue;
    if (str_mrp.length > 0) fl_salemrp = str_mrp.doubleValue;
    if (str_csmamt.length > 0) fl_csmamt = str_csmamt.doubleValue;
    if (str_itemwt.length > 0) fl_itemwt = str_itemwt.doubleValue;
    if (str_bhav.length > 0) fl_bhav = str_bhav.doubleValue;
    double int_polishwt = 0.0;
    if ([fieldname isEqualToString:@"per"]) {
        int_polishwt = (str_itemwt.doubleValue * value.doubleValue) / 100;
        txt_polishwt.text = [NSString stringWithFormat:@"%.2f", int_polishwt];
    }
    NSString *rate = txt_rate.text;
    NSString * str_pc = [NSString stringWithString: [_dicData valueForKey:@"pc"]];
    if (rate.length > 0) fl_rate = rate.doubleValue;
    if (str_pc.length > 0) fl_pc = str_pc.doubleValue;
    NSString *str_percent0 = txt_percent0.text;
    if (str_percent0.length > 0) fl_percent0 = str_percent0.doubleValue;
    NSString *str_percent1 = txt_percent1.text;
    NSString *str_percent2 = txt_percent2.text;
    if (str_percent1.length > 0) fl_percent1 = str_percent1.doubleValue;
    if (str_percent2.length > 0) fl_percent2 = str_percent2.doubleValue;
    double d_wt = 0.0;
    if (txt_polishwt.text.length > 0) d_wt = txt_polishwt.text.doubleValue;
    if ([str_bhav isEqualToString:@"0"]) {
        fl_total = fl_rate * (fl_itemwt + d_wt);
    } else {
        fl_total = (fl_rate / fl_bhav) * (fl_itemwt + d_wt);
    }
    txt_csmamt.text = [NSString stringWithFormat:@"%.0f", fl_total];
    // Calculate for sp_on0
    NSString *sp_on0 = fieldname;//lbl_lbron.text;
    double total_value = 0.0;
    if ([sp_on0 isEqualToString:@"Rs"]) {
        txt_value0.text = [NSString stringWithFormat:@"%.0f", fl_percent0];
    }else if ([sp_on0 isEqualToString:@"%"]) {
        if ([str_lbr24k isEqualToString:@"1"]) {
            double fl_24krate = str_24karat.doubleValue;
            total_value = ([str_bhav isEqualToString:@"0"]) ?
                ((fl_itemwt * fl_24krate) * fl_percent0 / 100) :
                ((fl_itemwt * (fl_24krate / fl_bhav)) * fl_percent0 / 100);
            txt_value0.text = [NSString stringWithFormat:@"%.0f", total_value];
        } else {
            total_value = (fl_csmamt * fl_percent0) / 100;
            txt_value0.text = [NSString stringWithFormat:@"%.0f", total_value];
        }
    } else if ([sp_on0 isEqualToString:@"Pc"]) {
        total_value = fl_pc * fl_percent0;
        txt_value0.text = [NSString stringWithFormat:@"%.0f", total_value];
    } else if ([sp_on0 isEqualToString:@"Wt"]) {
        total_value = (d_wt + fl_itemwt) * fl_percent0;
        txt_value0.text = [NSString stringWithFormat:@"%.0f", total_value];
    }
    // Calculate for sp_on1
    NSString *sp_on1 = spinner_on1.text;
    if ([sp_on1 isEqualToString:@"Rs"]) {
        txt_value1.text = [NSString stringWithFormat:@"%.0f", fl_percent1];
    } else if ([sp_on1 isEqualToString:@"%"]) {
        double total_value = (fl_csmamt * fl_percent1) / 100;
        txt_value1.text = [NSString stringWithFormat:@"%.0f", total_value];
    } else if ([sp_on1 isEqualToString:@"Pc"]) {
        double total_value = fl_pc * fl_percent1;
        txt_value1.text = [NSString stringWithFormat:@"%.0f", total_value];
    } else if ([sp_on1 isEqualToString:@"Wt"]) {
        double total_value = (d_wt + fl_itemwt) * fl_percent1;
        txt_value1.text = [NSString stringWithFormat:@"%.0f", total_value];
    }
    // Calculate for sp_on2
    NSString *sp_on2 = spinner_on2.text;
    if ([sp_on2 isEqualToString:@"Rs"]) {
        txt_value2.text = [NSString stringWithFormat:@"%.0f", fl_percent2];
    } else if ([sp_on2 isEqualToString:@"%"]) {
        double total_value = (fl_csmamt * fl_percent2) / 100;
        txt_value2.text = [NSString stringWithFormat:@"%.0f", total_value];
    } else if ([sp_on2 isEqualToString:@"Pc"]) {
        double total_value = fl_pc * fl_percent2;
        txt_value2.text = [NSString stringWithFormat:@"%.0f", total_value];
    } else if ([sp_on2 isEqualToString:@"Wt"]) {
        double total_value = (d_wt + fl_itemwt) * fl_percent2;
        txt_value2.text = [NSString stringWithFormat:@"%.0f", total_value];
    }
    double txt_csmt = 0.0;
    double txt_val = 0.0;
    double txt_dw = 0.0;
    double othamts = 0.0;
    // Handle txt_csmamt
    if ([txt_csmamt.text containsString:@"."])
    {
        txt_csmt = [txt_csmamt.text doubleValue];
    } else {
        if (txt_csmamt.text.length > 0) {
            int txt_cst = [txt_csmamt.text intValue];
            txt_csmt = (double)txt_cst;
        }
    }
    // Handle txt_value0
    if ([txt_value0.text containsString:@"."]){
        txt_val = [txt_value0.text doubleValue];
    } else {
        if (txt_value0.text.length > 0) {
            int txt_vl = [txt_value0.text intValue];
            txt_val = (double)txt_vl;
        }
    }
    // Handle txt_dwt
    if ([txt_dwt.text containsString:@"."]){
        txt_dw = [txt_dwt.text doubleValue];
    } else {
        if (txt_dwt.text.length > 0){
            int txt_dwl = [txt_dwt.text intValue];
            txt_dw = (double)txt_dwl;
        }
    }
    if (txt_othamt != nil){
        NSString *vale = txt_othamt.text;
        if (vale.length > 0) {
            othamts = [vale doubleValue];
        }
    }
    // Calculate total sale
    double fl_sale = int_polishwt + txt_csmt + txt_val + txt_dw + othamts;
    txt_saletotal.text = [NSString stringWithFormat:@"%.2f", fl_sale];
    // GST Calculation
    double int_val1 = txt_value1.text.doubleValue ?: 0;
    double int_val2 = txt_value2.text.doubleValue ?: 0;
    double int_saleto = txt_saletotal.text.doubleValue ?: 0;
    double int_tot = int_saleto - (int_val1 + int_val2);
    double with_gst = (int_tot * 3) / 100;
    double with_int_gst = int_tot + with_gst;
    txt_gstamt.text = [NSString stringWithFormat:@"%.2f", with_gst];
    txt_gst.text = [NSString stringWithFormat:@"%.2f", with_int_gst];
    txt_total.text = [NSString stringWithFormat:@"%.2f", int_tot];
}

- (IBAction)btn_cancel:(id)sender {
   if (self.completionHandler) {
       self.completionHandler(@"",@"", @"",@"Cancel");
   }
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_save:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want save?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self saveItemAPIWithPolishWt:self->txt_polishwt.text polishPer:self->txt_polishPer.text
            pdis1:self->txt_percent1.text
            pdis2:self->txt_percent2.text
            val1:self->txt_value1.text
            val2:self->txt_value2.text
            dis1On:self->spinner_on1.text
            dis2On:self->spinner_on2.text
            lbr:self->txt_percent0.text
            lbron:self->lbl_lbron.text
            slamt:self->txt_value0.text
            csamt:self->txt_csmamt.text
            remark:self->edt_remark.text
            otherAmt:self->txt_othamt.text
            cartid:self->str_cartid
            rate:self->txt_rate.text
            salemrp:self->txt_total.text
            gst:self->txt_gst.text];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveItemAPIWithPolishWt:(NSString *)polishWt
                     polishPer:(NSString *)polishPer
                         pdis1:(NSString *)pdis1
                         pdis2:(NSString *)pdis2
                          val1:(NSString *)val1
                          val2:(NSString *)val2
                        dis1On:(NSString *)dis1On
                        dis2On:(NSString *)dis2On
                           lbr:(NSString *)lbr
                        lbron:(NSString *)lbron
                         slamt:(NSString *)slamt
                         csamt:(NSString *)csamt
                        remark:(NSString *)remark
                      otherAmt:(NSString *)otherAmt
                         cartid:(NSString *)cartid
                           rate:(NSString *)rate
                        salemrp:(NSString *)salemrp
                            gst:(NSString *)gst{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&polishwt=%@&polishper=%@&pdis1=%@&pdis2=%@&dis1=%@&dis2=%@&dis1on=%@&dis2on=%@&lbr=%@&lbron=%@&slamt=%@&csmamt=%@&remark=%@&other_charges=%@&cartid=%@&rate=%@&salemrp=%@&gst=%@",ECAT_TYPE_NEW,apptype,mobile,ip,db,ipusername,pswd,ftppath,polishWt,polishPer,pdis1,pdis2,val1,val2,dis1On,dis2On,lbr,lbron,slamt,csamt,remark,otherAmt,cartid,rate,salemrp,gst];
        URL_API = [WEB_URL URL_UPDATE_CART_LBR];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/update_cartitemlbr.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ftppath=%@&polishwt=%@&polishper=%@&pdis1=%@&pdis2=%@&dis1=%@&dis2=%@&dis1on=%@&dis2on=%@&lbr=%@&lbron=%@&slamt=%@&csmamt=%@&remark=%@&other_charges=%@&cartid=%@&rate=%@&salemrp=%@&gst=%@",ECAT_TYPE_NEW,apptype,mobile,ftppath,polishWt,polishPer,pdis1,pdis2,val1,val2,dis1On,dis2On,lbr,lbron,slamt,csamt,remark,otherAmt,cartid,rate,salemrp,gst];
    }else{
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ftppath=%@&polishwt=%@&polishper=%@&pdis1=%@&pdis2=%@&dis1=%@&dis2=%@&dis1on=%@&dis2on=%@&lbr=%@&lbron=%@&slamt=%@&csmamt=%@&remark=%@&other_charges=%@&cartid=%@&rate=%@&salemrp=%@&gst=%@",ECAT_TYPE_NEW,apptype,mobile,ftppath,polishWt,polishPer,pdis1,pdis2,val1,val2,dis1On,dis2On,lbr,lbron,slamt,csamt,remark,otherAmt,cartid,rate,salemrp,gst];
        URL_API = [WEB_URL URL_UPDATE_CART_LBR];
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
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
    
            if ([str_success isEqualToString:@"1"]){
                if (self.completionHandler) {
                   self.completionHandler(@"",@"", @"",@"Save");
               }
               [self dismissViewControllerAnimated:YES completion:nil];
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
@end
