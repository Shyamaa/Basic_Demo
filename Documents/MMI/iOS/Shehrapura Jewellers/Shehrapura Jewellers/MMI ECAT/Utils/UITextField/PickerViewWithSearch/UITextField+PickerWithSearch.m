//
//  UITextField+PickerWithSearch.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "UITextField+PickerWithSearch.h"
#import <objc/runtime.h>

@interface PickerWithSearchHandler : NSObject <UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *filteredDataArray;  // Data filtered for search
@property (nonatomic, assign) BOOL searchEnabled;
@property (nonatomic, strong) UIPickerView *pickerView;

- (instancetype)initWithTextField:(UITextField *)textField data:(NSArray *)data searchEnabled:(BOOL)enabled;
- (void)doneTapped;
- (void)cancelTapped;

@end

@implementation PickerWithSearchHandler

- (instancetype)initWithTextField:(UITextField *)textField data:(NSArray *)data searchEnabled:(BOOL)enabled {
    if (self = [super init]) {
        _textField = textField;
        _dataArray = data;
        _searchEnabled = enabled;
        _filteredDataArray = data;
        
        // Create UIPickerView
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        // Create a toolbar with Cancel and Done buttons
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
        
        textField.inputView = _pickerView;
        textField.inputAccessoryView = toolbar;
        
        // If search is enabled, add a search bar
        if (enabled) {
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            searchBar.placeholder = @"Search...";
            searchBar.delegate = self;
            searchBar.frame = CGRectMake(0, 0, self.textField.frame.size.width, 44);
            self.textField.inputAccessoryView = searchBar;
        }
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.filteredDataArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.filteredDataArray[row];
}

- (void)doneTapped {
    // Fix: Use the correct pickerView reference
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    self.textField.text = self.filteredDataArray[selectedRow];
    [self.textField resignFirstResponder];
}

- (void)cancelTapped {
    [self.textField resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredDataArray = self.dataArray;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
        self.filteredDataArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    }
    
    // Reload the picker view with filtered data
    [self.pickerView reloadAllComponents];
}

@end

@implementation UITextField (PickerWithSearch)

- (void)addPickerWithData:(NSArray *)dataArray searchEnabled:(BOOL)enabled {
    PickerWithSearchHandler *handler = [[PickerWithSearchHandler alloc] initWithTextField:self data:dataArray searchEnabled:enabled];
    objc_setAssociatedObject(self, @selector(addPickerWithData:searchEnabled:), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
