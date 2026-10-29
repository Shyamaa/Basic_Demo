//
//  BaseViewController.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyboardHandler.h"
#import "ScreenCaptureProtector.h"
#import "HomeVC.h"
#import "SceneDelegate.h"

@interface BaseViewController()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) KeyboardHandler *keyboardHandler;
@property (strong, nonatomic) UIView *blackOverlayView;

@property (nonatomic, strong) NSArray<NSString *> *pickerData;
@property (nonatomic, strong) UIView *pickerContainer;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) void (^selectionHandler)(NSString *);
@end

@implementation BaseViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupModernNavigationBar];
    [self setUpKeyboardHandler];
    [[ScreenCaptureProtector sharedProtector] startProtectionInView:self.view];
    
    // Log device information for debugging
    NSLog(@"📱 Device: %@", [[UIDevice currentDevice] model]);
    NSLog(@"📐 Screen Size: %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Ensure navigation bar styling is applied
    [self ensureNavigationBarStyling];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc {
    [[ScreenCaptureProtector sharedProtector] stopProtection];
    [self.keyboardHandler stopListening];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.blackOverlayView removeFromSuperview];
}

#pragma mark - Modern Setup Methods

- (void)setupModernNavigationBar {
    // Use device-specific styling
    CGFloat cornerRadius = [self layoutConstantForKey:@"cornerRadius"];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium]
        };
        
        // Set button appearance for left and right items
        appearance.buttonAppearance.normal.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        };
        
        // Set back button appearance - show only arrow, no text
        appearance.backButtonAppearance.normal.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor clearColor], // Hide text
            NSFontAttributeName: [UIFont systemFontOfSize:0.0] // Zero font size
        };
        
        // Set done button appearance
        appearance.doneButtonAppearance.normal.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        };
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.compactAppearance = appearance;
        
        // Set tint color for the entire navigation bar
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        // Fallback for older iOS versions
        [[UINavigationBar appearance] setBarTintColor: [UIColor colorNamed:@"appRed_Color"]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium]
        }];
        
        // Set button appearance for older iOS
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateNormal];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateHighlighted];
        
        // Hide back button text for older iOS
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    }
    
    // Ensure current navigation bar has white tint
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

/**
 * Set navigation title on the left side
 * @param title The title to display
 */
- (void)setNavigationTitleOnLeft:(NSString *)title {
    if (!title || title.length == 0) {
        return;
    }
    
    // Create a custom title view
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    // Calculate the width needed for the title
    CGSize titleSize = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)];
    titleLabel.frame = CGRectMake(0, 0, titleSize.width, 44);
    
    // Create a container view to position the title on the left
    UIView *titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width + 20, 44)];
    titleLabel.center = CGPointMake(titleSize.width/2 + 10, 22);
    [titleContainer addSubview:titleLabel];
    
    // Set the custom title view
    self.navigationItem.titleView = titleContainer;
}

/**
 * Set navigation title on the left side with custom styling
 * @param title The title to display
 * @param font The font to use
 * @param color The text color
 */
- (void)setNavigationTitleOnLeft:(NSString *)title
                            font:(UIFont *)font
                           color:(UIColor *)color {
    if (!title || title.length == 0) {
        return;
    }
    
    // Create a custom title view
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = color ?: [UIColor whiteColor];
    titleLabel.font = font ?: [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    // Calculate the width needed for the title
    CGSize titleSize = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)];
    titleLabel.frame = CGRectMake(0, 0, titleSize.width, 44);
    
    // Create a container view to position the title on the left
    UIView *titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width + 20, 44)];
    titleLabel.center = CGPointMake(titleSize.width/2 + 10, 22);
    [titleContainer addSubview:titleLabel];
    
    // Set the custom title view
    self.navigationItem.titleView = titleContainer;
}

/**
 * Set navigation title on the left side with subtitle
 * @param title The main title
 * @param subtitle The subtitle
 */
