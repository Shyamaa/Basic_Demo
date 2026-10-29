//
//  Popuptounch.m
//  Jewel Desk
//
//  Created by App Dev on 29/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "Popuptounch.h"

@interface Popuptounch ()

@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;

@end

@implementation Popuptounch

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
      self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
       CGFloat popupWidth = self.view.frame.size.width - 30;
       CGFloat popupHeight = self.view.frame.size.height - 100;

       // Calculate the center of the screen
       CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
       CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
       CGFloat centerX = screenWidth / 2;
       CGFloat centerY = screenHeight / 2;
      
       // Create a UIView to act as the popup
       UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(centerX - popupWidth / 2, centerY - popupHeight / 2, popupWidth, popupHeight)];
       popupView.backgroundColor = [UIColor whiteColor];
       popupView.layer.cornerRadius = 8.0; // Optional: add rounded corners to the popup

       // Create and configure the UIScrollView
       UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, popupHeight)];
       [popupView addSubview:scrollView];

       CGFloat yOffset = 0;

       // Add content to the popup
       UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, popupWidth, 30)];
       titleLabel.text = @"";
       titleLabel.textAlignment = NSTextAlignmentCenter;
       [scrollView addSubview:titleLabel];
       
       UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
       crossButton.frame = CGRectMake(popupWidth - 40, 10, 30, 30);
       [crossButton setTitle:@"X" forState:UIControlStateNormal];
       [crossButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       [crossButton addTarget:self action:@selector(crossButtonTapped) forControlEvents:UIControlEventTouchUpInside];
       crossButton.layer.cornerRadius = crossButton.frame.size.width / 2;
       crossButton.layer.borderColor = [UIColor redColor].CGColor;
       crossButton.layer.borderWidth = 1.0;
       [crossButton setBackgroundColor:[UIColor clearColor]];
       crossButton.userInteractionEnabled = YES;
       [scrollView addSubview:crossButton];
       
       yOffset = CGRectGetMaxY(titleLabel.frame) + 10;

       // Function to create and add a container view to the scroll view
       void (^createContainerView)(UIView *, NSString *, NSString *, CGFloat) = ^(UIView *containerView, NSString *label1Text, NSString *label2Text, CGFloat yOffset) {
           
           containerView.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
           containerView.backgroundColor = [UIColor lightGrayColor];
           [scrollView addSubview:containerView];
           
           CGFloat elementWidth = (containerView.frame.size.width - 30) / 4;
           
           UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth, 30)];
           label1.text = label1Text;
           label1.textAlignment = NSTextAlignmentCenter;
           [containerView addSubview:label1];

           UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth, 0, elementWidth, 30)];
           textField1.borderStyle = UITextBorderStyleRoundedRect;
           textField1.placeholder = @"0.00";
           [containerView addSubview:textField1];

           UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30 + 2 * elementWidth, 0, elementWidth - 10, 30)];
           label2.text = label2Text;
           label2.textAlignment = NSTextAlignmentCenter;
           [containerView addSubview:label2];

           UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake((40 + 3 * elementWidth) - 5, 0, elementWidth - 5, 30)];
           textField2.borderStyle = UITextBorderStyleRoundedRect;
           textField2.placeholder = @"0.00";
           [containerView addSubview:textField2];
       };

       // Create and add container views
       createContainerView([[UIView alloc] init], @"Polish %", @"P.Wt", yOffset);
       yOffset += 40;
       createContainerView([[UIView alloc] init], @"Rate", @"Stamp", yOffset);
       yOffset += 40;
       createContainerView([[UIView alloc] init], @"Lbr", @"Wt", yOffset);
       yOffset += 40;

       // Additional containers
       UIView *containerView4 = [[UIView alloc] init];
       containerView4.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
       containerView4.backgroundColor = [UIColor lightGrayColor];
       [scrollView addSubview:containerView4];

       CGFloat elementWidth4 = (containerView4.frame.size.width - 30) / 2;
       UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth4, 30)];
       label4.text = @"Dia/Stone/Oth Amt";
       label4.textAlignment = NSTextAlignmentCenter;
       [containerView4 addSubview:label4];

       UITextField *textField4 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth4, 0, elementWidth4 + 10, 30)];
       textField4.borderStyle = UITextBorderStyleRoundedRect;
       textField4.placeholder = @"0000.00";
       [containerView4 addSubview:textField4];
       yOffset += 40;

       UIView *containerView5 = [[UIView alloc] init];
       containerView5.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
       containerView5.backgroundColor = [UIColor lightGrayColor];
       [scrollView addSubview:containerView5];

       CGFloat elementWidth5 = (containerView5.frame.size.width - 30) / 2;
       UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth5, 30)];
       label5.text = @"Total";
       label5.textAlignment = NSTextAlignmentCenter;
       [containerView5 addSubview:label5];

       UITextField *textField5 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth5, 0, elementWidth5 + 10, 30)];
       textField5.borderStyle = UITextBorderStyleRoundedRect;
       textField5.placeholder = @"0000.00";
       [containerView5 addSubview:textField5];
       yOffset += 40;
    
    
       UIView *containerView6 = [[UIView alloc] init];
       containerView6.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
       containerView6.backgroundColor = [UIColor lightGrayColor];
       [scrollView addSubview:containerView6];

       CGFloat elementWidth6 = (containerView6.frame.size.width - 30) / 3;
       UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth6, 30)];
       label6.text = @"Dis 1";
       label6.textAlignment = NSTextAlignmentCenter;
       [containerView6 addSubview:label6];

       UITextField *textField6 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth6, 0, elementWidth6 + 10, 30)];
       textField6.borderStyle = UITextBorderStyleRoundedRect;
       textField6.placeholder = @"000.00";
       [containerView6 addSubview:textField6];
    
        UITextField *textField7 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth6+elementWidth6, 0, elementWidth6 + 10, 30)];
        textField7.borderStyle = UITextBorderStyleRoundedRect;
        textField7.placeholder = @"000.00";
        [containerView6 addSubview:textField7];
        yOffset += 40;
    
    
        UIView *containerView7 = [[UIView alloc] init];
        containerView7.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
        containerView7.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:containerView7];
        CGFloat elementWidth7 = (containerView7.frame.size.width - 30) / 3;
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth7, 30)];
        label7.text = @"Dis 2";
        label7.textAlignment = NSTextAlignmentCenter;
        [containerView7 addSubview:label7];

        UITextField *textField_71 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth7, 0, elementWidth7 + 10, 30)];
        textField_71.borderStyle = UITextBorderStyleRoundedRect;
        textField_71.placeholder = @"000.00";
        [containerView7 addSubview:textField_71];

        UITextField *textField_72 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth7+elementWidth7, 0, elementWidth7 + 10, 30)];
        textField_72.borderStyle = UITextBorderStyleRoundedRect;
        textField_72.placeholder = @"000.00";
        [containerView7 addSubview:textField_72];
        yOffset += 40;
    
    
        UIView *containerView8 = [[UIView alloc] init];
        containerView8.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
        containerView8.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:containerView8];

        CGFloat elementWidth8 = (containerView8.frame.size.width - 30) / 2;
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth8, 30)];
        label8.text = @"Total";
        label8.textAlignment = NSTextAlignmentCenter;
        [containerView8 addSubview:label8];

        UITextField *textField_82 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth8, 0, elementWidth8 + 10, 30)];
        textField_82.borderStyle = UITextBorderStyleRoundedRect;
        textField_82.placeholder = @"0000.00";
        [containerView8 addSubview:textField_82];
        yOffset += 40;
    
    
        UIView *containerView9 = [[UIView alloc] init];
        containerView9.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
        containerView9.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:containerView9];
            
        CGFloat elementWidth9 = (containerView9.frame.size.width - 30) / 3;

        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth9, 30)];
        label9.text = @"With GST";
        label9.textAlignment = NSTextAlignmentCenter;
        [containerView9 addSubview:label9];

        UITextField *textField_91 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth9, 0, elementWidth9 + 10, 30)];
        textField_91.borderStyle = UITextBorderStyleRoundedRect;
        textField_91.placeholder = @"000.00";
        [containerView9 addSubview:textField_91];

        UITextField *textField_92 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth9+elementWidth9, 0, elementWidth9 + 10, 30)];
        textField_92.borderStyle = UITextBorderStyleRoundedRect;
        textField_92.placeholder = @"000.00";
        [containerView9 addSubview:textField_92];
        yOffset += 40;
    
        UIView *containerView10 = [[UIView alloc] init];
        containerView10.frame = CGRectMake(5, yOffset, popupView.frame.size.width - 10, 30);
        containerView10.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:containerView10];

        CGFloat elementWidth10 = (containerView10.frame.size.width - 30) / 2;
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, elementWidth10, 30)];
        label10.text = @"Remark";
        label10.textAlignment = NSTextAlignmentCenter;
        [containerView10 addSubview:label10];

        UITextField *textField_102 = [[UITextField alloc] initWithFrame:CGRectMake(20 + elementWidth10, 0, elementWidth10 + 10, 30)];
        textField_102.borderStyle = UITextBorderStyleRoundedRect;
        textField_102.placeholder = @"0000.00";
        [containerView10 addSubview:textField_102];
        yOffset += 40;

    
    
       // Add Save and Cancel buttons
       UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
       yesButton.frame = CGRectMake(20, yOffset + 10, (popupWidth - 60) / 2, 30);
       [yesButton setTitle:@"Save" forState:UIControlStateNormal];
       [yesButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
       yesButton.backgroundColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
       [yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       [scrollView addSubview:yesButton];
       
    
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.frame = CGRectMake(CGRectGetMaxX(yesButton.frame) + 20, yOffset + 10, (popupWidth - 60) / 2, 30);
        [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        closeButton.backgroundColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scrollView addSubview:closeButton];
    

        scrollView.contentSize = CGSizeMake(popupWidth, CGRectGetMaxY(closeButton.frame) + 20);

        [self.view addSubview:popupView];
}

- (void)crossButtonTapped {
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
