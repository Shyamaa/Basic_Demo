//
//  WhatsAppShareVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#ifndef WhatsAppShareVC_h
#define WhatsAppShareVC_h

@interface WhatsAppShareVC : BaseViewController <UITextViewDelegate>
{
    NSMutableArray *array_item;
    
    IBOutlet UITextView *txtViewMsg;
    
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnWhatsApp;
    IBOutlet UIButton *btnWaBusiness;
    IBOutlet UIButton *btnViewPdf;
    
    IBOutlet UIButton *btnNone;
    IBOutlet UIButton *btnDetails;
    
    IBOutlet UIButton *btnLocal;
    IBOutlet UIButton *btnOnline;
    
    IBOutlet UIButton *btnOnlyImg;
    IBOutlet UIButton *btnWithImg;
    IBOutlet UIButton *btnWithoutImg;
    IBOutlet UIButton *btnSaperatePage;
    
    IBOutlet UIButton *btnSimple;
    IBOutlet UIButton *btnSummery;
}

@end

#endif /* WhatsAppShareVC_h */
