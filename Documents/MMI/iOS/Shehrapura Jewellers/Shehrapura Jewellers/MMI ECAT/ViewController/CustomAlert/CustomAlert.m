//
//  CustomAlert.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 17/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "CustomAlert.h"



#define OK_BUTTON_TAG       888
#define CANCEL_BUTTON_TAG   999
#define ANIMATION_DURATION  0.25

@interface CustomAlert ()
-(void)addOrRemoveButtonWithTag:(int)tag andActionToPerform:(BOOL)shouldRemove;

@end

@implementation CustomAlert
-(id)init{
    self = [super init];
    if (self) {
         
    }
     
return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

-(void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message{
    CGFloat statusBarOffset;
     
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        // If the status bar is not hidden then we get its height and keep it to the statusBarOffset variable.
        // However, there is a small trick here that needs to be done.
        // In portrait orientation the status bar size is 320.0 x 20.0 pixels.
        // In landscape orientation the status bar size is 20.0 x 480.0 pixels (or 20.0 x 568.0 pixels on iPhone 5).
        // We need to check which is the smallest value (width or height). This is the value that will be kept.
        // At first we get the status bar size.
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        if (statusBarSize.width < statusBarSize.height) {
            // If the width is smaller than the height then this is the value we need.
            statusBarOffset = statusBarSize.width;
        }
        else{
            // Otherwise the height is the desired value that we want to keep.
            statusBarOffset = statusBarSize.height;
        }
    }
    else{
        // Otherwise set it to 0.0.
        statusBarOffset = 0.0;
    }
 
     
    // Declare the following variables that will take their values
    // depending on the orientation.
    CGFloat width, height, offsetX, offsetY;
     
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        // If the orientation is landscape then the width
        // gets the targetView's height value and the height gets
        // the targetView's width value.
        width = targetView.frame.size.height;
        height = targetView.frame.size.width;
         
        offsetX = -statusBarOffset;
        offsetY = 0.0;
    }
    else{
        // Otherwise the width is width and the height is height.
        width = targetView.frame.size.width;
        height = targetView.frame.size.height;
         
        offsetX = 0.0;
        offsetY = -statusBarOffset;
    }
     
    // Set the view's frame and add it to the target view.
    [self.view setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, width, height)];
    [self.view setFrame:CGRectOffset(self.view.frame, offsetX, offsetY)];
    [targetView addSubview:self.view];
     
        
    // Set the initial frame of the message view.
    // It should be out of the visible area of the screen.
    [_viewMessage setFrame:CGRectMake(0.0, -_viewMessage.frame.size.height, _viewMessage.frame.size.width, _viewMessage.frame.size.height)];
     
    // Animate the display of the message view.
    // We change the y point of its origin by setting it to 0 from the -height value point we previously set it.
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_viewMessage setFrame:CGRectMake(0.0, 0.0, _viewMessage.frame.size.width, _viewMessage.frame.size.height)];
    [UIView commitAnimations];
     
    // Set the message that will be displayed.
    [_lblMessage setText:message];
}

-(void)removeCustomAlertFromView{
    // Animate the message view dissapearing.
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_viewMessage setFrame:CGRectMake(0.0, -_viewMessage.frame.size.height, _viewMessage.frame.size.width, _viewMessage.frame.size.height)];
    [UIView commitAnimations];
     
    // Remove the main view from the super view as well after the animation is finished.
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:ANIMATION_DURATION];
}
-(void)removeCustomAlertFromViewInstantly{
    [self.view removeFromSuperview];
}

-(BOOL)isOkayButtonRemoved{
    if ([[_toolbar items] indexOfObject:_btnOK] == NSNotFound) {
        return YES;
    }
    else{
        return NO;
    }
}
 
 
-(BOOL)isCancelButtonRemoved {
    if ([[_toolbar items] indexOfObject:_btnCancel] == NSNotFound) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)removeOkayButton:(BOOL)shouldRemove{
    if ([self isOkayButtonRemoved] != shouldRemove) {
        [self addOrRemoveButtonWithTag:OK_BUTTON_TAG andActionToPerform:shouldRemove];
    }
}
 
 
-(void)removeCancelButton:(BOOL)shouldRemove {
    if ([self isCancelButtonRemoved] != shouldRemove) {
        [self addOrRemoveButtonWithTag:CANCEL_BUTTON_TAG andActionToPerform:shouldRemove];
    }
}

-(void)addOrRemoveButtonWithTag:(int)tag andActionToPerform:(BOOL)shouldRemove{
    NSMutableArray *items = [[_toolbar items] mutableCopy];
     
    int flexSpaceIndex = [items indexOfObject:_flexSpace];
    int btnIndex = (tag == OK_BUTTON_TAG) ? flexSpaceIndex + 1 : 0;
         
    if (shouldRemove) {
        [items removeObjectAtIndex:btnIndex];
    }
    else{
        if (tag == OK_BUTTON_TAG) {
            [items insertObject:_btnOK atIndex:btnIndex];
        }
        else{
            [items insertObject:_btnCancel atIndex:btnIndex];
        }
    }
     
    [_toolbar setItems:(NSArray *)items];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
