//
//  ScanViewController.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 14/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSString *str_act;
@property (nonatomic, retain) NSString *visid;
@property (nonatomic, retain) NSString *cusmobile;
@property (nonatomic, retain) NSString *act;
@property (nonatomic, strong) NSMutableArray *scannedCodes;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *qrCodeLayers;
@property (nonatomic, strong) NSMutableSet *recentlyScanned;




- (BOOL)startReading;
- (IBAction)btn_send:(id)sender;
- (IBAction)btn_submit:(id)sender;

@end

NS_ASSUME_NONNULL_END