- (void)setNavigationTitleOnLeft:(NSString *)title
                        subtitle:(NSString *)subtitle {
    if (!title || title.length == 0) {
        return;
    }
    
    // Create a stack view for title and subtitle
    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.alignment = UIStackViewAlignmentLeading;
    titleStack.spacing = 2;
    
    // Main title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [titleStack addArrangedSubview:titleLabel];
    
    // Subtitle label (if provided)
    if (subtitle && subtitle.length > 0) {
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = subtitle;
        subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        subtitleLabel.font = [UIFont systemFontOfSize:12.0];
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        
        [titleStack addArrangedSubview:subtitleLabel];
    }
    
    // Calculate the size needed
    [titleStack sizeToFit];
    titleStack.frame = CGRectMake(0, 0, titleStack.frame.size.width + 20, 44);
    
    // Center the stack view
    titleStack.center = CGPointMake(titleStack.frame.size.width/2, 22);
    
    // Set the custom title view
    self.navigationItem.titleView = titleStack;
}

/**
 * Set navigation title on the left side with custom image and text
 * @param title The title text
 * @param imageName The image name to show before the title
 */
- (void)setNavigationTitleOnLeft:(NSString *)title
                       withImage:(NSString *)imageName {
    if (!title || title.length == 0) {
        return;
    }
    
    // Create a horizontal stack view
    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisHorizontal;
    titleStack.alignment = UIStackViewAlignmentCenter;
    titleStack.spacing = 8;
    
    // Image view (if image provided)
    if (imageName && imageName.length > 0) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 24, 24);
        imageView.tintColor = [UIColor whiteColor];
        
        [titleStack addArrangedSubview:imageView];
    }
    
    // Title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [titleStack addArrangedSubview:titleLabel];
    
    // Calculate the size needed
    [titleStack sizeToFit];
    titleStack.frame = CGRectMake(0, 0, titleStack.frame.size.width + 20, 44);
    
    // Center the stack view
    titleStack.center = CGPointMake(titleStack.frame.size.width/2, 22);
    
    // Set the custom title view
    self.navigationItem.titleView = titleStack;
}

/**
 * Reset navigation title to center (default behavior)
 */
- (void)resetNavigationTitleToCenter {
    self.navigationItem.titleView = nil;
    self.navigationItem.title = self.title;
}

/**
 * Ensure navigation bar items are properly styled
 * Call this method if you need to force update the styling
 */
- (void)ensureNavigationBarStyling {
    // Ensure tint color is white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Style individual bar button items if needed
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
        [item setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateHighlighted];
    }
    
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        [item setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
        } forState:UIControlStateHighlighted];
    }
    
    // Style back button if it exists - show only arrow
    if (self.navigationItem.backBarButtonItem) {
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor clearColor], // Hide text
            NSFontAttributeName: [UIFont systemFontOfSize:0.0] // Zero font size
        } forState:UIControlStateNormal];
    }
    
    // Ensure back button shows only arrow
    [self ensureBackButtonArrowOnly];
}

/**
 * Ensure back button shows only the arrow without text
 */
- (void)ensureBackButtonArrowOnly {
    // Method 1: Set back button title to empty string
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    // Method 2: For iOS 13+ use appearance
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = self.navigationController.navigationBar.standardAppearance;
        if (appearance) {
            appearance.backButtonAppearance.normal.titleTextAttributes = @{
                NSForegroundColorAttributeName: [UIColor clearColor],
                NSFontAttributeName: [UIFont systemFontOfSize:0.0]
            };
            self.navigationController.navigationBar.standardAppearance = appearance;
        }
    }
    
    // Method 3: For older iOS versions
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}
/**
 * Set navigation title with custom alignment
 * @param title The title text
 * @param alignment The text alignment (Left, Center, Right)
 */
