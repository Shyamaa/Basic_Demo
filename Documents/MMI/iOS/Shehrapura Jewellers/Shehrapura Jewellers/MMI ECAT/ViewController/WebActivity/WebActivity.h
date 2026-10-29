//
//  WebActivity.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/06/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebActivity : BaseViewController<WKNavigationDelegate,UIGestureRecognizerDelegate>
{
    BOOL theBool;
    //IBOutlet means you can place the progressView in Interface Builder and connect it to your code
    IBOutlet UIProgressView* myProgressView;
    NSTimer *myTimer;
}
@property (strong, nonatomic) IBOutlet WKWebView *wkwebview;
@property(weak,nonatomic)IBOutlet NSString *str_url;
@property (nonatomic, retain) NSString *str_type;
@property (nonatomic, retain) NSURL *pdfUrl;
@end

NS_ASSUME_NONNULL_END
