//
//  UITextField+DatePicker.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomDatePickerMode) {
    CustomDatePickerModeDate,
    CustomDatePickerModeTime,
    CustomDatePickerModeDateAndTime
};

@interface UITextField (DatePicker)

- (void)addDatePickerWithFormat:(NSString *)dateFormat pickerMode:(CustomDatePickerMode)mode;

@end