- (void)setNavigationTitle:(NSString *)title
                 alignment:(NSTextAlignment)alignment {
    if (!title || title.length == 0) {
        return;
    }
    
    // Create a custom title view
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[self layoutConstantForKey:@"fontSize"] weight:UIFontWeightMedium];
    titleLabel.textAlignment = alignment;
    
    // Calculate the width needed for the title
    CGSize titleSize = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)];
    titleLabel.frame = CGRectMake(0, 0, titleSize.width, 44);
    
    // Create a container view
    UIView *titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width + 20, 44)];
    
    // Position the label based on alignment
    CGFloat xPosition;
    switch (alignment) {
        case NSTextAlignmentLeft:
            xPosition = 10;
            break;
        case NSTextAlignmentRight:
            xPosition = titleContainer.frame.size.width - titleSize.width - 10;
            break;
        default: // Center
            xPosition = (titleContainer.frame.size.width - titleSize.width) / 2;
            break;
    }
    
    titleLabel.frame = CGRectMake(xPosition, 0, titleSize.width, 44);
    [titleContainer addSubview:titleLabel];
    
    // Set the custom title view
    self.navigationItem.titleView = titleContainer;
}

- (void)setupModernTableView:(UITableView *)tableView {
    tableView.estimatedRowHeight = [self layoutConstantForKey:@"cellHeight"];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsMake(0, [self layoutConstantForKey:@"margin"], 0, [self layoutConstantForKey:@"margin"]);
    
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)setupModernCollectionView:(UICollectionView *)collectionView {
    collectionView.backgroundColor = [UIColor systemBackgroundColor];
    
    if (@available(iOS 13.0, *)) {
        collectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
}

#pragma mark - Modern Utilities

- (void)generateHapticFeedback:(UIImpactFeedbackStyle)style {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
        [generator prepare];
        [generator impactOccurred];
    }
}

- (CGFloat)layoutConstantForKey:(NSString *)key {
    // Device-specific layout constants (temporary implementation)
    NSDictionary *constants = @{
        @"cellHeight": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 80.0 : 60.0),
        @"buttonHeight": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 50.0 : 44.0),
        @"textFieldHeight": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 50.0 : 40.0),
        @"margin": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 20.0 : 16.0),
        @"padding": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 16.0 : 12.0),
        @"cornerRadius": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 12.0 : 8.0),
        @"fontSize": @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 18.0 : 16.0)
    };
    
    NSNumber *value = constants[key];
    return value ? value.floatValue : 0.0;
}

- (void)showLoading:(NSString *)message {
    if (message) {
        [[BusyIndicator sharedInstance] startIndicator];
        // You could enhance BusyIndicator to show custom messages
    } else {
        [[BusyIndicator sharedInstance] startIndicator];
    }
}

- (void)hideLoading {
    [[BusyIndicator sharedInstance] stopIndicator];
}

- (void)handleAPIError:(NSError *)error {
    // Temporary error handling until ErrorHandler is added
    NSString *title = @"Error";
    NSString *message = error.localizedDescription;
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        title = @"Network Error";
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                message = @"No internet connection. Please check your network settings and try again.";
                break;
            case NSURLErrorTimedOut:
                message = @"Request timed out. Please check your internet connection and try again.";
                break;
            default:
                message = @"A network error occurred. Please try again.";
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (BOOL)validateFormFields:(NSDictionary<NSString *, id> *)fields {
    // Temporary validation until ValidationUtils is added
    for (NSString *fieldName in fields.allKeys) {
        id value = fields[fieldName];
        if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length == 0) {
            [self showValidationError:[NSString stringWithFormat:@"%@ is required", fieldName]];
            return NO;
        }
    }
    return YES;
}

- (void)showValidationError:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Validation Error"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - Screenshot Detection

- (void)setupScreenshotDetection {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectScreenCapture)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
}

- (void)screenshotDetected {
    NSLog(@"📸 Screenshot detected!");
    
    // Generate haptic feedback
    [self generateHapticFeedback:UIImpactFeedbackStyleHeavy];
    
    // Delay to ensure screenshot is captured first
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self flashBlackScreenWithCompletion:^{
            [self showScreenshotAlert];
        }];
    });
}

