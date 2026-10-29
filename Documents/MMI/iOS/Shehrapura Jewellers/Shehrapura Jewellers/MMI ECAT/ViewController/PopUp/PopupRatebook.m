//
//  PopupRatebook.m
//  Jewel Desk
//
//  Created by App Dev on 15/06/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "PopupRatebook.h"

@interface PopupRatebook ()

@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;

@end

@implementation PopupRatebook
@synthesize str_todayrate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    CGFloat popupWidth = self.view.frame.size.width-30;
    CGFloat popupHeight = 300;

    // Calculate the center of the screen
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat centerX = screenWidth / 2;
    CGFloat centerY = screenHeight / 2;
   
    // Create a UIView to act as the popup
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(centerX - popupWidth / 2, centerY - popupHeight / 2, popupWidth, popupHeight)];
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.layer.cornerRadius = 8.0; // Optional: add rounded corners to the popup

    // Add content to the popup
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, popupWidth, 30)];
    titleLabel.text = @"";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:titleLabel];
    
//    UILabel *cross = [[UILabel alloc] initWithFrame:CGRectMake(popupWidth-50, 20, 30, 30)];
//    cross.text = @"X";
//    cross.textAlignment = NSTextAlignmentRight;
//    cross.textColor = [UIColor colorWithRed:255.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0];
//    [popupView addSubview:cross];
    
  
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake(popupWidth - 40, 10, 30, 30);
    [crossButton setTitle:@"X" forState:UIControlStateNormal];
    [crossButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(crosslButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    crossButton.layer.cornerRadius = crossButton.frame.size.width / 2;
    crossButton.layer.borderColor = [UIColor redColor].CGColor;
    crossButton.layer.borderWidth = 1.0;
    [crossButton setBackgroundColor:[UIColor clearColor]];
    crossButton.userInteractionEnabled = YES;
    [popupView addSubview:crossButton];
    
//    UIButton * btn_acname = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn_acname.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 20, popupWidth - 40, 30);
//    [btn_acname addTarget:self action:@selector(btn_acname) forControlEvents:UIControlEventTouchUpInside];
//    btn_acname.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
//    [btn_acname setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn_acname.layer.borderWidth = 1.0; // Set border width
//    btn_acname.layer.borderColor = [[UIColor blackColor] CGColor]; // Set border color
//    
//    if (str_todayrate.length == 0) {
//        [btn_acname setTitle:@"Search A/C Name" forState:UIControlStateNormal];
//    }else{
//        [btn_acname setTitle:str_todayrate forState:UIControlStateNormal];
//    }
//    [popupView addSubview:btn_acname];
    
    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 20, popupWidth - 40, 30)];
    _textField1.borderStyle = UITextBorderStyleRoundedRect;
    _textField1.text = str_todayrate;
    _textField1.keyboardType = UIKeyboardTypeDecimalPad; // Set keyboard type to numeric keypad
    [popupView addSubview:_textField1];

    
    _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 60, popupWidth - 40, 30)];
    _textField2.borderStyle = UITextBorderStyleRoundedRect;
    _textField2.placeholder = @"Enter Amount";
    _textField2.keyboardType = UIKeyboardTypeDecimalPad; // Set keyboard type to numeric keypad
    [popupView addSubview:_textField2];
    
    _textField3 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 100, popupWidth - 40, 30)];
    _textField3.placeholder = @"Enter Wt";
    _textField3.borderStyle = UITextBorderStyleRoundedRect;
    [popupView addSubview:_textField3];
    
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yesButton.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 160, (popupWidth - 60)/2, 30);
    [yesButton setTitle:@"Save" forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    yesButton.backgroundColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
    [yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popupView addSubview:yesButton];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake((popupWidth - 40)/2+20, CGRectGetMaxY(titleLabel.frame) + 160, (popupWidth - 60)/2, 30);
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popupView addSubview:closeButton];

    [self.view addSubview:popupView];
}

- (void)crosslButtonTapped {
    if (self.completionHandler) {
       self.completionHandler(@"",self.textField2.text, self.textField3.text,@"Cross");
   }
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cancelButtonTapped
{
    if (self.completionHandler) {
        self.completionHandler(@"",self.textField2.text, self.textField3.text,@"Delete");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped {
   
    if (self.completionHandler)
    {
        self.completionHandler(@"",self.textField2.text, self.textField3.text,@"Update");
    }
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



@end
