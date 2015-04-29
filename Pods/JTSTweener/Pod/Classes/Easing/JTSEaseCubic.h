//
//  JTSEaseCubic.h
//  JTSTweener
//
//  Created by Joshua Sullivan on 2/26/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import Foundation;
#import "JTSTweenerTypes.h"

@interface JTSEaseCubic : NSObject

+ (EasingCurve)easeIn;
+ (EasingCurve)easeOut;
+ (EasingCurve)easeInOut;

@end
