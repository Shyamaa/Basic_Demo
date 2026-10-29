//
//  PhysicalStockVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 29/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "PhysicalStockVC.h"

@interface PhysicalStockVC()
@end

@implementation PhysicalStockVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Physical Stock";
    [self setUpNavigationButton];
}

- (void)setUpNavigationButton {
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barFilterBtn, nil];
}


- (void)filterNavigationButtonAction {
    NSArray *fruits = @[@"Item Name", @"Clarity", @"Quality", @"Stamp"];
       
       [self showPickerWithTitle:@"Select Category"
                            data:fruits
                     onSelection:^(NSString *selectedItem) {
           NSLog(@"Selected: %@", selectedItem);
           // Handle the selected item
       }];
}

@end