- (void)flashBlackScreenWithCompletion:(void (^)(void))completion {
    UIWindow *window = [self getActiveWindow];
    if (!window) {
        if (completion) completion();
        return;
    }
    
    // Create overlay if needed
    if (!self.blackOverlayView) {
        self.blackOverlayView = [[UIView alloc] initWithFrame:window.bounds];
        self.blackOverlayView.backgroundColor = [UIColor blackColor];
        self.blackOverlayView.alpha = 0;
        self.blackOverlayView.userInteractionEnabled = NO;
        [window addSubview:self.blackOverlayView];
    }
    
    // Bring to front in case it's behind other views
    [window bringSubviewToFront:self.blackOverlayView];
    
    // Flash animation
    [UIView animateWithDuration:0.1 animations:^{
        self.blackOverlayView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.blackOverlayView.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }];
}

- (void)showScreenshotAlert {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Security Warning"
                                                                       message:@"Screenshots are not permitted in this application for security reasons."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - Helper Methods

- (UIWindow *)getActiveWindow {
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)topViewController {
    UIWindow *window = [self getActiveWindow];
    UIViewController *rootVC = window.rootViewController;
    
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    return rootVC;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Keyboard Management

- (void)setUpKeyboardHandler {
    self.keyboardHandler = [[KeyboardHandler alloc] initWithView:self.view];
    [self.keyboardHandler startListening];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - DatePickerView Methods

- (void)setupDatePickerForTextField:(UITextField *)textField {
    [textField addDatePickerWithFormat:@"yyyy-MM-dd" pickerMode:CustomDatePickerModeDate];
}

- (void)setupTimePickerForTextField:(UITextField *)textField {
    [textField addDatePickerWithFormat:@"HH:mm" pickerMode:CustomDatePickerModeTime];
}

- (void)setupListPickerForTextField:(UITextField *)textField {
    NSArray *pickerData = @[@"Apple", @"Banana", @"Cherry", @"Date", @"Elderberry", @"Fig", @"Grape"];
    [textField addPickerWithData:pickerData searchEnabled:YES];
}

- (void)showPickerWithTitle:(NSString *)title
                       data:(NSArray<NSString *> *)data
                onSelection:(void (^)(NSString *selectedItem))completion {
    
    self.pickerData = data;
    self.selectionHandler = completion;
    
    if (!self.pickerContainer) {
        [self setupPicker];
    }
    
    // Set title
    UILabel *titleLabel = [self.pickerContainer viewWithTag:101];
    if (titleLabel && [titleLabel isKindOfClass:[UILabel class]]) {
        titleLabel.text = title;
    }
    
    [self.pickerView reloadAllComponents];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerContainer.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
    }];
}


- (void)setupPicker {
    CGFloat height = 260;
    self.pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, height)];
    self.pickerContainer.backgroundColor = [UIColor whiteColor];
    
    // Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.pickerContainer.frame.size.width - 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.tag = 101;
    [self.pickerContainer addSubview:titleLabel];
    
    // Done Button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(self.pickerContainer.frame.size.width - 80, 0, 80, 44);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(pickerDoneTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerContainer addSubview:doneButton];
    
    // Picker View
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 216)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerContainer addSubview:self.pickerView];
    
    [self.view addSubview:self.pickerContainer];
}


- (void)pickerDoneTapped {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    NSString *selectedItem = self.pickerData[selectedRow];
    
    if (self.selectionHandler) {
        self.selectionHandler(selectedItem);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    }];
}

#pragma mark - UIPickerView DataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

#pragma mark - Data Filtering

- (NSArray *)filterData:(NSArray *)arrayData {
    // Step 1: Add @"All" at the beginning
    NSMutableArray *finalList = [NSMutableArray arrayWithObject:@"All"];
    
    // Step 2: Filter out empty strings
    NSPredicate *nonEmptyPredicate = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *filteredStatuses = [arrayData filteredArrayUsingPredicate:nonEmptyPredicate];
    
    // Step 3: Get unique values
    NSArray *uniqueStatuses = [[NSSet setWithArray:filteredStatuses] allObjects];
    [finalList addObjectsFromArray:uniqueStatuses];
    
    return finalList;
}

#pragma mark - Alert & Communication Methods

- (void)alertMsg:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)alertMsgWithTitle:(NSString *)message title:(NSString *)strTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


