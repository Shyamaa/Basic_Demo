//
//  PopupBankdetail.m
//  Jewel Desk
//
//  Created by App Dev on 20/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "PopupBankdetail.h"

@interface PopupBankdetail ()

@end

@implementation PopupBankdetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPView];
    
    if (self.dicBankData) {
        [self dataParsing];
    }
}

-(void) setUPView{
    // Dimmed background
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // Dismiss popup when tapped outside
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)];
    tapOutside.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOutside];
    
    // Container View for Popup
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 12.0;
    containerView.layer.masksToBounds = YES;
    containerView.userInteractionEnabled = YES;
    [self.view addSubview:containerView];
    
    // Optional Shadow
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOpacity = 0.2;
    containerView.layer.shadowOffset = CGSizeMake(0, 2);
    containerView.layer.shadowRadius = 6;
    
    // Layout for container
    [NSLayoutConstraint activateConstraints:@[
        [containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [containerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.9],
        [containerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.8]
    ]];
    
    // ScrollView inside container
    self.textFields = [NSMutableArray array];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:scrollView];
    
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
    ]];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor]
    ]];
    
    NSLayoutConstraint *contentHeightConstraint = [contentView.heightAnchor constraintEqualToAnchor:scrollView.heightAnchor multiplier:1.0];
    contentHeightConstraint.priority = UILayoutPriorityDefaultLow;
    contentHeightConstraint.active = YES;
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.spacing = 1.0;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor]
    ]];
    
    // Add form fields
    [self addTitleLabelToStackView:stackView withText:@"  Update Bank Detail 1"];
    [self addTextFieldRowToStackView:stackView withLabel:@"A/C Name" placeholder:@"Enter Account Name"];
    [self addTextFieldRowToStackView:stackView withLabel:@"A/C Number" placeholder:@"Enter Account Number"];
    [self addTextFieldRowToStackView:stackView withLabel:@"Bank Name" placeholder:@"Enter Bank Name"];
    [self addTextFieldRowToStackView:stackView withLabel:@"Branch" placeholder:@"Enter Branch"];
    [self addTextFieldRowToStackView:stackView withLabel:@"IFSC" placeholder:@"Enter IFSC"];
    [self addTextFieldRowToStackView:stackView withLabel:@"GSTIN" placeholder:@"Enter GSTIN"];
    [self addTextFieldRowToStackView:stackView withLabel:@"UPI" placeholder:@"Enter UPI"];
    [self addTitleLabelToStackView:stackView withText:@"  Update Bank Detail 2"];
    [self addTextFieldRowToStackView:stackView withLabel:@"A/C Name" placeholder:@"Enter Account Name"];
    [self addTextFieldRowToStackView:stackView withLabel:@"A/C Number" placeholder:@"Enter Account Number"];
    [self addTextFieldRowToStackView:stackView withLabel:@"Bank Name" placeholder:@"Enter Bank Name"];
    [self addTextFieldRowToStackView:stackView withLabel:@"Branch" placeholder:@"Enter Branch"];
    [self addTextFieldRowToStackView:stackView withLabel:@"IFSC" placeholder:@"Enter IFSC"];
    
    [self addButtonRowToStackView:stackView];
}

- (void)addTitleLabelToStackView:(UIStackView *)stackView withText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textColor = [UIColor blackColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label.heightAnchor constraintEqualToConstant:50.0].active = YES;
    [stackView addArrangedSubview:label];
}

- (void)addTextFieldRowToStackView:(UIStackView *)stackView withLabel:(NSString *)labelText placeholder:(NSString *)placeholder {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.distribution = UIStackViewDistributionFill;
    row.spacing = 8.0;
    row.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorNamed:@"border_Color"];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [row addArrangedSubview:label];
    
    PaddedTextField *textField = [[PaddedTextField alloc] init];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [row addArrangedSubview:textField];
    [self.textFields addObject:textField];
    
    [stackView addArrangedSubview:row];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.widthAnchor constraintEqualToConstant:120.0]
    ]];
}

- (void)addButtonRowToStackView:(UIStackView *)stackView {
    UIStackView *buttonRow = [[UIStackView alloc] init];
    buttonRow.axis = UILayoutConstraintAxisHorizontal;
    buttonRow.distribution = UIStackViewDistributionFillEqually;
    buttonRow.spacing = 5.0;
    buttonRow.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [buttonRow addArrangedSubview:cancelButton];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [okButton setTitle:@"Save" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    okButton.translatesAutoresizingMaskIntoConstraints = NO;
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [okButton addTarget:self action:@selector(SaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [okButton.heightAnchor constraintEqualToConstant:50.0].active = YES;
    [buttonRow addArrangedSubview:okButton];
    
    [stackView addArrangedSubview:buttonRow];
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)SaveBtn {
    NSString *acname = @"";
    NSString *acnumber = @"";
    NSString *bankname = @"";
    NSString *branch = @"";
    NSString *ifsc = @"";
    NSString *gstin = @"";
    NSString *upi = @"";
    NSString *acname2 = @"";
    NSString *acnumber2 = @"";
    NSString *bankname2 = @"";
    NSString *branch2 = @"";
    NSString *ifsc2 = @"";
    
    int i = 0;
    for (PaddedTextField *textField in self.textFields) {
        switch (i) {
            case 0: acname = textField.text; break;
            case 1: acnumber = textField.text; break;
            case 2: bankname = textField.text; break;
            case 3: branch = textField.text; break;
            case 4: ifsc = textField.text; break;
            case 5: gstin = textField.text; break;
            case 6: upi = textField.text; break;
            case 7: acname2 = textField.text; break;
            case 8: acnumber2 = textField.text; break;
            case 9: bankname2 = textField.text; break;
            case 10: branch2 = textField.text; break;
            case 11: ifsc2 = textField.text; break;
        }
        i++;
    }
    
    if (self.completionHandler) {
        self.completionHandler(acname, acnumber, bankname, branch, ifsc, gstin, upi, acname2, acnumber2, bankname2, branch2, ifsc2);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) dataParsing {
    NSString *acname = [self.dicBankData valueForKey:@"accname"];
    NSString *acnumber = [self.dicBankData valueForKey:@"accno"];
    NSString *bankname = [self.dicBankData valueForKey:@"bankname"];
    NSString *branch = [self.dicBankData valueForKey:@"branch"];
    NSString *ifsc = [self.dicBankData valueForKey:@"ifsc"];
    NSString *gstin = [self.dicBankData valueForKey:@"gstin"];
    NSString *upi = [self.dicBankData valueForKey:@"upi"];
    NSString *acname2 =[self.dicBankData valueForKey:@"accname2"];
    NSString *acnumber2 = [self.dicBankData valueForKey:@"accno2"];
    NSString *bankname2 =[self.dicBankData valueForKey:@"bankname2"];
    NSString *branch2 = [self.dicBankData valueForKey:@"branch2"];
    NSString *ifsc2 = [self.dicBankData valueForKey:@"ifsc2"];
    
    int i = 0;
    for (PaddedTextField *textField in self.textFields) {
        switch (i) {
            case 0: textField.text = acname; break;
            case 1: textField.text = acnumber; break;
            case 2: textField.text = bankname; break;
            case 3: textField.text = branch; break;
            case 4: textField.text = ifsc; break;
            case 5: textField.text = gstin; break;
            case 6: textField.text = upi; break;
            case 7: textField.text = acname2; break;
            case 8: textField.text = acnumber2; break;
            case 9: textField.text = bankname2; break;
            case 10:textField.text = branch2; break;
            case 11:textField.text = ifsc2; break;
        }
        i++;
    }
}

@end
