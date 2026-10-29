//
//  KeyboardHandler.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 17/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

// KeyboardHandler.h
#import <UIKit/UIKit.h>

@interface KeyboardHandler : NSObject

- (instancetype)initWithView:(UIView *)view;
- (void)startListening;
- (void)stopListening;

@end