- (void)phoneCallMethod:(NSString *)phoneNumber {
    // Sanitize phone number (temporary implementation)
    NSString *cleanPhone = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Create the URL scheme to dial the number
    NSString *telURL = [NSString stringWithFormat:@"tel://%@", cleanPhone];
    
    // Check if the device can make a phone call
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:telURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURL]
                                           options:@{}
                                 completionHandler:nil];
    } else {
        [self alertMsg:@"Your device cannot make phone calls."];
    }
}

- (void)shareOnWhatsApp:(NSString *)message phone:(NSString *)phoneNumber {
    // Sanitize inputs (temporary implementation)
    NSString *cleanMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *cleanPhone = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *whatsappURL = [NSString stringWithFormat:@"whatsapp://send?phone=%@&text=%@",
                             cleanPhone,
                             [cleanMessage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:whatsappURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:whatsappURL]
                                           options:@{}
                                 completionHandler:nil];
    } else {
        [self alertMsg:@"WhatsApp is not installed on this device."];
    }
}

- (void)phoneSMSMethod:(NSString *)message number:(NSString *)phoneNumber {
    // Sanitize inputs (temporary implementation)
    NSString *cleanMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *cleanPhone = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.recipients = @[cleanPhone];
        messageController.body = cleanMessage;
        
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        [self alertMsg:@"Your device cannot send SMS messages."];
    }
}

- (void)shareContent:(NSString *)message imageUrl:(NSString *)imageUrl {
    // Sanitize message (temporary implementation)
    NSString *cleanMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *activityItems = [NSMutableArray array];
    
    if (cleanMessage && cleanMessage.length > 0) {
        [activityItems addObject:cleanMessage];
    }
    
    if (imageUrl && imageUrl.length > 0) {
        // Load image from URL and add to activity items
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityItems addObject:image];
                    [self presentActivityViewControllerWithItems:activityItems];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentActivityViewControllerWithItems:activityItems];
                });
            }
        });
    } else {
        [self presentActivityViewControllerWithItems:activityItems];
    }
}

- (void)presentActivityViewControllerWithItems:(NSArray *)items {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    // Exclude some activity types
    activityViewController.excludedActivityTypes = @[
        UIActivityTypeAssignToContact,
        UIActivityTypeAddToReadingList
    ];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Legacy Validation (Deprecated)

- (BOOL)isValidEmail:(NSString *)email {
    // Temporary email validation (temporary implementation)
    if (!email || email.length == 0) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

//NSString *SafeString(id value) {
//    return ([value isKindOfClass:[NSString class]]) ? value : @"";
//}

//- (NSString *)SafeString:(id)value {
NSString *SafeString(id value) {
    if (value == nil || value == [NSNull null]) {
        return @"";
    }

    if (![value isKindOfClass:[NSString class]]) {
        value = [value description];
    }

    if ([value isEqualToString:@"(null)"] || [value isEqualToString:@"<null>"]) {
        return @"";
    }

    return value;
}


#pragma mark -  Select photo from gallery or camera

// Open Camera
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Camera not available."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// Open photo library
- (void)openPhotoLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultSent:
            [self generateHapticFeedback:UIImpactFeedbackStyleLight];
            break;
        case MessageComposeResultFailed:
            [self alertMsg:@"Failed to send SMS message."];
            break;
        case MessageComposeResultCancelled:
            // User cancelled, no action needed
            break;
    }
}

- (void)setUpLeftMenuBtn{
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([ECAT_TYPE isEqualToString:@"3"]){
        //if ([strTemplate isEqualToString:@"2"]){}
        SWRevealViewController *revealController = [self revealViewController];
        //[revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
//        UIImage* image = [UIImage imageNamed:@"menu.png"];
//        CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
//        UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
//        [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
//        [someButton1 addTarget:revealController action:@selector(revealToggle:)
//              forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
//        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:revealController
                                                                            action:@selector(revealToggle:)];
        revealButtonItem.tintColor = UIColor.whiteColor;
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
    }
}


