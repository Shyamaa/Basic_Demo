//
//  CustomPopUp.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 19/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "CustomPopUp.h"

@implementation CustomPopUp
{
     
    float popUpX;
    CGRect popUpRect;
}
@synthesize _click_delegate, _parent;
 
 
-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate{
     
    self._click_delegate = theDelegate;
    self._parent = parent;
     
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
     
    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight);
    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
     
    childPopUp = [UIView new];
    float popUpHeight = screenHeight/3;
     
    popUpX = 20.0;
     
    popUpRect = CGRectMake(popUpX, (screenHeight - popUpHeight)/2, screenWidth - (popUpX * 2), popUpHeight);
    childPopUp.center = self.center;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self setBorderOnly:childPopUp withBGColor:[UIColor orangeColor] withCornerRadius:5.0 andBorderWidth:0.0 andBorderColor:[UIColor greenColor] WithAlpha:1];
    childPopUp.frame = popUpRect;
    [self addSubview:childPopUp];
   
    [self addLabel];
     
    [self addButton];
     
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
     
}
 
-(void) show{
 
    [self._parent.view addSubview:self];
}
 
-(void) addLabel{
     
    // Add Label
    UILabel *lblForDisplay =[[UILabel alloc]initWithFrame:CGRectMake(popUpX, popUpX, popUpRect.size.width - popUpX, popUpX)];
    lblForDisplay.backgroundColor=[UIColor clearColor];
    lblForDisplay.textColor=[UIColor blackColor];
    lblForDisplay.text=@"This is a custom Alert";
    [childPopUp addSubview:lblForDisplay];
     
}
 
 
-(void) addButton{
     
    // Add Button
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(popUpX, childPopUp.frame.size.height - 50, popUpRect.size.width - 40, 40)];
    okBtn.backgroundColor=[UIColor blueColor];
    [self setBorderOnly:okBtn  withBGColor:[UIColor greenColor] withCornerRadius:5.0 andBorderWidth:0.0 andBorderColor:[UIColor greenColor] WithAlpha:1];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(OnOKClick:) forControlEvents:UIControlEventTouchDown];
    [childPopUp addSubview:okBtn];
     
}
 
-(IBAction)OnOKClick :(id) sender{
     
    [_click_delegate okClicked];
     
}
 
-(void) show : (UIViewController *) parent{
     
}
 
-(void) hide{
     
    [self removeFromSuperview];
     
}
 
- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}
 
- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}
 
 
-(void) setBorderOnly:(UIView *) theView withBGColor:(UIColor *) color withCornerRadius :(float) radius andBorderWidth :(float) borderWidth andBorderColor :(UIColor *) bgColor WithAlpha:(float) curAlpha
{
    theView.layer.borderWidth = borderWidth;
    theView.layer.cornerRadius = radius;
    theView.layer.borderColor = [color CGColor];
    [theView setBackgroundColor:[UIColor grayColor]];
//    UIColor *c = [color colorWithAlphaComponent:curAlpha];
//    theView.layer.backgroundColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:255.0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]);
}

@end
