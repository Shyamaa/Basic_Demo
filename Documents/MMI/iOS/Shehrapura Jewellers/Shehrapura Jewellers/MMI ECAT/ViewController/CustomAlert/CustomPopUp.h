//
//  CustomPopUp.h
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 19/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ClickDelegates;

@interface CustomPopUp : UIView{
    
    UIView *childPopUp;
    id<ClickDelegates> _click_delegate;
    UIViewController *_parent;

}

@property (nonatomic, retain) id<ClickDelegates> _click_delegate;
@property (nonatomic, retain) UIViewController *_parent;

-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate;

-(IBAction)OnOKClick :(id) sender;

-(void) hide;

-(void) show;

@end
// Delegate
 
@protocol ClickDelegates<NSObject>
 
@optional
 
-(void) okClicked;
-(void) cancelClicked;
 
@end
NS_ASSUME_NONNULL_END