- (void)logoutApp {
    // Clear login data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"mobile"];
    [defaults synchronize];

    // Instantiate HomeVC
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    HomeVC *homeVC =
        [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];

    UINavigationController *navController =
        [[UINavigationController alloc] initWithRootViewController:homeVC];

    // Get the active SceneDelegate
    UIWindowScene *windowScene = nil;

    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }

    if (!windowScene) {
        return;
    }

    SceneDelegate *sceneDelegate =
        (SceneDelegate *)windowScene.delegate;

    UIWindow *window = sceneDelegate.window;

    if (!window) {
        return;
    }

    // Transition to HomeVC
    [UIView transitionWithView:window
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
        window.rootViewController = navController;
    }
                    completion:^(BOOL finished) {
        [window makeKeyAndVisible];
    }];
}

- (void)setUpNavigationLogo {
    UIImage *logoImage = [UIImage imageNamed:@"gautam_icon"];
    
    // Return early if the image is not found
    if (!logoImage) {
        NSLog(@"Logo image not found!");
        return;
    }

    // Create an image view with the logo
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:logoImage];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.frame = CGRectMake(0, 0, 160, 60); // Adjust size as needed

    // Optional: wrap it in a container view (not always necessary, but sometimes helps with layout)
    UIView *containerView = [[UIView alloc] initWithFrame:titleImageView.frame];
    [containerView addSubview:titleImageView];

    // Center the imageView within container if needed
    titleImageView.center = containerView.center;

    // Set the navigation item's titleView
    self.navigationItem.titleView = containerView;
}


