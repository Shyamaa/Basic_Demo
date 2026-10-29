//
//  FilterView.m
//  Swiz Gold and Diamonds
//
//  Created by MMI Softwares Pvt Ltd on 16/05/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "FilterView.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.contentView];
    [self setUpGrossSlider];
    //[self txtDelegate];
}

#pragma mark: - Helper Method

//Method call by perent vc
- (void)setupWithArray:(NSArray *)arrayTagNo design:(NSArray *)arrayDesignNo status:(NSArray *)arrayStatus stamp:(NSArray *)arrayStamp size:(NSArray *)arraySize listData:(NSArray *)arraylistData karigarData:(NSArray *)arrayKarigarList qualityList:(NSArray *)arrayQualityList siteList:(NSArray *)arraySiteList gCodeList:(NSArray *)arrayGCodeList {
    [self.txtSelectTagNo addPickerWithData:arrayTagNo searchEnabled:NO];
    [self.txtDesignNo addPickerWithData:arrayDesignNo searchEnabled:NO];
    [self.txtStatus addPickerWithData:arrayStatus searchEnabled:NO];
    [self.txtStamp addPickerWithData:arrayStamp searchEnabled:NO];
    [self.txtSize addPickerWithData:arraySize searchEnabled:NO];
    
    [self.txtKarigar addPickerWithData:arrayKarigarList searchEnabled:NO];
    [self.txtQuality addPickerWithData:arrayQualityList searchEnabled:NO];
    [self.txtSite addPickerWithData:arraySiteList searchEnabled:NO];
    [self.txtGCode addPickerWithData:arrayGCodeList searchEnabled:NO];
    
    self.arrayListData = [[NSArray alloc]init];
    self.arrayListData = arraylistData;
    [self getAPIWithApiName];
}

-(void)txtDelegate{
    self.txtGrossWtFrom.delegate = self;
    self.txtGrossWtTo.delegate = self;
    
    self.txtNetWtFrom.delegate = self;
    self.txtNetWtTo.delegate = self;
    
    self.txtDiaWtFrom.delegate = self;
    self.txtDiaWtTo.delegate = self;
    
    self.txtSaleMrpFrom.delegate = self;
    self.txtSaleMrpTo.delegate = self;
    
    self.txtStnWtFrom.delegate = self;
    self.txtStnWtTo.delegate = self;
}

