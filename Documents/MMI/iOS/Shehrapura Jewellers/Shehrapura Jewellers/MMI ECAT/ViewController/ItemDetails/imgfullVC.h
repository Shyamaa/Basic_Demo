//
//  imgfullVC.h
//  Jwelly Customer
//
//  Created by mmsoft116 on 08/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import <ImageIO/ImageIO.h>
#import "BusyIndicator.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface imgfullVC : BaseViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    //    UIImage *image;
    UIPinchGestureRecognizer *twoFingerPinch;
    UIButton *zoomOutButton;
    UIButton *zoomInButton;
    NSMutableArray * array_design;
    IBOutlet UIButton *btn_prvs;
    IBOutlet UIButton *btn_next;
}

@property (strong, nonatomic) NSString *imageUrlString;
@property (strong, nonatomic) NSString *str_img2;
@property (strong, nonatomic) NSString *str_img3;
@property (strong, nonatomic) NSString *str_img4;
@property (strong, nonatomic) NSString *str_img5;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;

- (IBAction)btn_prvs:(id)sender;
- (IBAction)btn_next:(id)sender;

@end

NS_ASSUME_NONNULL_END
