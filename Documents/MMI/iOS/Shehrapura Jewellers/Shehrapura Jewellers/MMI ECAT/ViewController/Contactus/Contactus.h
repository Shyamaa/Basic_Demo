//
//  Contactus.h
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contactus : BaseViewController
{
    __weak IBOutlet UIView *view_bottom;
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIView *view2;
    __weak IBOutlet UIView *view3;
    __weak IBOutlet UIView *view4;
    __weak IBOutlet UIView *view5;
    __weak IBOutlet UIView *view6;
    __weak IBOutlet UIView *view7;
    
    __weak IBOutlet UILabel *lbl_head1;
    __weak IBOutlet UILabel *lbl_contact1;
    __weak IBOutlet UILabel *lbl_head2;
    __weak IBOutlet UILabel *lbl_contact2;
    __weak IBOutlet UILabel *lbl_head3;
    __weak IBOutlet UILabel *lbl_contact3;
    __weak IBOutlet UILabel *lbl_head4;
    __weak IBOutlet UILabel *lbl_contact4;
    __weak IBOutlet UILabel *lbl_address;
    __weak IBOutlet UILabel *lbl_address2;
    
    
}
@property (nonatomic, retain) NSString *str_type;
@property (nonatomic, assign) BOOL isSideMenu;
- (IBAction)btn_fb:(id)sender;
- (IBAction)btn_twitter:(id)sender;
- (IBAction)btn_insta:(id)sender;
- (IBAction)btn_website:(id)sender;

@end

NS_ASSUME_NONNULL_END
