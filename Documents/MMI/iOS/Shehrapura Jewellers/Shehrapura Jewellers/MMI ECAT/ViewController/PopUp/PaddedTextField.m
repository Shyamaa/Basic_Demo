//
//  PaddedTextField.m
//  Jewel Desk
//
//  Created by App Dev on 20/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "PaddedTextField.h"

@implementation PaddedTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
