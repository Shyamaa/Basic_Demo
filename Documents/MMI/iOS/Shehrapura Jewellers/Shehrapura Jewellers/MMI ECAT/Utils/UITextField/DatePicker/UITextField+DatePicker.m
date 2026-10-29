//
//  UITextField+DatePicker.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "UITextField+DatePicker.h"
#import <objc/runtime.h>

@interface DatePickerHandler : NSObject

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *dateFormat;

- (instancetype)initWithTextField:(UITextField *)textField format:(NSString *)format mode:(CustomDatePickerMode)mode;
- (void)doneTapped;
- (void)cancelTapped;

@end

@implementation DatePickerHandler

- (instancetype)initWithTextField:(UITextField *)textField format:(NSString *)format mode:(CustomDatePickerMode)mode {
    if (self = [super init]) {
        _textField = textField;
        _dateFormat = format ?: @"yyyy-MM-dd";
        
        _datePicker = [[UIDatePicker alloc] init];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
//            switch (mode) {
//                case CustomDatePickerModeDate:
//                    _datePicker.dateStyle = NSDateFormatterMediumStyle;
//                    _datePicker.timeStyle = NSDateFormatterNoStyle;
//                    break;
//                case CustomDatePickerModeTime:
//                    _datePicker.dateStyle = NSDateFormatterNoStyle;
//                    _datePicker.timeStyle = NSDateFormatterShortStyle;
//                    break;
//                case CustomDatePickerModeDateAndTime:
//                    _datePicker.dateStyle = NSDateFormatterMediumStyle;
//                    _datePicker.timeStyle = NSDateFormatterShortStyle;
//                    break;
//            }
        }
        //_datePicker.datePickerMode = UIDatePickerModeDate;
        
        // Set mode
                switch (mode) {
                    case CustomDatePickerModeDate:
                        _datePicker.datePickerMode = UIDatePickerModeDate;
                        break;
                    case CustomDatePickerModeTime:
                        _datePicker.datePickerMode = UIDatePickerModeTime;
                        break;
                    case CustomDatePickerModeDateAndTime:
                        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                        break;
                }

        
        //_datePicker.maximumDate = [NSDate date];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar sizeToFit];
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(cancelTapped)];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(doneTapped)];
        
        toolbar.items = @[cancelBtn, flex, doneBtn];
        
        textField.inputView = _datePicker;
        textField.inputAccessoryView = toolbar;
    }
    return self;
}

- (void)doneTapped {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.dateFormat;
    self.textField.text = [formatter stringFromDate:self.datePicker.date];
    [self.textField resignFirstResponder];
}

- (void)cancelTapped {
    [self.textField resignFirstResponder];
}

@end

@implementation UITextField (DatePicker)

- (void)addDatePickerWithFormat:(NSString *)dateFormat pickerMode:(CustomDatePickerMode)mode {
    DatePickerHandler *handler = [[DatePickerHandler alloc] initWithTextField:self format:dateFormat mode:mode];
    objc_setAssociatedObject(self, @selector(addDatePickerWithFormat:), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

