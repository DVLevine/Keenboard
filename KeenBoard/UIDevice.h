//
//  UIDevice.h
//  KeenBoard
//
//  Created by Daniel Visan Levine on 4/24/16.
//  Copyright © 2016 D-Line. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITapticEngine.h"

@interface UIDevice (Private)
- (UITapticEngine *)_tapticEngine;
@end

