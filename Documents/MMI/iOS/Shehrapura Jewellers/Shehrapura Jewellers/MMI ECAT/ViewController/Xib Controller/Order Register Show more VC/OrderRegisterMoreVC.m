//
//  OrderRegisterMoreVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "OrderRegisterMoreVC.h"
#import "UIImageView+WebCache.h"

@interface OrderRegisterMoreVC ()
@end

@implementation OrderRegisterMoreVC

- (instancetype)init {
    self = [super initWithNibName:@"OrderRegisterMoreVC" bundle:nil];
    if (self) {
        // Any additional setup
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self parsData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void) parsData{
    _subView.layer.cornerRadius = 5;
    _subView.layer.borderColor = [UIColor blackColor].CGColor;
    _subView.layer.borderWidth = 1;
    if ([self.arrayData count] > 0){
        NSURL *URL;
        URL = [NSURL URLWithString:[self.arrayData valueForKey:@"img_url"]];
        NSString *myString = [URL absoluteString];
        [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        [self.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                            placeholderImage:[UIImage imageNamed:@"1024.png"] options: 0 ];
        
        self.lblJobNo.text = [NSString stringWithFormat:@"%@",[self.arrayData valueForKey:@"jobno"]];
        self.lblStamp.text = [NSString stringWithFormat:@"%@",[self.arrayData valueForKey:@"curstamp"]];
        self.lblName.text = [NSString stringWithFormat:@"%@",[self.arrayData valueForKey:@"cname"]];
        self.lblDate.text = [NSString stringWithFormat:@"%@",[self.arrayData valueForKey:@"deldate"]];
        self.lblCurrentWt.text = [NSString stringWithFormat:@"Wt %@",[self.arrayData valueForKey:@"curgwt"]];
        NSString *str_Mobile = [self.arrayData valueForKey:@"mobile"];
        NSString *str_Status = [self.arrayData valueForKey:@"ostatus"];
        self.lblMobile.text = [NSString stringWithFormat:@"%@",str_Mobile];
        self.lblStatus.text = [NSString stringWithFormat:@"%@",str_Status];
        self.lblRemark.text = @"";
        self.lblAdvance.text = @"";
        self.lblKarigar.text = @"";
        self.lblKDelivery.text = @"";
    }
}

#pragma mark - Button Action Methods

- (IBAction)cancelButton:(id)sender{
    // Dismiss the presented view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButton:(id)sender{
    UIImage *imageToSave = self.imgViewItem.image; // Get the image from the image view
       
       if (imageToSave) {
           // Save the image to the photo library
           UIImageWriteToSavedPhotosAlbum(imageToSave, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
       }
}

// Callback after saving the image
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        // Handle error (if any)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Failed to save image."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // Image saved successfully
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                       message:@"Image saved to Photos."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
