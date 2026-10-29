//
//  UITextField+PickerWithSearch.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PickerWithSearch)

- (void)addPickerWithData:(NSArray *)dataArray searchEnabled:(BOOL)enabled;

@end
