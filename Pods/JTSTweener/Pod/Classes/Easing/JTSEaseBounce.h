//
// Created by Joshua Sullivan on 2/28/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTSTweenerTypes.h"


@interface JTSEaseBounce : NSObject

+ (EasingCurve)easeIn;
+ (EasingCurve)easeOut;
+ (EasingCurve)easeInOut;

@end