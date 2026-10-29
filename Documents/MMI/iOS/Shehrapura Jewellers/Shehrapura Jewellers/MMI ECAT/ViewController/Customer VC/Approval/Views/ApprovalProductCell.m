//
//  ApprovalProductCell.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalProductCell.h"
#import "ApprovalProductItem.h"
#import "UIImageView+WebCache.h"

@interface ApprovalProductCell ()

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *wtFromLabel;
@property (nonatomic, strong) UILabel *wtToLabel;
@property (nonatomic, strong) UILabel *hoursLabel;
@property (nonatomic, strong) UIButton *checkBoxButton;

@end

@implementation ApprovalProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setup UI

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = NO;

    // 🔲 Card container view
    UIView *cardView = [[UIView alloc] init];
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    cardView.backgroundColor = UIColor.whiteColor;
    cardView.layer.cornerRadius = 10;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowRadius = 4;
    cardView.layer.borderWidth = 1;
    cardView.layer.borderColor = UIColor.blackColor.CGColor;
    cardView.layer.masksToBounds = YES;
    [self.contentView addSubview:cardView];

    // 📷 Image
    _userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_Default"]];
    _userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.borderWidth = 1;
    _userImageView.layer.borderColor = UIColor.blackColor.CGColor;
    _userImageView.clipsToBounds = YES;

    // 🏷 Labels
    _nameLabel = [self createLabelWithFontSize:15 bold:YES];
    _wtFromLabel = [self createLabelWithFontSize:15 bold:NO];
    _wtToLabel = [self createLabelWithFontSize:15 bold:NO];
    _hoursLabel = [self createLabelWithFontSize:15 bold:NO];

    // ☑️ Checkbox
    _checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBoxButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
    [_checkBoxButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateSelected];
    _checkBoxButton.translatesAutoresizingMaskIntoConstraints = NO;
    _checkBoxButton.tintColor = UIColor.blackColor;
    [_checkBoxButton addTarget:self action:@selector(checkboxTapped) forControlEvents:UIControlEventTouchUpInside];

    // 📐 Info stack
    UIStackView *infoStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        _nameLabel, _wtFromLabel, _wtToLabel, _hoursLabel
    ]];
    infoStack.axis = UILayoutConstraintAxisHorizontal;
    infoStack.spacing = 10;
    infoStack.distribution = UIStackViewDistributionFillEqually;
    infoStack.translatesAutoresizingMaskIntoConstraints = NO;

    // 🧱 Main horizontal stack
    UIStackView *mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        _userImageView, infoStack, _checkBoxButton
    ]];
    mainStack.axis = UILayoutConstraintAxisHorizontal;
    mainStack.spacing = 10;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;

    [cardView addSubview:mainStack];

    // 🧷 Constraints

    [NSLayoutConstraint activateConstraints:@[
        // Card container margins
        [cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12],
        [cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-12],
        [cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],

        // Main stack inside card
        [mainStack.topAnchor constraintEqualToAnchor:cardView.topAnchor constant:10],
        [mainStack.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:10],
        [mainStack.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-10],
        [mainStack.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-10],

        // Image size
        [_userImageView.widthAnchor constraintEqualToConstant:60],
        [_userImageView.heightAnchor constraintEqualToConstant:60],

        // Checkbox size
        [_checkBoxButton.widthAnchor constraintEqualToConstant:30],
        [_checkBoxButton.heightAnchor constraintEqualToConstant:30]
    ]];
}


- (UILabel *)createLabelWithFontSize:(CGFloat)size bold:(BOOL)isBold {
    UILabel *label = [[UILabel alloc] init];
    label.font = isBold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    label.textColor = UIColor.labelColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.7;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

#pragma mark - Configure Cell

- (void)configureWithItem:(ApprovalProductItem *)item {
    // 🔽 Load image from URL with fallback
    NSURL *imageURL = [NSURL URLWithString:item.imgUrl];
    [_userImageView sd_setImageWithURL:imageURL
                      placeholderImage:[UIImage imageNamed:@"banner_Default"]
                               options:SDWebImageRefreshCached];

    // 🏷 Labels
    _nameLabel.text = item.tgno ?: @"--";
    _wtFromLabel.text = item.wt ?: @"0";
    _wtToLabel.text = item.gwt ?: @"0";
    _hoursLabel.text = item.salemrp ?: @"0.00";

    // ☑️ Checkbox
    _checkBoxButton.selected = item.selected;
}


- (void)checkboxTapped {
    _checkBoxButton.selected = !_checkBoxButton.selected;
    if (self.selectionChanged) {
        self.selectionChanged(_checkBoxButton.selected);
    }
}

@end
