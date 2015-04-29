//
//  JTSTweenerTypes.h
//  JTSTweener
//
//  Created by Joshua Sullivan on 2/26/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#ifndef JTSTweener_JTSTweenerTypes_h
#define JTSTweener_JTSTweenerTypes_h

@import CoreGraphics;

/**
* Translates a ratio in the range 0.0 - 1.0 to another value, generally (but not necessarily) in the same range.
*/
typedef CGFloat (^EasingCurve)(CGFloat ratio);

#endif