-(void)setUpGrossSlider{
    IARangeSlider* rangeSlider = [[IARangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.viewGrossWt.frame.size.width, 20)];
    rangeSlider.minimumValue = 0;
    rangeSlider.maximumValue = 50;
    rangeSlider.upperValue = 50;
    rangeSlider.lowerValue = 0;
    
    IARangeSlider* rangeSlider2 = [[IARangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.viewNetWt.frame.size.width, 20)];
    rangeSlider2.minimumValue = 0;
    rangeSlider2.maximumValue = 50;
    rangeSlider2.upperValue = 50;
    rangeSlider2.lowerValue = 0;
    
    IARangeSlider* rangeSlider3 = [[IARangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.viewDiaWt.frame.size.width, 20)];
    rangeSlider3.minimumValue = 0;
    rangeSlider3.maximumValue = 50;
    rangeSlider3.upperValue = 50;
    rangeSlider3.lowerValue = 0;
    
    IARangeSlider* rangeSlider4 = [[IARangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.viewSaleMrp.frame.size.width, 20)];
    rangeSlider4.minimumValue = 0;
    rangeSlider4.maximumValue = 50;
    rangeSlider4.upperValue = 50;
    rangeSlider4.lowerValue = 0;
    
    IARangeSlider* rangeSlider5 = [[IARangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.viewStnWt.frame.size.width, 20)];
    rangeSlider5.minimumValue = 0;
    rangeSlider5.maximumValue = 50;
    rangeSlider5.upperValue = 50;
    rangeSlider5.lowerValue = 0;
    
    self.rangeSliderGross  = rangeSlider;
    self.rangeSliderNet  = rangeSlider2;
    self.rangeSliderDia  = rangeSlider3;
    self.rangeSliderSaleMrp  = rangeSlider4;
    self.rangeSliderStn  = rangeSlider5;
    
    [self.viewGrossWt addSubview:self.rangeSliderGross];
    [self.viewNetWt addSubview:self.rangeSliderNet];
    [self.viewDiaWt addSubview:self.rangeSliderDia];
    [self.viewSaleMrp addSubview:self.rangeSliderSaleMrp];
    [self.viewStnWt addSubview:self.rangeSliderStn];
    
    self.rangeSliderGross.tag = 11;
    self.rangeSliderNet.tag = 22;
    self.rangeSliderDia.tag = 33;
    self.rangeSliderSaleMrp.tag = 44;
    self.rangeSliderStn.tag = 55;
    
    [self.rangeSliderGross addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.rangeSliderNet addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.rangeSliderDia addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.rangeSliderSaleMrp addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.rangeSliderStn addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
//    [self rangeSliderValueDidChange: self.rangeSliderGross];
//    [self rangeSliderValueDidChange: self.rangeSliderNet];
//    [self rangeSliderValueDidChange: self.rangeSliderDia];
//    [self rangeSliderValueDidChange: self.rangeSliderSaleMrp];
//    [self rangeSliderValueDidChange: self.rangeSliderStn];
}

-(void)rangeSliderValueDidChange:(IARangeSlider*)rangeSlider{
    NSLog(@"RANGE : (%f, %f)", rangeSlider.lowerValue, rangeSlider.upperValue);
    //[self.txtGrossWtTo setText:[NSString stringWithFormat:@"%.02f, %.02f", rangeSlider.lowerValue, rangeSlider.upperValue]];
    switch (rangeSlider.tag) {
        case 11:
            self.txtGrossWtFrom.text = [NSString stringWithFormat:@"%.02f", rangeSlider.lowerValue];
            self.txtGrossWtTo.text = [NSString stringWithFormat:@"%.02f", rangeSlider.upperValue];
            break;
        case 22:
            self.txtNetWtFrom.text = [NSString stringWithFormat:@"%.02f", rangeSlider.lowerValue];
            self.txtNetWtTo.text = [NSString stringWithFormat:@"%.02f", rangeSlider.upperValue];
            break;
        case 33:
            self.txtDiaWtFrom.text = [NSString stringWithFormat:@"%.02f", rangeSlider.lowerValue];
            self.txtDiaWtTo.text = [NSString stringWithFormat:@"%.02f", rangeSlider.upperValue];
            break;
        case 44:
            self.txtSaleMrpFrom.text = [NSString stringWithFormat:@"%.02f", rangeSlider.lowerValue];
            self.txtSaleMrpTo.text = [NSString stringWithFormat:@"%.02f", rangeSlider.upperValue];
            break;
        case 55:
            self.txtStnWtFrom.text = [NSString stringWithFormat:@"%.02f", rangeSlider.lowerValue];
            self.txtStnWtTo.text = [NSString stringWithFormat:@"%.02f", rangeSlider.upperValue];
            break;
        default:
            break;
    }
}

#pragma mark:- UITextField Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    CGFloat value = [updatedString floatValue];
    NSLog(@"value %@", updatedString);
    if (textField == self.txtGrossWtFrom || textField == self.txtGrossWtTo) {
        if (textField == self.txtGrossWtFrom && (value < self.rangeSliderGross.upperValue)) {
            [self.rangeSliderGross setLowerValue: value];
        }else if (textField == self.txtGrossWtTo && (value < self.rangeSliderGross.maximumValue)){
            [self.rangeSliderGross setUpperValue: value];
        }else{
            [self rangeSliderValueDidChange: self.rangeSliderGross];
        }
    }else if (textField == self.txtNetWtFrom || textField == self.txtNetWtTo) {
        if (textField == self.txtNetWtFrom && (value < self.rangeSliderNet.upperValue)) {
            [self.rangeSliderNet setLowerValue: value];
        }else if (textField == self.txtNetWtTo && (value > self.rangeSliderNet.lowerValue)){
            self.rangeSliderNet.upperValue = value;
        }else{
            [self rangeSliderValueDidChange: self.rangeSliderNet];
        }
    }else if (textField == self.txtDiaWtFrom || textField == self.txtDiaWtTo) {
        if (textField == self.txtDiaWtFrom && (value < self.rangeSliderDia.upperValue)) {
            [self.rangeSliderDia setLowerValue: value];
        }else if (textField == self.txtDiaWtTo && (value > self.rangeSliderDia.lowerValue)){
            [self.rangeSliderDia setUpperValue: value];
        }else{
            [self rangeSliderValueDidChange: self.rangeSliderDia];
        }
    }else if (textField == self.txtSaleMrpFrom || textField == self.txtSaleMrpTo) {
        if (textField == self.txtSaleMrpFrom && (value < self.rangeSliderSaleMrp.upperValue)) {
            [self.rangeSliderSaleMrp setLowerValue: value];
        }else if (textField == self.txtSaleMrpTo && (value > self.rangeSliderSaleMrp.lowerValue)){
            [self.rangeSliderSaleMrp setUpperValue: value];
        }else{
            [self rangeSliderValueDidChange: self.rangeSliderSaleMrp];
        }
    }else if (textField == self.txtStnWtFrom || textField == self.txtStnWtTo) {
        if (textField == self.txtGrossWtFrom && (value < self.rangeSliderStn.upperValue)) {
            [self.rangeSliderStn setLowerValue: value];
        }else if (textField == self.txtGrossWtTo && (value > self.rangeSliderStn.lowerValue)){
            [self.rangeSliderStn setUpperValue: value];
        }else{
            [self rangeSliderValueDidChange: self.rangeSliderStn];
        }
    }
    return YES;
}

