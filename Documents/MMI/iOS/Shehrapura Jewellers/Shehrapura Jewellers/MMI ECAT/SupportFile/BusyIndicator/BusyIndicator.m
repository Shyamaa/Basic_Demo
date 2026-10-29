//
//  BusyIndicator.h
//  SectionProposal
//
//  Created by Robin on 28/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "BusyIndicator.h"
#import "AppDelegate.h"

@interface BusyIndicator ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CustomCellBackgroundView *roundedRectView;

@end

@implementation BusyIndicator

// Use dispatch_once to ensure a single instance is created safely across threads.
+ (instancetype)sharedInstance {
    static BusyIndicator *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initIndicator];
    }
    return self;
}

- (void)initIndicator {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    [self setFrame:mainBounds];

    CGRect rectFrame = CGRectMake([self frame].size.width / 2 - 30, [self bounds].size.height / 2 - 30, 60, 60);
    self.roundedRectView = [[CustomCellBackgroundView alloc] initWithFrame:rectFrame backgroundColor:[UIColor blackColor] borderColor:[UIColor whiteColor]];
    self.roundedRectView.alpha = 0.8;
    self.roundedRectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.roundedRectView];

    CGRect indicatorBounds = CGRectMake(rectFrame.size.width / 2 - 15, rectFrame.size.height / 2 - 15, 30, 30);
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorBounds];
    
    if (@available(iOS 13.0, *)) {
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    } else {
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    }

    //self.activityIndicator.color = [UIColor redColor];
    self.activityIndicator.color = [UIColor colorNamed:@"appRed_Color"];
    [self.roundedRectView addSubview:self.activityIndicator];
}

- (void)startIndicator {
    // Ensure updates are on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:self];
        [appDelegate.window bringSubviewToFront:self];
        [self.activityIndicator startAnimating];
    });
}

- (void)stopIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self removeFromSuperview];
    });
}

@end
