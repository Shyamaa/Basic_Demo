//
//  CustomAlert.h
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 17/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CustomAlertViewControllerDelegate;



NS_ASSUME_NONNULL_BEGIN

@interface CustomAlert : BaseViewController
@property (nonatomic, retain) id<CustomAlertViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnOK;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flexSpace;

-(void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message;
-(void)removeCustomAlertFromView;
-(void)removeCustomAlertFromViewInstantly;
-(void)removeOkayButton:(BOOL)shouldRemove;
-(void)removeCancelButton:(BOOL)shouldRemove;
-(BOOL)isOkayButtonRemoved;
-(BOOL)isCancelButtonRemoved;

-(void)customAlertOK;
-(void)customAlertCancel;

@end

NS_ASSUME_NONNULL_END