#pragma mark:- IBAction Method

- (IBAction)closeButtonTapped:(id)sender {
    if (self.onCloseTapped) {
        self.onCloseTapped(@[],false);
    }
}

- (IBAction)submitButtonTapped:(id)sender {
    [self getItemListApi:@"YES"];
}

#pragma mark:- Api Method

//URL_ItemFilterRecord

- (void)getAPIWithApiName{
    [[BusyIndicator sharedInstance] startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *strmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *apptype = ECAT_TYPE;
    NSString *apiName = [WEB_URL URL_ItemFilterRecord];
    NSArray *idescArray = (NSArray *)[self.arrayListData valueForKey:@"idesc"];
    NSString *idesc = idescArray.firstObject ?: @"";
    
    NSMutableDictionary *params = [@{
        @"apptype": apptype ?: @"",
        @"ECAT_TYPE_NEW": ECAT_TYPE ?: @"",
        @"mobile": strmobile ?: @"",
        @"idesc": idesc ?: @"",
    } mutableCopy];

    // Now modify params based on app type
    if ([apptype isEqualToString:@"1"]) {
        // For example, add or update keys specific to app type 1
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"] ?: @"";
        NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"] ?: @"";
        NSString *ipusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"] ?: @"";
        NSString *pswd = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"] ?: @"";
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"] ?: @"";

        params[@"ip"] = ip;
        params[@"dbname"] = db;
        params[@"ipusername"] = ipusername;
        params[@"password"] = pswd;
        params[@"ftppath"] = ftppath;
        
    } else if ([apptype isEqualToString:@"2"]) {
        // App type 2 might only need a subset or different params
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"] ?: @"";
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"] ?: @"";
        
        // Maybe remove keys not used for type 2 (optional)
        [params removeObjectForKey:@"ipusername"];
        [params removeObjectForKey:@"password"];
        [params removeObjectForKey:@"dbname"];
        
        params[@"ip"] = ip;
        params[@"ftppath"] = ftppath;
    } else {
        // Default or other app types — you can add or remove keys here as needed
        // For example, remove sensitive keys if not used
        [params removeObjectForKey:@"ip"];
        [params removeObjectForKey:@"dbname"];
        [params removeObjectForKey:@"ipusername"];
        [params removeObjectForKey:@"password"];
        [params removeObjectForKey:@"ftppath"];
    }

    // After finalizing params, create POST body string:
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in params) {
        NSString *value = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, value ?: @""]];
    }
    NSString *postBody = [paramArray componentsJoinedByString:@"&"];

    // Now you can use `postBody` as your HTTPBody in the POST request
    NSLog(@"📤 POST Body: %@", postBody);
    NSLog(@"📡 API URL: %@", apiName);

    // Setup request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiName]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData *bodyData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];

    // Send request
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];

            if (error) {
                NSLog(@"❌ Request Error: %@", error.localizedDescription);
                return;
            }
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"📥 Raw Response: %@", responseString);

            NSError *jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                // Instead of crashing, show backend error
                NSLog(@"Json Error = %@", jsonError);
            } else {
                NSLog(@"Json = %@", json);
                NSMutableDictionary *pDict = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                              error:&jsonError];
                
                NSMutableArray *array_filterlist = [pDict objectForKey:@"filterlist"];
                NSLog(@"array_filterlist = %@", array_filterlist);
                for (NSDictionary *item in array_filterlist) {
                    NSString *itemName = [item valueForKey:@"itemname"];
                    if([itemName isEqualToString:@"gwt"]){
                        self.stackViewGrossWt.hidden = false;
                    }else if([itemName isEqualToString:@"wt"]){
                        self.stackViewNetWt.hidden = false;
                    }else if([itemName isEqualToString:@"sdiawt"]){
                        self.stackViewDiaWt.hidden = false;
                    }else if([itemName isEqualToString:@"salemrp"]){
                        self.stackViewSaleMrp.hidden = false;
                    }else if([itemName isEqualToString:@"swt"]){
                        self.stackViewStnWt.hidden = false;
                    }else if([itemName isEqualToString:@"tag"]){
                        self.stackViewSelectTagNo.hidden = false;
                    }else if([itemName isEqualToString:@"tgno"]){
                        self.stackViewSelectTagNo.hidden = false;
                        self.stackViewTagNo.hidden = false; 
                    }else if([itemName isEqualToString:@"design"]){
                        self.stackViewDesignNo.hidden = false;
                    }else if([itemName isEqualToString:@"status"]){
                        self.stackViewStatus.hidden = false;
                    }else if([itemName isEqualToString:@"karigar"]){
                        self.stackViewKarigar.hidden = false;
                    }else if([itemName isEqualToString:@"stamp"]){
                        self.stackViewStamp.hidden = false;
                    }else if([itemName isEqualToString:@"quality"]){
                        self.stackViewQuality.hidden = false;
                    }else if([itemName isEqualToString:@"size"]){
                        self.stackViewSize.hidden = false;
                    }else if([itemName isEqualToString:@"quality"]){
                        self.stackViewQuality.hidden = false;
                    }else if([itemName isEqualToString:@"gcode"]){
                        self.stackViewGCode.hidden = false;
                    }
                }
            }
        });
    }];

    [task resume];
}

