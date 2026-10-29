//
//  WhatsAppShareVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "WhatsAppShareVC.h"
#import "SWRevealViewController.h"

@interface WhatsAppShareVC ()
{
    NSString *str_msg;
    NSInteger shareOnSelectedIndex, shareConfigSelectedIndex, galleryShareSelectedIndex, galleryImageSelectedIndex;
}
@end

@implementation WhatsAppShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Share Config";
    [self setUpNavigationBtn];
    txtViewMsg.text = @"Enter Message";
    txtViewMsg.textColor = [UIColor lightGrayColor];
    str_msg = @"";
    shareOnSelectedIndex = 0;
    shareConfigSelectedIndex = 0;
    galleryShareSelectedIndex = 0;
    galleryImageSelectedIndex = 1;
    btnWithoutImg.tag = 0;
    btnWithImg.tag = 1;
    btnOnlyImg.tag = 2;
    btnSaperatePage.tag = 3;
    //[self clearAllData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self loadShareConfig];
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"Start type");
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    //if (([ECAT_TYPE isEqualToString:@"1"]) || ([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"])){
        SWRevealViewController *revealController = [self revealViewController];
        //[revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        UIImage *image = [UIImage imageNamed:@"menu.png"];
        CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
        [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
        [someButton1 addTarget:revealController action:@selector(revealToggle:)
              forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    //}
}

-(void) setUpMessage{
    if ([txtViewMsg.text isEqualToString: @""] && str_msg.length < 1 ){
        txtViewMsg.text = @"Enter Message";
        txtViewMsg.textColor = [UIColor lightGrayColor];
    }else if ([txtViewMsg.text isEqualToString: @"Enter Message"]) {
        txtViewMsg.text = @"";
        txtViewMsg.textColor = [UIColor blackColor];
    }else{
        txtViewMsg.text = str_msg;
        txtViewMsg.textColor = [UIColor blackColor];
    }
}

-(void) setUpShareOn{
    btnAll.selected = false;
    btnWhatsApp.selected = false;
    btnWaBusiness.selected = false;
    btnViewPdf.selected = false;
    switch (shareOnSelectedIndex) {
        case 1:
            btnWhatsApp.selected = true;
            break;
        case 2:
            btnWaBusiness.selected = true;
            break;
        case 3:
            btnViewPdf.selected = true;
            break;
        default:
            btnAll.selected = true;
            break;
    }
}

-(void) setUpShareCnfig{
    btnNone.selected = false;
    btnDetails.selected = false;
    if (shareConfigSelectedIndex == 1){
        btnDetails.selected = true;
    }else{
        btnNone.selected = true;
    }
}

-(void) setUpGalleryShare{
    btnLocal.selected = false;
    btnOnline.selected = false;
    if (galleryShareSelectedIndex == 1){
        btnOnline.selected = true;
    }else{
        btnLocal.selected = true;
    }
}

-(void) setUpGalleryShareImg{
    btnWithImg.selected = false;
    btnOnlyImg.selected = false;
    btnWithoutImg.selected = false;
    btnSaperatePage.selected = false;
    switch (galleryImageSelectedIndex) {
        case 2:
            btnOnlyImg.selected = true;
            break;
        case 0:
            btnWithoutImg.selected = true;
            break;
        case 3:
            btnSaperatePage.selected = true;
            break;
        default:
            btnWithImg.selected = true;
            break;
    }
}

#pragma mark:- Bottom TabBar Button Action Method

- (IBAction)btnShareOnAction:(UIButton *)sender{
    shareOnSelectedIndex = sender.tag;
    [self setUpShareOn];
    //sender.selected = !sender.selected;
}

- (IBAction)btnShareCnfigAction:(UIButton *)sender{
    shareConfigSelectedIndex = sender.tag;
    [self setUpShareCnfig];
    //sender.selected = !sender.selected;
}

- (IBAction)btnProductGalleryAction:(UIButton *)sender{
    galleryShareSelectedIndex = sender.tag;
    [self setUpGalleryShare];
    //sender.selected = !sender.selected;
}

- (IBAction)btnProductGalleryImageAction:(UIButton *)sender{
    galleryImageSelectedIndex = sender.tag;
    [self setUpGalleryShareImg];
    //sender.selected = !sender.selected;
}

- (IBAction)btnPdfCnfigAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (IBAction)btnSaveAction:(UIButton *)sender{
    if ([txtViewMsg.text isEqualToString: @"Enter Message"]) {
        str_msg = @"";
    }else{
        str_msg = txtViewMsg.text;
    }
    NSLog(@"shareOnSelectedIndex = %ld", shareOnSelectedIndex);
    NSLog(@"shareConfigSelectedIndex = %ld", (long)shareConfigSelectedIndex);
    NSLog(@"galleryShareSelectedIndex = %ld", galleryShareSelectedIndex);
    NSLog(@"galleryImageSelectedIndex = %ld", galleryImageSelectedIndex);
    NSLog(@"str_msg = %@", str_msg);
    NSLog(@"pdfSimple = %i", btnSimple.selected);
    NSLog(@"pdfSummary = %i", btnSummery.selected);
    [self saveShareConfig];
}

- (void)saveShareConfig {
    [[BusyIndicator sharedInstance]startIndicator];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Example: Save selected option indexes (use tag or index)
    [defaults setInteger: shareOnSelectedIndex forKey:@"shareOn"];
    [defaults setInteger: shareConfigSelectedIndex forKey:@"shareConfig"];
    [defaults setInteger: galleryShareSelectedIndex forKey:@"galleryShare"];
    [defaults setInteger: galleryImageSelectedIndex forKey:@"galleryImage"];
    
    // Save checkbox state
    [defaults setBool: btnSimple.selected forKey:@"pdfSimple"];
    [defaults setBool: btnSummery.selected forKey:@"pdfSummary"];
    
    // Save custom message from UITextView/TextField
    [defaults setObject: str_msg forKey:@"customMessage"];
    
    [defaults synchronize]; // optional in modern iOS, but still safe
    [self alertMsg:@"Data save successfully"];
    dispatch_async(dispatch_get_main_queue(), ^{
    [[BusyIndicator sharedInstance]stopIndicator];
    });
}

- (void)loadShareConfig {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    shareOnSelectedIndex = [defaults integerForKey:@"shareOn"];
    shareConfigSelectedIndex = [defaults integerForKey:@"shareConfig"];
    galleryShareSelectedIndex = [defaults integerForKey:@"galleryShare"];
    galleryImageSelectedIndex = [defaults integerForKey:@"galleryImage"];
    
    btnSimple.selected = [defaults boolForKey:@"pdfSimple"];
    btnSummery.selected = [defaults boolForKey:@"pdfSummary"];
    
    str_msg = [defaults stringForKey:@"customMessage"];
    
    // Now update your UI controls based on the values
    [self updateUISelections];
}

- (void)updateUISelections {
    [self setUpShareOn];
    [self setUpShareCnfig];
    [self setUpGalleryShare];
    [self setUpGalleryShareImg];
    txtViewMsg.text = str_msg;
    [self setUpMessage];
}

- (void)clearAllData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"shareOn"];
    [defaults removeObjectForKey:@"shareConfig"];
    [defaults removeObjectForKey:@"galleryShare"];
    [defaults removeObjectForKey:@"galleryImage"];
    [defaults removeObjectForKey:@"pdfSimple"];
    [defaults removeObjectForKey:@"pdfSummary"];
    [defaults removeObjectForKey:@"customMessage"];
    [defaults synchronize];
}

@end


