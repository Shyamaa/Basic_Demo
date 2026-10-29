//
//  Aboutus.h
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Aboutus : BaseViewController<UITextViewDelegate>
{
    __weak IBOutlet UITextView *txt_data;
    IBOutlet UIImageView *imgView;
    
}
@property (nonatomic, retain) NSString *str_type;
@property (nonatomic, assign) BOOL isSideMenu;


@end

NS_ASSUME_NONNULL_END
