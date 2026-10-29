//
//  imgfullVC.m
//  Jwelly Customer
//
//  Created by mmsoft116 on 08/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "imgfullVC.h"
#import "UIImageView+WebCache.h"
#import "HomeBannerCell.h"

@interface imgfullVC ()
{
    NSInteger int_img;
    
}
@end

@implementation imgfullVC
@synthesize imageUrlString,str_img2,str_img3,str_img4,str_img5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    array_design = [[NSMutableArray alloc]init];
    
    [array_design addObject:imageUrlString];
    [array_design addObject:str_img2];
    [array_design addObject:str_img3];
    [array_design addObject:str_img4];
    //[array_design addObject:str_img5];
    
    //    [array_design addObject:@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg"];
    //       [array_design addObject:@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS174.jpg"];
    //       [array_design addObject:@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg"];
    //       [array_design addObject:@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS174.jpg"];
    //       [array_design addObject:@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg"];
    //
    //    array_design = @[@"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg", @"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS174.jpg", @"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg", @"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS174.jpg", @"http://crm.mmisoftwares.com/mmiapps/jwellyecattesting/collection/IRYS177.jpg"];
    
    
    NSLog(@"str_image : %@",imageUrlString);
    NSLog(@"str_image2 : %@",str_img2);
    NSLog(@"str_image3 : %@",str_img3);
    
//    if (str_img2.length == 0) {
//        btn_next.hidden = YES;
//    }
    int_img = 0;
    btn_prvs.hidden = YES;
    self.lblCount.text = @"1";
    //self->img.userInteractionEnabled = YES;
    //self->img.backgroundColor = [UIColor clearColor];
    //self->img.frame = CGRectMake(10, 10, self.view.frame.size.width-10, self.view.frame.size.height-10);
    //self->img.contentMode = UIViewContentModeScaleAspectFit;
    //self->img.clipsToBounds = YES;
    //[self.scrollView addSubview:self->img];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.scrollView addGestureRecognizer:doubleTap];
    self.scrollView.maximumZoomScale=2.0;
    [self.scrollView setAlwaysBounceVertical:NO];
    self.scrollView.delegate=self;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.img setUserInteractionEnabled:YES];
        NSLog(@"item_image = %@",self.img);
        self->zoomInButton = [[UIButton alloc]init];
        self->zoomOutButton = [[UIButton alloc]init];
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:self->imageUrlString]
                    placeholderImage:[UIImage imageNamed:@"1024.png"] options:self == 0 ? SDWebImageRefreshCached:YES];
        [[BusyIndicator sharedInstance]stopIndicator];
        
    });
}

- (void)viewDidLayoutSubviews
{
    //[scrollView setContentSize:CGSizeMake(320, 604)];
}

- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    
}

- (IBAction)btn_next:(id)sender {
    int_img = int_img+1;
    btn_prvs.hidden = NO;
    if (int_img == [array_design count]-1){
        btn_next.hidden = YES;
    }
    NSLog(@"int_img btn_next ::::::::::::::: %ld",(long)int_img);
    self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)int_img+1];
    NSString * str_pay = [array_design objectAtIndex:int_img];
    [self scrollData_Com:str_pay];
}

- (IBAction)btn_prvs:(id)sender {
    int_img = int_img-1;
    btn_next.hidden = NO;
    if (int_img == 0) {
        btn_prvs.hidden = YES;
    }else{
    }
    self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)int_img+1];
    NSLog(@"int_img ::::::::::::::: %ld",(long)int_img);
    
    NSString * str_pay = [array_design objectAtIndex:int_img];
    NSLog(@"str_pay ::::::::::::::: %@",str_pay);
    [self scrollData_Com:str_pay];
}

- (void)scrollData_Com:(NSString *)str_img  {
    NSLog(@"str_img NSString ::::::::::::::: %@",str_img);
    [self.img sd_setImageWithURL:[NSURL URLWithString:str_img] placeholderImage:[UIImage imageNamed:@"1024.png"]];
    self.img.contentMode = UIViewContentModeScaleAspectFit;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews.firstObject;
}

@end