-(void)getItemListApi:(NSString *)isFilter {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *status = [[NSUserDefaults standardUserDefaults]stringForKey:@"status"];
    NSString *URL_API;
    
    if ([ECAT_TYPE isEqualToString:@"3"] && [status isEqualToString:@"4"]) {
        URL_API =[WEB_URL URL_ItemFilter4];
    }else{
        URL_API =[WEB_URL URL_ItemFilter];
    }
    
    [self getAPIWithApiName:URL_API
                       type:isFilter
                 completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@" Filter Response: %@", response);
            NSArray *listData = [response objectForKey:@"items"];
            NSLog(@"feeditem %@", listData);
            if (self.onCloseTapped) {
                self.onCloseTapped(listData,true);
            }
        }
        [[BusyIndicator sharedInstance] stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            // ✅ Safe UI updates here
            
        });
    }];
}

- (void)getAPIWithApiName:(NSString *)apiName
                     type:(NSString *)filter
               completion:(void (^)(NSDictionary *response, NSError *error))completion {

    [[BusyIndicator sharedInstance] startIndicator];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *strmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *category = [[NSUserDefaults standardUserDefaults] stringForKey:@"category"];
    NSString *apptype = ECAT_TYPE;

    // Collect all parameters
    NSString *(^safeText)(UITextField *) = ^NSString *(UITextField *field) {
        return ([field.text isEqualToString:@"0.00"] || [field.text isEqualToString:@"All"]) ? @"" : field.text;
    };

    NSArray *idescArray = (NSArray *)[self.arrayListData valueForKey:@"idesc"];
    NSString *idesc = idescArray.firstObject ?: @"";

    NSArray *karigarArray = (NSArray *)[self.arrayListData valueForKey:@"karigar"];
    NSString *karigar1 = karigarArray.firstObject ?: @"";

    //NSString *karigar = ([self.txtKarigar.text isEqualToString:@"All"] ? karigar1 : self.txtKarigar.text) ?: @"";
    NSString *karigar = [self.txtKarigar.text isEqualToString:@"All"] ? @"" : (self.txtKarigar.text ?: @"");
    
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSMutableDictionary *params = [@{
        @"apptype": apptype ?: @"",
        @"ECAT_TYPE_NEW": ECAT_TYPE ?: @"",
        
        // Common params (can be empty if not applicable)
        @"mobile": strmobile ?: @"",
        @"idesc": idesc ?: @"",
        @"gwtf": safeText(self.txtGrossWtFrom),
        @"gwtt": safeText(self.txtGrossWtTo),
        @"wtf": safeText(self.txtNetWtFrom),
        @"wtt": safeText(self.txtNetWtTo),
        @"sdiawtf": safeText(self.txtDiaWtFrom),
        @"sdiawtt": safeText(self.txtDiaWtTo),
        @"sstnwtf": safeText(self.txtStnWtFrom),
        @"sstnwtt": safeText(self.txtStnWtTo),
        @"salemrpf": safeText(self.txtSaleMrpFrom),
        @"salemrpt": safeText(self.txtSaleMrpTo),
        @"tgno": safeText(self.txtSelectTagNo),
        @"design": safeText(self.txtDesignNo),
        @"status": safeText(self.txtStatus),
        @"stamp": safeText(self.txtStamp),
        @"size": safeText(self.txtSize),
        @"karigar": karigar ?: @"",
        @"quality": safeText(self.txtQuality),
        @"site": safeText(self.txtSite),
        @"gcode": safeText(self.txtGCode),
        
        // Additional optional params with default empty values
        @"stnpcf": @"", @"stnpct": @"",
        @"sdamtf": @"", @"sdamtt": @"",
        @"ssamtf": @"", @"ssamtt": @"",
        @"certno": @"", @"color": @"",
        @"diapcf": @"", @"diapct": @"",
        @"clarity": @"", @"hm": @"",
        @"shape": @"", @"otherm": @"",
        //@"filter_up": @"UP",
        @"stone": @"", @"spoint": @"0", @"epoint": @"50"
        
    } mutableCopy];

    // Now modify params based on app type
    if ([apptype isEqualToString:@"1"]) {
        // For example, add or update keys specific to app type 1
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"] ?: @"";
        NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"] ?: @"";
        NSString *ipusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"] ?: @"";
        NSString *pswd = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"] ?: @"";
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"] ?: @"";

        params[@"ip"] = ip;
        params[@"dbname"] = db;
        params[@"ipusername"] = ipusername;
        params[@"password"] = pswd;
        params[@"ftppath"] = ftppath;
        
    } else if ([apptype isEqualToString:@"2"]) {
        // App type 2 might only need a subset or different params
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"] ?: @"";
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"] ?: @"";
        
        // Maybe remove keys not used for type 2 (optional)
        [params removeObjectForKey:@"ipusername"];
        [params removeObjectForKey:@"password"];
        [params removeObjectForKey:@"dbname"];
        
        params[@"ip"] = ip;
        params[@"ftppath"] = ftppath;
    } else {
        // Default or other app types — you can add or remove keys here as needed
        // For example, remove sensitive keys if not used
        [params removeObjectForKey:@"ip"];
        [params removeObjectForKey:@"dbname"];
        [params removeObjectForKey:@"ipusername"];
        [params removeObjectForKey:@"password"];
        [params removeObjectForKey:@"ftppath"];
    }

    // After finalizing params, create POST body string:
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in params) {
        NSString *value = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, value ?: @""]];
    }
    NSString *postBody = [paramArray componentsJoinedByString:@"&"];

    // Now you can use `postBody` as your HTTPBody in the POST request
    NSLog(@"📤 POST Body: %@", postBody);
    NSLog(@"📡 API URL: %@", apiName);

    // Setup request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiName]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData *bodyData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];

    // Send request
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];

            if (error) {
                NSLog(@"❌ Request Error: %@", error.localizedDescription);
                completion(nil, error);
                return;
            }
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"📥 Raw Response: %@", responseString);

            NSError *jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (jsonError) {
                // Instead of crashing, show backend error
                NSError *customError = [NSError errorWithDomain:apiName
                                                           code:1002
                                                       userInfo:@{
                                                           NSLocalizedDescriptionKey: responseString ?: @"Server error"
                                                       }];
                completion(nil, customError);
            } else {
                completion(json, nil);
            }

            
/*
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"📥 Raw Response: %@", responseString);

            NSError *jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (jsonError) {
                NSLog(@"❌ JSON Parse Error: %@", jsonError.localizedDescription);
                completion(nil, jsonError);
            } else if ([json isKindOfClass:[NSDictionary class]]) {
                completion((NSDictionary *)json, nil);
            } else if ([json isKindOfClass:[NSArray class]]) {
                // If response is an array, wrap it in a dictionary
                completion(@{ @"data": json }, nil);
            } else {
                NSError *formatError = [NSError errorWithDomain:@"com.app.api"
                                                           code:1001
                                                       userInfo:@{NSLocalizedDescriptionKey: @"Unexpected response format"}];
                completion(nil, formatError);
            }
            */
        });
    }];

    [task resume];
}


@end
