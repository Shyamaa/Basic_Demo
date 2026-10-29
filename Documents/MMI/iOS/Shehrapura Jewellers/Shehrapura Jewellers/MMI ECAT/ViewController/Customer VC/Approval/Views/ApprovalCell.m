//
//  ApprovalCell.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalCell.h"
#import "ApprovalItem.h"

@interface ApprovalCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *dateFromLabel;
@property (nonatomic, strong) UILabel *dateToLabel;
@property (nonatomic, strong) UILabel *hoursLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ApprovalCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Create labels
    _nameLabel = [self createLabelWithFontSize:17 bold:YES];
    _mobileLabel = [self createLabelWithFontSize:15 bold:NO];
    _dateFromLabel = [self createLabelWithFontSize:15 bold:NO];
    _dateToLabel = [self createLabelWithFontSize:15 bold:NO];
    _hoursLabel = [self createLabelWithFontSize:15 bold:NO];
    _statusLabel = [self createLabelWithFontSize:15 bold:NO];

    // Stack to arrange all labels vertically
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        _nameLabel, _mobileLabel, _dateFromLabel, _dateToLabel, _hoursLabel, _statusLabel
    ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 4;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    // Container view for border and background
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = UIColor.whiteColor;
    container.layer.cornerRadius = 8;
    container.layer.borderWidth = 1;
    container.layer.borderColor = UIColor.lightGrayColor.CGColor;
    container.clipsToBounds = YES;

    [container addSubview:stack];
    [self.contentView addSubview:container];

    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [container.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [container.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [container.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [container.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],

        [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:10],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:10],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-10],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-10],
    ]];
}

- (UILabel *)createLabelWithFontSize:(CGFloat)size bold:(BOOL)isBold {
    UILabel *label = [[UILabel alloc] init];
    label.font = isBold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    label.numberOfLines = 1;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

#pragma mark - Configure

- (void)configureWithItem:(ApprovalItem *)item {
    _nameLabel.text = [NSString stringWithFormat:@"Name : %@", item.username];
    _mobileLabel.text = [NSString stringWithFormat:@"Mobile : %@", item.mobile];
    _dateFromLabel.text = [NSString stringWithFormat:@"Date from : %@", item.dateFrom];
    _dateToLabel.text = [NSString stringWithFormat:@"Date to : %@", item.dateTo];
    _hoursLabel.text = [NSString stringWithFormat:@"Hours : %@", item.hours];

    // Prepare attributed string for status
    NSString *statusPrefix = @"Status : ";
    NSString *statusValue = item.status ?: @"";
    NSString *fullText = [NSString stringWithFormat:@"%@%@", statusPrefix, statusValue];

    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:fullText];

    // Default color (black or system label color)
    UIColor *defaultColor = UIColor.labelColor;
    [attrText addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(0, fullText.length)];

    // Status color
    UIColor *statusColor;
    if ([statusValue.lowercaseString isEqualToString:@"approved"]) {
        statusColor = UIColor.systemGreenColor;
    } else if ([statusValue.lowercaseString isEqualToString:@"pending"]) {
        statusColor = UIColor.systemRedColor;
    } else {
        statusColor = defaultColor;
    }

    // Apply color only to status value
    NSRange statusRange = NSMakeRange(statusPrefix.length, statusValue.length);
    [attrText addAttribute:NSForegroundColorAttributeName value:statusColor range:statusRange];

    _statusLabel.attributedText = attrText;
}

@end
