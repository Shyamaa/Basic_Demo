#import "PopupViewController.h"
#import "CustomPickerView.h"

@interface PopupViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) CustomPickerView *pickerView;

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set background color with transparency
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // Create container view with rounded corners and shadow
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.center.y - 150, self.view.frame.size.width - 40, 300)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOffset = CGSizeMake(0, 2);
    containerView.layer.shadowOpacity = 0.5;
    containerView.layer.shadowRadius = 4.0;
    [self.view addSubview:containerView];
    
    // Add gradient background to container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = containerView.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor lightGrayColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [containerView.layer insertSublayer:gradientLayer atIndex:0];
    
    // Add title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 40)];
    titleLabel.text = @"Select Category";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor darkGrayColor];
    [containerView addSubview:titleLabel];
    
    // Add custom picker view
    self.pickerView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 40, containerView.frame.size.width, 200)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [containerView addSubview:self.pickerView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(containerView.frame.size.width / 2, 250, containerView.frame.size.width / 2, 50);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 250, containerView.frame.size.width / 2, 50);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [containerView addSubview:cancelButton];
}

- (void)doneButtonPressed {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    self.selectedItem = self.dropdownItems[selectedRow];
    if (self.completionHandler) {
        self.completionHandler(self.selectedItem);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dropdownItems.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dropdownItems[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:21];
        label.textColor = [UIColor darkGrayColor];
    }
    label.text = self.dropdownItems[row];
    return label;
}

@end
