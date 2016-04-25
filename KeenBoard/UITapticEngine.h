//
//  UITapticEngine.h
//  KeenBoard
//
//  Created by Daniel Visan Levine on 4/24/16.
//  Copyright © 2016 D-Line. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITapticEngine : NSObject
- (void)actuateFeedback:(int)feedbackType;
@end