-(void)GET_ITEMSHOWApi {
    [[BusyIndicator sharedInstance] startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@&apptype_4=%@",ip,ipusername,pswd,db,ftppath,apptype,ECAT_TYPE,mobile,ECAT_TYPE];
        
        URL_API =[WEB_URL URL_ITEMSHOW];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_itemshow.php",ip];
        loginRequest=[NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@&apptype_4=%@",ip,ftppath,apptype,ECAT_TYPE,mobile,ECAT_TYPE];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&apptype_4=%@",apptype,mobile,ECAT_TYPE];
        URL_API =[WEB_URL URL_ITEMSHOW];
    }
    
    NSString *api = [NSString stringWithFormat: @"%@", URL_API];
    
    NSLog(@"URL_ITEMSHOW ::::::::::::::::::::::::::::::: %@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_showapi:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void)parseLogin_showapi:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            // Retrieve the arrays directly
            NSArray *cus_details = [pDict objectForKey:@"cus_details"];
            NSArray *vist_reason = [pDict objectForKey:@"vist_reason"];
            NSArray *qty = [pDict objectForKey:@"qty"];
            NSArray *rgap = [pDict objectForKey:@"rgap"];
            NSArray *chqty = [pDict objectForKey:@"chqty"];
            NSArray *sorder = [pDict objectForKey:@"sorder"];
            NSArray *interested = [pDict objectForKey:@"interested"];
            NSArray *addyourdemand = [pDict objectForKey:@"addyourdemand"];
            NSArray *wtgap = [pDict objectForKey:@"wtgap"];
            NSArray *wtdec = [pDict objectForKey:@"wtdec"];
            NSArray *printer = [pDict objectForKey:@"printer"];
            NSArray *tgstatus = [pDict objectForKey:@"tgstatus"];
            NSArray *instk = [pDict objectForKey:@"instk"];
            NSArray *outstk = [pDict objectForKey:@"outstk"];
            NSArray *disrate = [pDict objectForKey:@"disrate"];
            NSArray *vcmobile = [pDict objectForKey:@"vcmobile"];
            NSArray *displayby = [pDict objectForKey:@"displayby"];
            NSArray *visitdis = [pDict objectForKey:@"visitdis"];
            NSArray *configgst = [pDict objectForKey:@"configgst"];
            NSArray *screenshot = [pDict objectForKey:@"screenshot"];
            NSArray *appversion = [pDict objectForKey:@"appversion"];
            NSArray *appupdatedate = [pDict objectForKey:@"appupdatedate"];
            NSArray *finedecimal = [pDict objectForKey:@"finedecimal"];
            NSArray *sbhav_vrval = [pDict objectForKey:@"sbhav_vrval"];
            NSArray *gbhav_vrval = [pDict objectForKey:@"gbhav_vrval"];
            NSArray *salesman_dis = [pDict objectForKey:@"salesman_dis"];
            
            
            // Save to NSUserDefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sbhav_vrval forKey:@"sbhav_vrval"];
            [defaults setObject:gbhav_vrval forKey:@"gbhav_vrval"];
            [defaults setObject:finedecimal forKey:@"finedecimal"];
            [defaults setObject:cus_details forKey:@"cus_details"];
            [defaults setObject:vist_reason forKey:@"vist_reason"];
            [defaults setObject:qty forKey:@"qty"];
            [defaults setObject:rgap forKey:@"rgap"];
            [defaults setObject:chqty forKey:@"chqty"];
            [defaults setObject:sorder forKey:@"sorder"];
            [defaults setObject:interested forKey:@"interested"];
            [defaults setObject:addyourdemand forKey:@"addyourdemand"];
            [defaults setObject:wtgap forKey:@"wtgap"];
            [defaults setObject:wtdec forKey:@"wtdec"];
            [defaults setObject:printer forKey:@"printer"];
            [defaults setObject:tgstatus forKey:@"tgstatus"];
            [defaults setObject:instk forKey:@"instk"];
            [defaults setObject:outstk forKey:@"outstk"];
            [defaults setObject:disrate forKey:@"disrate"];
            [defaults setObject:vcmobile forKey:@"vcmobile"];
            [defaults setObject:displayby forKey:@"displayby"];
            [defaults setObject:visitdis forKey:@"visitdis"];
            [defaults setObject:configgst forKey:@"configgst"];
            [defaults setObject:screenshot forKey:@"screenshot"];
            [defaults setObject:appversion forKey:@"appversion"];
            [defaults setObject:appupdatedate forKey:@"appupdatedate"];
            [defaults setObject:salesman_dis forKey:@"salesman_dis"];
            
            
            // Synchronize to ensure the changes are saved
            [defaults synchronize];
            
            if ([str_success isEqualToString:@"1"]) {
                
                NSMutableArray *ns_item1 = [pDict objectForKey:@"item1"];
                NSString *item1 = [ns_item1 description];
                NSMutableArray *ns_item2 = [pDict objectForKey:@"item2"];
                NSString *item2 = [ns_item2 description];
                NSMutableArray *ns_item3 = [pDict objectForKey:@"item3"];
                NSString *item3 = [ns_item3 description];
                NSMutableArray *ns_item4 = [pDict objectForKey:@"item4"];
                NSString *item4 = [ns_item4 description];
                NSMutableArray *ns_item5 = [pDict objectForKey:@"item5"];
                NSString *item5 = [ns_item5 description];
                NSMutableArray *ns_item6 = [pDict objectForKey:@"item6"];
                NSString *item6 = [ns_item6 description];
                NSMutableArray *ns_idesc = [pDict objectForKey:@"idesc"];
                NSString *idesc = [ns_idesc description];
                NSMutableArray *ns_tgno = [pDict objectForKey:@"tgno"];
                NSString *tgno = [ns_tgno description];
                NSMutableArray *ns_gwt = [pDict objectForKey:@"gwt"];
                NSString *gwt = [ns_gwt description];
                NSMutableArray *ns_wt = [pDict objectForKey:@"wt"];
                NSString *wt = [ns_wt description];
                NSMutableArray *ns_sdiwt = [pDict objectForKey:@"sdiwt"];
                NSString *sdiwt = [ns_sdiwt description];
                NSMutableArray *ns_sstnwt = [pDict objectForKey:@"sstnwt"];
                NSString *sstnwt = [ns_sstnwt description];
                NSMutableArray *ns_stamp = [pDict objectForKey:@"stamp"];
                NSString *stamp = [ns_stamp description];
                NSMutableArray *ns_mrp = [pDict objectForKey:@"mrp"];
                NSString *mrp = [ns_mrp description];
                NSMutableArray *ns_gst = [pDict objectForKey:@"gst"];
                NSString *gst = [ns_gst description];
                NSMutableArray *ns_remarks = [pDict objectForKey:@"remarks"];
                NSString *remarks = [ns_remarks description];
                NSMutableArray *ns_m_id = [pDict objectForKey:@"m_id"];
                NSString *m_id = [ns_m_id description];
                
                [[NSUserDefaults standardUserDefaults] setObject:idesc forKey:@"adddesign_idesc"];
                [[NSUserDefaults standardUserDefaults] setObject:tgno forKey:@"adddesign_tgno"];
                [[NSUserDefaults standardUserDefaults] setObject:gwt forKey:@"adddesign_gwt"];
                [[NSUserDefaults standardUserDefaults] setObject:wt forKey:@"adddesign_wt"];
                [[NSUserDefaults standardUserDefaults] setObject:sdiwt forKey:@"adddesign_sdiwt"];
                [[NSUserDefaults standardUserDefaults] setObject:sstnwt forKey:@"adddesign_sstnwt"];
                [[NSUserDefaults standardUserDefaults] setObject:stamp forKey:@"adddesign_stamp"];
                [[NSUserDefaults standardUserDefaults] setObject:mrp forKey:@"adddesign_mrp"];
                [[NSUserDefaults standardUserDefaults] setObject:gst forKey:@"adddesign_gst"];
                [[NSUserDefaults standardUserDefaults] setObject:remarks forKey:@"adddesign_remarks"];
                [[NSUserDefaults standardUserDefaults] setObject:item1 forKey:@"item1"];
                [[NSUserDefaults standardUserDefaults] setObject:item2 forKey:@"item2"];
                [[NSUserDefaults standardUserDefaults] setObject:item3 forKey:@"item3"];
                [[NSUserDefaults standardUserDefaults] setObject:item4 forKey:@"item4"];
                [[NSUserDefaults standardUserDefaults] setObject:item5 forKey:@"item5"];
                [[NSUserDefaults standardUserDefaults] setObject:item6 forKey:@"item6"];
                [[NSUserDefaults standardUserDefaults] setObject:m_id forKey:@"m_id"];
                
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                                message:str_msg
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                    
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark: - Voice Methods

- (void)setUpListening {
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    
    if (status != SFSpeechRecognizerAuthorizationStatusAuthorized) {
        NSLog(@"❌ Speech recognition not authorized. Current status: %ld", (long)status);
        [self alertMsg:@"Speech recognition access required. Please enable it in Settings."];
        return;
    }
    
    // Check if running on simulator
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"⚠️ Running on iOS Simulator - Voice recognition may have limitations");
    [self alertMsg:@"Voice recognition on simulator may have limitations. For best results, test on a physical device."];
#endif
}

- (void)stopListening {
    NSLog(@"🛑 Stopping voice recognition...");
    
    // Cancel silence timer
    if (self.silenceTimer) {
        [self.silenceTimer invalidate];
        self.silenceTimer = nil;
    }
    
    // Stop audio engine
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.audioEngine.inputNode removeTapOnBus:0];
    }
    
    // End recognition request
    if (self.recognitionRequest) {
        [self.recognitionRequest endAudio];
    }
    
    // Cancel recognition task
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
    }
    
    // Reset properties
    self.recognitionRequest = nil;
    self.recognitionTask = nil;
    self.isListening = NO;
    
    // Reset navigation flag
    self.isNavigating = NO;
    
    // Deactivate audio session
    NSError *error;
    if (![[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"⚠️ Warning: Could not deactivate audio session: %@", error.localizedDescription);
        // Don't show error to user for deactivation issues
    }
    
    // Dismiss alert on main queue
    if (self.listeningAlert) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeningAlert dismissViewControllerAnimated:YES completion:nil];
            self.listeningAlert = nil;
        });
    }
    
    NSLog(@"✅ Voice recognition stopped successfully");
}

@end
