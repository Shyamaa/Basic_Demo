//
//  WebActivity.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/06/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import "WebActivity.h"
#import "BusyIndicator.h"
#import <QuartzCore/QuartzCore.h>

@interface WebActivity ()
{
    NSString *mainUrl;
}
@end

@implementation WebActivity
@synthesize str_url,str_type;
@synthesize wkwebview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BusyIndicator sharedInstance]startIndicator];
    self.title=str_type;
    
    if (self.pdfUrl.description.length > 0) {
        [self openPDF];
    }else{
        
        NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
        NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
        NSString *loginid = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginid"];
        NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
        
        NSString *category;
        
        if ([scategory isEqualToString:@"Retail"]) {
            category = @"1";
        }else if ([scategory isEqualToString:@"Trader"]){
            category = @"2";
        }else if ([scategory isEqualToString:@"Karigar"]){
            category = @"3";
        }else if ([scategory isEqualToString:@"Staff"]){
            category = @"4";
        }else if ([scategory isEqualToString:@"Admin"]){
            category = @"5";
        }else if ([scategory isEqualToString:@"Branch"]){
            category = @"6";
        }else if ([scategory isEqualToString:@"Dealer"]){
            category = @"7";
        }else if ([scategory isEqualToString:@"Not any category"]){
            category = @"0";
        }
        username = [username stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        mainUrl = [NSString stringWithFormat:@"%@?mobile=%@&cname=%@&catid=%@&loginid=%@",str_url,mobile,username,category,loginid];
        NSLog(@"mainUrl **************************************%@",mainUrl);
        NSURL *url = [NSURL URLWithString:mainUrl];
        [wkwebview loadRequest:[NSURLRequest requestWithURL:url]];
    }
    wkwebview.navigationDelegate = self;

//    myProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//    myProgressView.progressTintColor = [UIColor colorWithRed:187.0/255 green:160.0/255 blue:209.0/255 alpha:1.0];
//    [[myProgressView layer]setFrame:CGRectMake(self.view.frame.size.width/2, 65, 50, 50)];
//    [[myProgressView layer]setBorderColor:[UIColor blackColor].CGColor];
//    myProgressView.trackTintColor = [UIColor clearColor];
//    [myProgressView setProgress:(float)(50/100) animated:YES];  ///15
//
//    [[myProgressView layer]setCornerRadius:myProgressView.frame.size.width / 2];
//    [[myProgressView layer]setBorderWidth:3];
//    [[myProgressView layer]setMasksToBounds:TRUE];
//    myProgressView.clipsToBounds = YES;
//    [self.view addSubview:myProgressView];
//
//    myProgressView.progress = 0;
//    theBool = false;
//    //0.01667 is roughly 1/60, so it will update at 60 FPS
//    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];

}

- (void)openPDF {
    NSURLRequest *request = [NSURLRequest requestWithURL:_pdfUrl];
    [self.wkwebview loadRequest:request];
}

// Start loading WKWebView
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"Start loading");
    NSLog(@"************************* start ");

}

//Finished loading WKWebView
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"End loading");
    NSLog(@"************************* finish ");
    [[BusyIndicator sharedInstance]stopIndicator];

//    theBool = true;
//    myProgressView.hidden=YES;

}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    NSLog(@"************************* start ");
//
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    theBool = true;
//    myProgressView.hidden=YES;
//    NSLog(@"************************* finish ");
//}
-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}

//
//- (void)tapAction:(UITapGestureRecognizer *)sender
//{
//    NSLog(@"touched");
//
//    // Get the specific point that was touched
//    //    CGPoint point = [sender locationInView:self.view];
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    if(navigationAction.navigationType == WKNavigationTypeLinkActivated)
//    {
//        NSLog(@"dsjkfadjshjfhadsfjkhajksdhfjkhadjksfhjkhsadjkfhkdahsjkfhajksdh");
//    }else{
//        NSLog(@"111111111111111111111111111111111111");
//
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}


@end
