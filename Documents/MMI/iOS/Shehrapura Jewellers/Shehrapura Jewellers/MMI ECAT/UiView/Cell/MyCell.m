//
//  MyCell.m
//  TestCollectionViewWithXIB
//
//  Created by Quy Sang Le on 2/3/13.
//  Copyright (c) 2013 Quy Sang Le. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

@synthesize imgeDataArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
//        self.backgroundColor = [UIColor colorWithRed:1.0/255.0f green:69.0/255.0f blue:142.0/255.0 alpha:1.0];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    // This code is only called once
//    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    //[[BusyIndicator sharedInstance]startIndicator];
//    self.activityIndicator.center = self.imgeDataArray.center;
//    self.activityIndicator.hidesWhenStopped = YES;
////        CGRect newFrame = CGRectMake(30, 15, 100, 100);
////        imgeDataArray.frame = newFrame;
//    self.activityIndicator.color=[UIColor redColor];
//    [self.imgeDataArray addSubview:self.activityIndicator];

//    [_back_view.layer setMasksToBounds:YES];
//    [_back_view.layer setCornerRadius:10.0f];
//    [_back_view.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
//    [_back_view.layer setBorderWidth:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
